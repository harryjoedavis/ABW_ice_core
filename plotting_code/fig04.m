clear;
clc;
close all;


%% LOAD IN INVERSE MODEL DATA

load('../data/MainAgeV4_1_output_5001.mat'); % 0 mm/yr basal melting
load('../data/MainAgev5_output_5001.mat'); % thinning scenario

%% DEFINE VARIABLES FOR AGE-DEPTH FIG
   
    % ths = optimised history of thinning rates 
    % Ht = integrated ice thickness  

%% FIGURE 4 - PLOT THINNING RATES AND ICE THICKNESS HISTORY

figure;

yyaxis left;
plot(-t/1e3, ths, 'Color', [0.30, 0.75, 0.93], 'LineWidth', 2); % rates of thinning
xlim([0 6]);
ylabel('dH/dt (m/yr)');
xlabel('Age (ka)');
ax = gca;
ax.YColor = [0.30, 0.75, 0.93];

yyaxis right;
plot(-t/1e3, Ht, 'Color', [1.00, 0.07, 0.65], 'LineWidth', 2); % ice thickness history 
ylabel('Ice thickness (m)');
ax.YColor = [1.00, 0.07, 0.65];
axis square;
grid on;
