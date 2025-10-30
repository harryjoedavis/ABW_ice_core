clear;
clc;
close all;


%% LOAD IN INVERSE MODEL DATA

load('../data/MainAgeV4_1_output_5001.mat'); % 0 mm/yr basal melting
load('../data/MainAgeV4_1_output_20_mmyr_5001.mat'); % 10 mm/yr basal melting
load('../data/MainAgeV4_1_output_10_mmyr_5001.mat'); % 20 mm/yr basal melting


%% LOAD IN FORWARD MODEL DATA

load('../data/MainAgeV2_flank_div_output.mat') % divide and flank flow models


%% LOAD IN DOME C ACCUMULATION RATE AND AGE-DEPTH DATA 

load('../data/EDCData.mat'); % Dome C accumualtion data for comparison


%% DEFINE COLOURS 

blues = [0.07,0.62,1.00];
pinks = [1.00,0.07,0.65];
oranges = [213/255, 94/255,0];
yellows = [240/255, 228/255, 66/255];
cyans = [10/255, 255/255, 242/255];
greens = [0.39,0.83,0.07];

%% DEFINE VARIABLES FOR ICE CORE ANNUAL LAYER THICKNESS FIG

    % dAgedz = gradient of age with depth
    
dAgedz_p1 = dAgedz(:,1);
dAgedz_p5 = dAgedz(:,5);
mean_dAgedz = mean(dAgedz,2); % average for all inverse model simulations 
layer_thickness = (1./mean_dAgedz)'; % annual layer thickness 
idx_solid = Age_mean < 4750; % solid lines = period constrained by IRH data
idx_dashed = Age_mean > 4750; % dashed lines = constrained by WAIS Divide accumulation data from Sigl et al., 20116 and Koutnik et al., 2016

% age-depth data for IRHs
known_ages = [2620, 4720]; % IRH ages from Bodart et al., 2021
irh_err = [0.31, 0.28]; % error in IRH ages from Bodart et al., 2021
irh_err_d = [12.85, 15.52]; % uncertainties based on IRH depth at ice core 

%% FIGURE 5 - PLOT ICE CORE ANNUAL LAYER THICKNESS FIG

figure;
% age depth fig on log scale
subplot(1, 2, 1);
hold all;
plot(Age_mean(idx_solid), H - z(idx_solid), 'color', blues, 'linewidth', 2, 'LineStyle', '-'); % solid = constrained by IRHs
plot(Age_mean(idx_dashed), H - z(idx_dashed), 'color', blues, 'linewidth', 2, 'LineStyle', '--'); % dashed = 

%  ice core age markers + irhs (and errors) + ice bed + oldest ice (95% of ice thickness)
plot(AgeData,DepthData,'color',blues,'marker','+', 'MarkerSize',6,'MarkerFaceColor','b', 'LineWidth', 2,'LineStyle','none'); % ice core data
plot(known_ages, DepthData(end-1:end), 'color', blues,'marker','+', 'MarkerSize', 8, 'MarkerFaceColor',blues, 'LineWidth', 2, 'LineStyle','none'); 
errorbar(AgeData(end-1:end), DepthData(end-1:end),irh_err_d,irh_err_d, irh_err,irh_err, 'LineStyle','none', 'color',blues);
plot_bed_and_oldest_ice(H, [1e-6,1e6]);

% axes settings and labels 
set(gca,'Ydir','reverse', 'FontSize',14, 'XScale', 'log');
xlabel('Age (years BP)');
ylabel('Depth (m)');
ylim([-50 1400]);
xlim([1 1000000]);
box on;
grid on; 


% annual layer thickness plot on log scale
subplot(1,2,2)
hold all;

plot(layer_thickness(idx_solid), H - z(idx_solid), 'color', blues, 'linewidth', 2, 'LineStyle', '-');
plot(layer_thickness(idx_dashed), H - z(idx_dashed), 'color', blues, 'linewidth', 2, 'LineStyle', '--');

% plot(mean_dAgedz(idx_solid), H - z(idx_solid), 'color', blues, 'linewidth', 2, 'LineStyle', '-');  
% plot(mean_dAgedz(idx_dashed), H - z(idx_dashed), 'color', blues, 'linewidth', 2, 'LineStyle', '--');

% ice bed + oldest ice (95% of ice thickness)
plot_bed_and_oldest_ice(H, [1e-6,1e6]);

% axes settings and labels
set(gca,'Ydir','reverse', 'FontSize',14, 'XScale', 'log', 'YTickLabel', []);
xlabel('Thickness of Annual Layer (m)');
ylim([-50 1400]);
xlim([1e-4, 1.2]);
box on;
grid on;


%%


