%% Motor CC bilinear (Korda & Mezic, 2018, Sec. 8.2)
% Comparacao de estruturas de modelo: DMDc x Koopman linear (RBF) x
% bilinear discreto x polinomial na entrada, e MPC com os dois ultimos.
% Parte 4 requer a Optimization Toolbox (quadprog).
clear; clc; close all;
rng(115123);

%% ===================== Parte 0: sistema =====================
% Modelo escalado (x1: corrente, x2: velocidade, u: entrada; ~[-1,1])
% Original: dx1 = -(Ra/La) x1 - (km/La) x2 u + ua/La
%           dx2 = -(B/J)  x2 + (km/J)  x1 u - tauL/J
f  = @(x,u) [ 19.10828025 - 39.3153*x(1,:) - 32.2293*x(2,:).*u ;
             -3.333333333 -  1.6599*x(2,:) + 22.9478*x(1,:).*u ];
Ts = 0.01;
fd = @(x,u) rk4(f, x, u, Ts);
n  = 2;
Cy = [0 1];                              % y = x2 (velocidade)

%% ===================== Parte 1: dados =====================
Ntraj = 200;  Nsim = 1000;
Ubig  = 2*rand(Nsim, Ntraj) - 1;         % entrada uniforme em [-1,1]
x     = 2*rand(n, Ntraj) - 1;            % condicoes iniciais em [-1,1]^2

% Estado completo: (x_k, u_k) -> x_{k+1}
X = zeros(n, Nsim*Ntraj);  Xp = X;  U = zeros(1, Nsim*Ntraj);
% Entrada-saida com atraso (como no artigo): zeta_k = [y_k; u_{k-1}; y_{k-1}]
Z = zeros(3, (Nsim-1)*Ntraj);  Zp = Z;  Uz = zeros(1, (Nsim-1)*Ntraj);

yprev = Cy*x;  uprev = zeros(1, Ntraj);
for i = 1:Nsim
    xn  = fd(x, Ubig(i,:));
    idx = (i-1)*Ntraj + (1:Ntraj);
    X(:,idx) = x;  Xp(:,idx) = xn;  U(idx) = Ubig(i,:);
    if i > 1
        jdx = (i-2)*Ntraj + (1:Ntraj);
        Z(:,jdx)  = [Cy*x;  uprev;      yprev];
        Zp(:,jdx) = [Cy*xn; Ubig(i,:);  Cy*x ];
        Uz(jdx)   = Ubig(i,:);
    end
    yprev = Cy*x;  uprev = Ubig(i,:);
    x = xn;
end

%% ===================== Parte 2: identificacao =====================
ls = @(Yd, Th) (Yd*Th') * pinv(Th*Th');  % minimos quadrados (eq. normais)
um = ones(1, size(X,2));

% M1: DMDc afim            x+ = A x + B u + c
G1 = ls(Xp, [X; U; um]);
M1 = @(x,u) G1*[x; u; 1];

% M2: Koopman linear (Korda): zeta + 100 RBFs thin-plate
Nrbf  = 100;
cent  = 2*rand(3, Nrbf) - 1;
liftK = @(z) [z; rbf_tp(z, cent)];
NK    = 3 + Nrbf;
G2 = ls(liftK(Zp), [liftK(Z); Uz]);
A2 = G2(:, 1:NK);  B2 = G2(:, NK+1);

% M3: bilinear discreto    x+ = A x + B u + N x u + c
G3 = ls(Xp, [X; U; X.*U; um]);
M3 = @(x,u) G3*[x; u; x*u; 1];

% M4: polinomial na entrada   x+ = sum_{p=0..P} u^p (M_p x + v_p)
P  = 4;
G4 = ls(Xp, featP(X, U, P));
M4 = @(x,u) G4*featP(x, u, P);

res = @(E) norm(E, 'fro')/norm(Xp, 'fro');
fprintf('Residuo relativo de 1 passo (estado completo):\n');
fprintf('  DMDc afim            %.2e\n', res(Xp - G1*[X; U; um]));
fprintf('  Bilinear discreto    %.2e\n', res(Xp - G3*[X; U; X.*U; um]));
fprintf('  Polinomial (P = %d)   %.2e\n', P, res(Xp - G4*featP(X, U, P)));

