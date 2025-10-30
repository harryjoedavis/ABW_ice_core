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


%% DEFINE VARIABLES FOR AGE-DEPTH FIG
   
    % div_age = forward model data for divide flow model;
    % flank_age = forward model data for flank flow model; 
    % Age_mean = inverse model output of the average age at ABW for different flank flow simulations (0 mm/yr melting);
    % Age_p1_basal_melt_20mmyr = inverse model output with 10 mm/yr basal melting;
    % Age_p1_basal_melt_10mmyr = inverse model output with 20 mm/yr basal melting;
    % H = ice thickness at ABW;
    % z = model grid size;
    % AgeData = age data from shallow ice core and IRH data;
    % DepthData = depths of age markers for shallow ice core and IRH data
    
% extract age-depth outputs for p=1 and p=5
Age_p1 = Ages(:,p_values(1)); % output for p=1
Age_p5 = Ages(:,p_values(end)); % output for p=5

% age-depth data for IRHs
known_ages = [2620, 4720]; % IRH ages from Bodart et al., 2021
irh_err = [0.31, 0.28]; % error in IRH ages from Bodart et al., 2021
irh_err_d = [12.85, 15.52]; % uncertainties based on IRH depth at ice core 


%% FIGURE 4 - PLOT MAIN AGE DEPTH FIG WITH INSETS

main_age_depth_plot(Age_p1, Age_p5, Age_mean, div_age, flank_age, ...
                Age_p1_basal_melt_20mmyr, Age_p1_basal_melt_10mmyr, ...
                AgeData, DepthData, known_ages, irh_err_d, irh_err, ...
                H, z, Hmin, pinks, blues, greens);


%%

