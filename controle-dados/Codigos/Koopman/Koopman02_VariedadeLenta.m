%% Etapa 1: sistema com variedade lenta - simulacao e linearizacao
clear; clc; close all;

mu = -0.05;  lambda = -1;
f  = @(t,x) [mu*x(1); lambda*(x(2) - x(1)^2)];
J0 = [mu 0; 0 lambda];                 % jacobiano na origem

t    = 0:0.05:80;
opts = odeset('RelTol', 1e-10, 'AbsTol', 1e-12);

% Condicoes iniciais em um circulo de raio 2 centrado em (0, 1)
th = linspace(0, 2*pi, 13);  th(end) = [];
X0 = [2*cos(th); 1 + 2*sin(th)];

%% Figura 1: plano de fase
figure('Color', 'w'); hold on;

% Campo vetorial (normalizado, so direcao)
[X1g, X2g] = meshgrid(linspace(-2.2, 2.2, 17), linspace(-1.2, 3.5, 17));
U = mu*X1g;  V = lambda*(X2g - X1g.^2);
N = sqrt(U.^2 + V.^2);
quiver(X1g, X2g, U./N, V./N, 0.5, 'Color', [0.75 0.75 0.75]);

for i = 1:size(X0, 2)
    [~, x] = ode45(f, t, X0(:,i), opts);
    xl = zeros(2, numel(t));
    for k = 1:numel(t)
        xl(:,k) = expm(J0*t(k))*X0(:,i);
    end
    h1 = plot(x(:,1), x(:,2), 'b', 'LineWidth', 1.5);
    h2 = plot(xl(1,:), xl(2,:), 'r--', 'LineWidth', 1.2);
    plot(X0(1,i), X0(2,i), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4);
end

x1c = linspace(-2.2, 2.2, 200);
h3 = plot(x1c, x1c.^2, 'k:', 'LineWidth', 2);
axis([-2.2 2.2 -1.2 3.5]);  grid on;
xlabel('x_1');  ylabel('x_2');
legend([h1 h2 h3], {'Nao linear', 'Linearizado na origem', 'x_2 = x_1^2 (referencia)'}, ...
       'Location', 'north');
title('Plano de fase');

%% Figura 2: resposta no tempo para uma condicao inicial
x0 = [1.5; -1];
[~, x] = ode45(f, t, x0, opts);
xl = zeros(2, numel(t));
for k = 1:numel(t)
    xl(:,k) = expm(J0*t(k))*x0;
end

figure('Color', 'w');
subplot(2,1,1);
plot(t, x(:,1), 'b', t, xl(1,:), 'r--', 'LineWidth', 1.5);
grid on;  ylabel('x_1');
legend('Nao linear', 'Linearizado', 'Location', 'northeast');
title('Resposta no tempo, x_0 = [1,5;  -1]');
subplot(2,1,2);
plot(t, x(:,2), 'b', t, xl(2,:), 'r--', 'LineWidth', 1.5);
grid on;  ylabel('x_2');  xlabel('t');