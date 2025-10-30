clear;
clc;
close all;

%% LOAD IN L-CURVE REGULARISATION DATA

load("../data/l_curve_data_5001.mat") % data from all simulations for different values of the regularisation paramters


%% DEFINE COLOURS 

blues = [0.07,0.62,1.00];
pinks = [1.00,0.07,0.65];
oranges = [213/255, 94/255,0];
yellows = [240/255, 228/255, 66/255];
cyans = [10/255, 255/255, 242/255];
greens = [0.39,0.83,0.07];


%% DEFINE VARIABLES FOR L-CURVE FIG
    
    % lambda refers to the paramter controlling regularisaition in cost function
    % lambda_values = all simulated values of lambda in cost function
    % OLS_out = data cost component in cost function
    % reg_cost = regularisation cost component in cost function
    % OLS_out_unitless = normalised data cost function component
    % reg_cost_unitless = normalised regularisation cost function component
    % d_OLS_out = gradient of data cost as a function of lambda_values
    % d_reg_out = gradient of regularisation cost as a function of lambda_values
    % d2_OLS_cost = second derivative of the data cost as a function of lambda_values
    % d2_reg_cost = second derivative of the regularisation cost as a function of lambda_values
    % total_curvature = summation of both second derivatives of each cost function component


%% FIGURE A4 - PLOT L-CURVE FIG

figure;

% subplot 1: L-curve data cost vs regularisation cost
subplot(2, 2, 1);
loglog(reg_cost, OLS_out, 'ko-', 'linewidth', 1.5);
xlabel('Regularisation cost J_{reg} (unitless)');
ylabel('Data cost J_{obs} (unitless)');
axis square;

% subplot 2: cost function components
subplot(2, 2, 2);
plot(lambda_values, OLS_out_unitless, 'color', blues, 'linewidth', 1.5); 
hold on;
plot(lambda_values, reg_cost_unitless, 'color', pinks, 'linewidth', 1.5); 
xlabel('Lambda Values');
ylabel('Cost Components (unitless)');
legend('J_{obs}', 'J_{reg}', 'Location', 'best');
axis square;

% subplot 3: cost function gradients
subplot(2, 2, 3);
plot(lambda_values, d_OLS_out, 'color', blues, 'linewidth', 1.5); 
hold on;
plot(lambda_values, d_reg_out, 'color', pinks, 'linewidth', 1.5); 
xlabel('Lambda Values');
ylabel('Cost gradient, $\frac{d(\ln(J))}{d(\ln(\lambda))}$', 'Interpreter', 'latex');
yline(0, 'k--');
legend('J_{obs}', 'J_{reg}', 'Location', 'best');
axis square;

% Subplot 4: cost function curvature
total_curvature = d2_OLS_cost + d2_reg_cost;
subplot(2, 2, 4);
plot(lambda_values, d2_OLS_cost,'color', blues, 'linewidth', 1.5); 
hold on;
plot(lambda_values(4:end), d2_reg_cost(4:end), 'color', pinks, 'linewidth', 1.5);
plot(lambda_values(4:end), total_curvature(4:end), 'k-', 'linewidth', 1.5); 
xlabel('Lambda Values');
ylabel('Cost curvature, $\frac{d^2(\ln(J))}{d(\ln(\lambda))^2}$', 'Interpreter', 'latex');
yline(0, 'k--');
legend('J_{obs}', 'J_{reg}', 'Total', 'Location', 'best');
axis square;


%%