%% ===================== Parte 3: predicao (1 s, PRBS) =====================
Ntest = 100;  Nh = 100;
err = zeros(Ntest, 4);
for t = 1:Ntest
    x0 = rand(n,1) - 0.5;
    u0 = 2*rand - 1;                         % entrada passada (monta zeta)
    xa = fd(x0, u0);
    zK = liftK([Cy*xa; u0; Cy*x0]);
    u  = 2*(rand(1,Nh) > 0.5) - 1;           % PRBS
    xT = xa;  x1 = xa;  x3 = xa;  x4 = xa;
    yT = zeros(1, Nh);  yH = zeros(4, Nh);
    for k = 1:Nh
        xT = fd(xT, u(k));
        x1 = M1(x1, u(k));  x3 = M3(x3, u(k));  x4 = M4(x4, u(k));
        zK = A2*zK + B2*u(k);
        yT(k)   = Cy*xT;
        yH(:,k) = [Cy*x1; zK(1); Cy*x3; Cy*x4];
    end
    err(t,:) = 100*sqrt(sum((yH - yT).^2, 2))'/norm(yT);
end
nomes = {'DMDc afim', 'Koopman linear (RBF)', 'Bilinear discreto', 'Polinomial na entrada'};
fprintf('\nErro RMS relativo de predicao de y em 1 s (%d condicoes iniciais):\n', Ntest);
fprintf('  %-24s %12s %12s\n', 'Modelo', 'media [%]', 'mediana [%]');
for j = 1:4
    fprintf('  %-24s %12.3g %12.3g\n', nomes{j}, mean(err(:,j)), median(err(:,j)));
end

tt = (1:Nh)*Ts;
figure('Color', 'w');
plot(tt, yT, 'k', 'LineWidth', 2); hold on;
plot(tt, yH(1,:), '--', tt, yH(2,:), '-.', tt, yH(3,:), ':', tt, yH(4,:), '--', 'LineWidth', 1.3);
grid on; xlabel('t [s]'); ylabel('y = x_2');
legend([{'Real'}, nomes], 'Location', 'best');
title('Predicao em malha aberta com entrada PRBS');

%% ===================== Parte 4: MPC =====================
Np = 100;  Q = 1;  R = 0.01;
Nmpc = 300;  yr = 0.5*cos(2*pi*(1:Nmpc)/Nmpc);
ymin = -0.4;  ymax = 0.4;
opts = optimoptions('quadprog', 'Display', 'off');

xi  = [-0.1; 0.1];                       % um passo com u = 0 (monta o atraso)
xa0 = fd(xi, 0);
zeta0 = [Cy*xa0; 0; Cy*xi];

% --- K-MPC linear (Korda): matrizes densas fixas, QP convexo ---
CK = zeros(1, NK);  CK(1) = 1;
[SxK, SuK, ScK] = densa(repmat(A2, 1, 1, Np), repmat(B2, 1, 1, Np), zeros(NK, Np), CK);
xk = xa0;  zeta = zeta0;  yK = zeros(1, Nmpc);  uK = yK;  tK = 0;
for k = 1:Nmpc
    tic;
    Uo = mpc_qp(SxK*liftK(zeta) + ScK, SuK, yr(k), Q, R, ymin, ymax, opts);
    tK = tK + toc;
    u  = Uo(1);
    xk = fd(xk, u);
    zeta = [Cy*xk; u; zeta(1)];
    yK(k) = Cy*xk;  uK(k) = u;
end

% --- MPC com modelo polinomial: linearizacao ao longo da trajetoria prevista ---
xk = xa0;  Ub = zeros(Np, 1);  yP = zeros(1, Nmpc);  uP = yP;  tP = 0;
As = zeros(n, n, Np);  Bs = zeros(n, 1, Np);  cs = zeros(n, Np);
for k = 1:Nmpc
    tic;
    for it = 1:2
        xb = xk;
        for j = 1:Np
            [Fx, Fu, Fv] = jacP(G4, xb, Ub(j), P);
            As(:,:,j) = Fx;  Bs(:,:,j) = Fu;  cs(:,j) = Fv - Fx*xb - Fu*Ub(j);
            xb = Fv;
        end
        [Sx, Su, Sc] = densa(As, Bs, cs, Cy);
        Ub = mpc_qp(Sx*xk + Sc, Su, yr(k), Q, R, ymin, ymax, opts);
    end
    tP = tP + toc;
    u  = Ub(1);
    xk = fd(xk, u);
    yP(k) = Cy*xk;  uP(k) = u;
    Ub = [Ub(2:end); Ub(end)];               % warm start deslocado
end

