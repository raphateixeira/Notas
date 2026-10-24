%{
===========================================================================
 SCRIPT: edmd_inversor_lcl_rbf.m
 DESCRIÇÃO:
   Aproximação da dinâmica de um inversor trifásico com filtro LCL no 
   referencial d-q utilizando EDMD com RBFs (Radial Basis Functions) 
   e Regularização Ridge.

 ESTRUTURA DO CÓDIGO:
   1. Definição dos parâmetros do inversor/filtro e simulação (ode45).
   2. Normalização dos estados e seleção de centros de RBF.
   3. Construção do dicionário Psi(x) = [x_norm; RBFs].
   4. Estimação do Operador de Koopman com regularização Tikhonov (lambda).
   5. Validação e comparação entre modelo real e Koopman.
===========================================================================
%}

clear; clc; close all;

%% 1. Parâmetros Elétricos e do Sistema
par.R1 = 0.1;    % Resistência lado inversor (Ohm)
par.L1 = 2.0e-3; % Indutância lado inversor (H)
par.C  = 10e-6;  % Capacitância do filtro (F)
par.R2 = 0.1;    % Resistência lado rede (Ohm)
par.L2 = 1.5e-3; % Indutância lado rede (H)
par.w  = 2*pi*60;% Frequência angular da rede (rad/s)
par.Vgrid = [220; 0]; % Tensão da rede d-q (V)

Ts = 1e-4;       % Período de amostragem (10 kHz)
N_steps = 3000;  % Passos da simulação de treino

%% 2. Coleta de Dados de Treino (Simulação Não Linear)
x0 = zeros(6,1); 
X = zeros(6, N_steps);
U = zeros(2, N_steps);

% Entrada de controle com variação aleatória de frequência e ruído
rng(42);
U(1, :) = 220 + 30*sign(sin(2*pi*20*(0:N_steps-1)*Ts)) + 5*randn(1, N_steps);
U(2, :) = 10  + 20*sign(cos(2*pi*15*(0:N_steps-1)*Ts)) + 5*randn(1, N_steps);

x_curr = x0;
for k = 1:N_steps
    X(:, k) = x_curr;
    u_k = U(:, k);
    [~, x_next] = ode45(@(t, x) lcl_dq_dynamics(t, x, u_k, par), [0 Ts], x_curr);
    x_curr = x_next(end, :)';
end

% Separando pares x_k -> x_{k+1}
X_k  = X(:, 1:end-1);
X_kp = X(:, 2:end);
U_k  = U(:, 1:end-1);

%% 3. Normalização dos Dados e Seleção de Centros RBF
mu_x = mean(X_k, 2);
std_x = std(X_k, 0, 2) + 1e-6; % Evita divisão por zero

X_k_norm  = (X_k  - mu_x) ./ std_x;
X_kp_norm = (X_kp - mu_x) ./ std_x;

% Seleção de N_centers amostrados do conjunto de treino
N_centers = 40;
gamma_rbf = 0.15; % Largura do kernel RBF

idx_centers = randperm(size(X_k_norm, 2), N_centers);
centers = X_k_norm(:, idx_centers);

%% 4. Mapeamento para Espaço de Observáveis Psi(x)
Psi_Xk  = build_observables_rbf(X_k_norm, centers, gamma_rbf);
Psi_Xkp = build_observables_rbf(X_kp_norm, centers, gamma_rbf);

%% 5. Estimação via EDMD com Regularização Ridge
Omega = [Psi_Xk; U_k];
lambda = 1e-3; % Fator de regularização

% Identificação: AB_k = Psi_Xkp * Omega' * inv(Omega * Omega' + lambda*I)
AB_k = (Psi_Xkp * Omega') / (Omega * Omega' + lambda * eye(size(Omega, 1)));

K_obs = size(Psi_Xk, 1);
A_k = AB_k(:, 1:K_obs);
B_k = AB_k(:, K_obs+1:end);

%% 6. Validação do Modelo Identificado
N_val = 600;
X_val  = zeros(6, N_val);
X_koop = zeros(6, N_val);

% Sinal de entrada de teste (diferente do treino)
U_val = [220 + 25*sin(2*pi*8*(0:N_val-1)*Ts); 
           20*cos(2*pi*8*(0:N_val-1)*Ts)];

