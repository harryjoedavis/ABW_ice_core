clear;
clc;
close all;

%% LOAD IN STEADY-STATE TEMPERATURE MODEL OUTPUT

load('../data/SS_temperature_model_output_5001.mat');


%% DEFINE COLOURS 

blues = [0.07,0.62,1.00];
pinks = [1.00,0.07,0.65];
oranges = [213/255, 94/255,0];
yellows = [240/255, 228/255, 66/255];
cyans = [10/255, 255/255, 242/255];
greens = [0.39,0.83,0.07];


%% DEFINE VARIABLES FOR ICE CORE ANNUAL LAYER THICKNESS FIG
   
    % QG = range of geothermal heat flux values
    % Tb = basal temperature output for p = 1
    % T2Bb = basal temperature for p = 5
    % m = basal melt rates for p = 1 (derived using Eq. 4 in main text)
    % m2B = bsal melt rates for p = 5 (derived using Eq. 4 in main text)


%% FIGURE A5 - PLOT TEMPERATURE MODEL DATA 

figure; 
hold all;
yyaxis  left;
h1=plot(QG*1e3,Tb, 'color', blues);
h2=plot(QG*1e3,T2Bb, 'color', blues);
fill([QG,flip(QG)]*1e3,[Tb,flip(T2Bb)], blues, 'LineStyle','none','FaceAlpha',0.5);
ylabel('Basal temperature (C)', 'Color', blues);
ax = gca;
ax.YColor = blues; % Set left axis color

yyaxis right; 
hold all;
h3=plot(QG*1e3,m*1e3, 'color', pinks);
h4=plot(QG*1e3,m2B*1e3, 'color', pinks);
fill([QG,flip(QG)]*1e3,[m,flip(m2B)]*1e3, pinks, 'LineStyle','none','FaceAlpha',0.5);
xlabel('Geothermal Heatflux (mW m-2)');
ylabel('meltrates (mm/yr)', 'Color', pinks); 
ax.YColor = pinks; 

legend([h1,h2,h3,h4],'Basal Temperature p=1','Basal Temperature p=5','meltrate p=1','meltrate p=5');



%%

