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


%% DEFINE VARIABLES FOR ACCUMULATION RATE FIG

    % AgeW = WAIS Divide age scale from Koutnik et al 2016;
    % accW = WAIS Divide ice core advection-corrected accumulation rates from Koutnik et al 2016;
    % AgeC = Dome C age scale;
    % accC = Dome C ice core accumulation rates;

% calculate mean accumulation and standard deviation (std) for each inverse model simualtion
mean_accs = mean(accs, 2);
std_accs = std(accs, 0, 2);
% calcaulte confidence intervals (ci) for plot
nt = size(mean_accs, 1); % number of observations
se = std_accs / sqrt(nt); % standard error 
t_value = tinv(0.95, nt - 1);  
ci_upper = mean_accs + t_value * se; % upper ci
ci_lower = mean_accs - t_value * se; % lower ci


%% FIGURE 3 - PLOT MAIN ACCUMULATION RATE FIG

main_acc_data_plot(t, mean_accs, std_accs, accs, AgeW, accW, AgeC, accC, blues, pinks, oranges, greens);


%%


