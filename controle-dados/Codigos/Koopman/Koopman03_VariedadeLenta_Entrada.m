%% Etapa 1b: sistema com variedade lenta, com entrada
clear; clc; close all;
rng(1);

mu = -0.05;  lambda = -1;
f  = @(x,u) [mu*x(1) + u; lambda*(x(2) - x(1)^2)];
A0 = [mu 0; 0 lambda];  B0 = [1; 0];       % linearizacao na origem

%% Entrada multinivel: degraus aleatorios de 10 s
Tf = 300;  Th = 10;  dt = 0.05;
nseg   = Tf/Th;
niveis = 0.1*(2*rand(nseg,1) - 1);

opts = odeset('RelTol', 1e-10, 'AbsTol', 1e-12);
xk = [0; 0];  xlk = [0; 0];                % parte do repouso
T = [];  X = [];  XL = [];  Uv = [];

for s = 1:nseg
    us = niveis(s);
    ts = ((s-1)*Th : dt : s*Th).';
    [~, xs]  = ode45(@(tt,xx) f(xx, us),         ts, xk,  opts);
    [~, xls] = ode45(@(tt,xx) A0*xx + B0*us,     ts, xlk, opts);
    xk  = xs(end,:).';   xlk = xls(end,:).';
    idx = 1:numel(ts)-1;                       % evita repetir o ponto de juncao
    T  = [T;  ts(idx)];
    X  = [X;  xs(idx,:)];
    XL = [XL; xls(idx,:)];
    Uv = [Uv; us*ones(numel(idx),1)];
end

%% Figura 1: resposta no tempo
figure('Color', 'w');
subplot(3,1,1);
stairs(T, Uv, 'k', 'LineWidth', 1.2);
grid on;  ylabel('u');
title('Resposta a uma entrada multinivel (x_0 = 0)');

subplot(3,1,2);
plot(T, X(:,1), 'b', T, XL(:,1), 'r--', 'LineWidth', 1.5);
grid on;  ylabel('x_1');
legend('Nao linear', 'Linearizado', 'Location', 'best');

subplot(3,1,3);
plot(T, X(:,2), 'b', T, XL(:,2), 'r--', T, X(:,1).^2, 'k:', 'LineWidth', 1.5);
grid on;  ylabel('x_2');  xlabel('t');
legend('Nao linear', 'Linearizado', 'x_1^2 (referencia)', 'Location', 'best');

%% Figura 2: plano de fase
figure('Color', 'w'); hold on;
x1c = linspace(min(X(:,1)) - 0.2, max(X(:,1)) + 0.2, 200);
plot(x1c, x1c.^2, 'k:', 'LineWidth', 2);
plot(X(:,1), X(:,2), 'b', 'LineWidth', 1.2);
plot(XL(:,1), XL(:,2), 'r--', 'LineWidth', 1.2);
grid on;  xlabel('x_1');  ylabel('x_2');
legend('x_2 = x_1^2 (referencia)', 'Nao linear', 'Linearizado', 'Location', 'north');
title('Plano de fase com entrada');