x_real = [5; -2; 210; 10; 4; -1]; % Condição inicial não nula
x_koop_norm = (x_real - mu_x) ./ std_x;
psi_k = build_observables_rbf(x_koop_norm, centers, gamma_rbf);

for k = 1:N_val
    X_val(:, k) = x_real;
    
    % Reconstrução dos estados físicos reais a partir da normalização
    X_koop(:, k) = (psi_k(1:6) .* std_x) + mu_x;
    
    u_k = U_val(:, k);
    
    % 1. Evolução no sistema real
    [~, x_next] = ode45(@(t, x) lcl_dq_dynamics(t, x, u_k, par), [0 Ts], x_real);
    x_real = x_next(end, :)';
    
    % 2. Evolução no espaço de Koopman
    psi_k = A_k * psi_k + B_k * u_k;
end

%% 7. Plotagem dos Resultados
t_val = (0:N_val-1)*Ts;

figure('Name', 'Validação EDMD + RBF - Inversor LCL', 'Position', [100 100 800 600]);

subplot(3,1,1);
plot(t_val*1e3, X_val(1,:), 'k-', 'LineWidth', 1.5); hold on;
plot(t_val*1e3, X_koop(1,:), 'r--', 'LineWidth', 1.5);
grid on; legend('Real (ODE)', 'Koopman (EDMD+RBF)');
title('Corrente d no lado do inversor (i_{1d})'); ylabel('Corrente (A)');

subplot(3,1,2);
plot(t_val*1e3, X_val(3,:), 'k-', 'LineWidth', 1.5); hold on;
plot(t_val*1e3, X_koop(3,:), 'r--', 'LineWidth', 1.5);
grid on; legend('Real (ODE)', 'Koopman (EDMD+RBF)');
title('Tensão d no capacitor do filtro (v_{cd})'); ylabel('Tensão (V)');

subplot(3,1,3);
plot(t_val*1e3, X_val(5,:), 'k-', 'LineWidth', 1.5); hold on;
plot(t_val*1e3, X_koop(5,:), 'r--', 'LineWidth', 1.5);
grid on; legend('Real (ODE)', 'Koopman (EDMD+RBF)');
title('Corrente d no lado da rede (i_{2d})'); ylabel('Corrente (A)'); xlabel('Tempo (ms)');

%% =========================================================================
%% FUNÇÕES AUXILIARES
%% =========================================================================

% Dicionário de Observáveis: [Identidade Normalizada; RBFs]
function Psi = build_observables_rbf(X_norm, centers, gamma)
    [~, N] = size(X_norm);
    N_centers = size(centers, 2);
    
    Psi_rbf = zeros(N_centers, N);
    for i = 1:N_centers
        diff = X_norm - centers(:, i);
        Psi_rbf(i, :) = exp(-gamma * sum(diff.^2, 1));
    end
    
    Psi = [X_norm; Psi_rbf];
end

% Dinâmica Não Linear do Filtro LCL no Referencial dq
function dxdt = lcl_dq_dynamics(~, x, u, p)
    i1d = x(1); i1q = x(2);
    vcd = x(3); vcq = x(4);
    i2d = x(5); i2q = x(6);
    
    v_inv_d = u(1); v_inv_q = u(2);
    v_gr_d  = p.Vgrid(1); v_gr_q = p.Vgrid(2);
    
    di1d = (v_inv_d - p.R1*i1d + p.w*p.L1*i1q - vcd) / p.L1;
    di1q = (v_inv_q - p.R1*i1q - p.w*p.L1*i1d - vcq) / p.L1;
    
    dvcd = (i1d - i2d + p.w*p.C*vcq) / p.C;
    dvcq = (i1q - i2q - p.w*p.C*vcd) / p.C;
    
    di2d = (vcd - p.R2*i2d + p.w*p.L2*i2q - v_gr_d) / p.L2;
    di2q = (vcq - p.R2*i2q - p.w*p.L2*i2d - v_gr_q) / p.L2;
    
    dxdt = [di1d; di1q; dvcd; dvcq; di2d; di2q];
end