yc = min(max(yr, ymin), ymax);               % referencia alcancavel
fprintf('\nMPC (referencia cossenoidal, |y| <= %.1f):\n', ymax);
fprintf('  %-26s RMSE = %.4f   violacao max = %.1e   tempo medio = %.1f ms\n', ...
    'K-MPC linear (RBF)', sqrt(mean((yK - yc).^2)), max(0, max(abs(yK)) - ymax), 1e3*tK/Nmpc);
fprintf('  %-26s RMSE = %.4f   violacao max = %.1e   tempo medio = %.1f ms\n', ...
    'MPC polinomial (LTV)', sqrt(mean((yP - yc).^2)), max(0, max(abs(yP)) - ymax), 1e3*tP/Nmpc);

tm = (1:Nmpc)*Ts;
figure('Color', 'w');
subplot(2,1,1);
plot(tm, yr, 'r--', tm, yK, 'b', tm, yP, 'g-.', 'LineWidth', 1.5); hold on;
plot(tm, ymax*ones(1,Nmpc), 'k', tm, ymin*ones(1,Nmpc), 'k');
grid on; ylabel('y'); legend('Referencia', 'K-MPC linear', 'MPC polinomial', 'Location', 'best');
subplot(2,1,2);
stairs(tm, uK, 'b', 'LineWidth', 1.2); hold on;
stairs(tm, uP, 'g-.', 'LineWidth', 1.2);
grid on; ylabel('u'); xlabel('t [s]');

%% ===================== Funcoes locais =====================
function xn = rk4(f, x, u, Ts)
k1 = f(x, u);
k2 = f(x + Ts/2*k1, u);
k3 = f(x + Ts/2*k2, u);
k4 = f(x + Ts*k3, u);
xn = x + Ts/6*(k1 + 2*k2 + 2*k3 + k4);
end

function Y = rbf_tp(X, C)
% RBF thin-plate: r^2 log(r)
Y = zeros(size(C,2), size(X,2));
for i = 1:size(C,2)
    r2 = sum((X - C(:,i)).^2, 1);
    y  = r2.*log(sqrt(r2));
    y(r2 == 0) = 0;
    Y(i,:) = y;
end
end

function F = featP(x, u, P)
% [x; 1; u x; u; u^2 x; u^2; ... ; u^P x; u^P]
F = zeros(3*(P+1), size(x,2));
for p = 0:P
    F(3*p + (1:3), :) = [x.*u.^p; u.^p];
end
end

function [Fx, Fu, Fv] = jacP(G, x, u, P)
% Modelo polinomial: valor Fv = F(x,u) e jacobianos Fx = dF/dx, Fu = dF/du
Fx = zeros(2);  Fu = zeros(2,1);  Fv = zeros(2,1);
for p = 0:P
    Mp = G(:, 3*p + (1:2));  vp = G(:, 3*p + 3);
    Fx = Fx + u^p*Mp;
    Fv = Fv + u^p*(Mp*x + vp);
    if p > 0
        Fu = Fu + p*u^(p-1)*(Mp*x + vp);
    end
end
end

function [Sx, Su, Sc] = densa(As, Bs, cs, C)
% Predicao densa de z_{k+1} = A_k z_k + B_k u_k + c_k:  Y = Sx z0 + Su U + Sc
[nz, ~, Np] = size(As);  ny = size(C,1);
Sx = zeros(ny*Np, nz);  Su = zeros(ny*Np, Np);  Sc = zeros(ny*Np, 1);
Phi = eye(nz);  Gam = zeros(nz, Np);  d = zeros(nz, 1);
for k = 1:Np
    Gam = As(:,:,k)*Gam;  Gam(:,k) = Bs(:,:,k);
    Phi = As(:,:,k)*Phi;
    d   = As(:,:,k)*d + cs(:,k);
    r   = (k-1)*ny + (1:ny);
    Sx(r,:) = C*Phi;  Su(r,:) = C*Gam;  Sc(r) = C*d;
end
end

function Uo = mpc_qp(free, Su, r, Q, R, ymin, ymax, opts)
% min Q||Y - r||^2 + R||U||^2,  |u| <= 1,  ymin <= Y <= ymax
Np = size(Su, 2);
H  = 2*(Q*(Su'*Su) + R*eye(Np));  H = (H + H')/2;
g  = 2*Q*Su'*(free - r);
Ain = [Su; -Su];  bin = [ymax - free; free - ymin];
lb = -ones(Np,1);  ub = ones(Np,1);
[Uo, ~, flag] = quadprog(H, g, Ain, bin, [], [], lb, ub, [], opts);
if flag <= 0                               % inviavel: relaxa a restricao de saida
    Uo = quadprog(H, g, [], [], [], [], lb, ub, [], opts);
end
end