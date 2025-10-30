clear;
clc;
close all;


%% Parameters
acc_guess = [0.4022, 0.3348, 0.3640, 0.4022] / 0.910;  % initial guesses for accumulation breakpoints
t_acc_guess = [0, -200, -2620, -4720];  % (yr) time for the acc_guess

melt = 0.00; % basal melt rate m/yr

% numerical
nz=5001; %Number of numerical nodes. Inversely proportional to resolution (resolution=IceThickness/(nz-1))
nt=5001; %Number of time nodes.
t0=-31e3; %oldest time considered (yr BP) = end of WAIS Divide record

% lliboutry flow model params 
p = 3;

% Density from shallow ice core using 'Density/MainDensity.m'
rhoi=852.3201; % density of ice
rhos=444.9961; % near surface density
Lrho=111.8045; % charactersitic length - scale at which density changes significantly 

LambdaReg = 12500; % optimal lamda determined from l-curve analyses (see l_curve.m)



%% Read in long-term accumulation date from WAIS Divide ice core

% load data from WAIS (koutnik et al 2016) 
wais_data = load('WAIS_data/Koutnik_etal_2016_Figure_5_accumluation_estimates.txt');
AgeW = wais_data(:,1)';
accW = wais_data(:,3)'; %advection corrected acc
accW_smooth=movmean(accW,100,'SamplePoints',AgeW);


%%

% Shapefile paths
shapefilePaths = {
    'Shapefiles\4_72ka';
    'Shapefiles\2_31ka';
    'Shapefiles\ice_thickness';
    'Shapefiles\divide_bounds';
    'Shapefiles\fis_fig2_res_lines'
};

% Read the divide bounds shapefile
divide_bounds = m_shaperead('Shapefiles\divide_bounds');
divide_x = divide_bounds.ncst{1}(:, 1);
divide_y = divide_bounds.ncst{1}(:, 2);

% Initialize cell arrays to store coordinates and depth data
x_coords = cell(length(shapefilePaths) - 1, 1);
y_coords = cell(length(shapefilePaths) - 1, 1);
depths = cell(length(shapefilePaths) - 1, 1);

% Loop over each shapefile except the divide bounds
for i = 1:length(shapefilePaths) - 2
    % Read the shapefile
    path_to_shapefile = shapefilePaths{i};
    S = m_shaperead(path_to_shapefile);
    
    % Initialize temporary lists
    x_temp = [];
    y_temp = [];
    depths_temp = [];
    
    % Loop over each shape in the shapefile
    for j = 1:length(S.ncst)
        x = S.ncst{j}(:, 1);
        y = S.ncst{j}(:, 2);
        d = S.ncst{j}(:, 3);
        
        % Find points within the divide bounds
        in = inpolygon(x, y, divide_x, divide_y);
        
        % Store only points within the bounds
        x_temp = [x_temp; x(in)];
        y_temp = [y_temp; y(in)];
        depths_temp = [depths_temp; d(in)];
    end
    
    x_coords{i} = x_temp;
    y_coords{i} = y_temp;
    depths{i} = depths_temp;
end

% Initialize lists for matched data
matched_coords = [];
matched_depths = [];

% Find matching coordinates where there is depth data for all IRHs and the bed
for i = 1:length(x_coords{1})
    x1 = x_coords{1}(i);
    y1 = y_coords{1}(i);
    
    idx2 = find(x_coords{2} == x1 & y_coords{2} == y1, 1);
    idx3 = find(x_coords{3} == x1 & y_coords{3} == y1, 1);
    
    if ~isempty(idx2) && ~isempty(idx3)
        matched_coords = [matched_coords; x1, y1];
        matched_depths = [matched_depths; depths{1}(i), depths{2}(idx2), depths{3}(idx3)];
    end
end


% roughly every 350 m
step = 50;
indices = 1:step:length(matched_coords);

% Extract the sampled data
sampled_coordinates = matched_coords(indices, :);
sampled_depth_values = -1*matched_depths(indices, :);


%% Read shallow ice core data

Data = readmatrix('Ferrigno data for Harry.xlsx', 'Sheet', 'Age-depth');
DepthData=Data(:,1); 
Time=Data(:,2); %(m_weq/yr)
Time0=2011;
AgeData=Time0-Time;

DepthData = [DepthData; 481.8+9.5; 874.1+9.5];
AgeData = [AgeData; 2620; 4720];

% ice thickness data
HArray = sampled_depth_values(:,3);  % A

% age at 95% ice thickness
age_at_95H = zeros(size(HArray));

figure;
hold on;

for spatialIdx = 1:length(HArray)
        currentDepthData = [DepthData; sampled_depth_values(spatialIdx,2); sampled_depth_values(spatialIdx,1)];
        H = HArray(spatialIdx);
        
        z = linspace(0, H, nz);
        t = linspace(t0, 0, nt);
        
        rho = rhoi + (rhos - rhoi) * (1 - (H - z) / Lrho).^2;
        rho((H - z) > Lrho) = rhoi;
        eta = 1 - (p+2)/(p+1) * (1 - z / H) + (1 - z / H).^(p+2) / (p+1);
        eta = eta * rhoi ./ rho;
        
       OKdata=find(Time0-AgeData<=1900);
       AgeDepthIter=@(param,eta,currentDepthData)interp1(z,AgeDepthModel(z,t,param,t_acc_guess,AgeW,accW,melt,eta),H-currentDepthData);
       opts = optimset('Display','iter');


       OLS = @(param) sum((AgeDepthIter(param,eta,currentDepthData(OKdata))-AgeData(OKdata)).^2)/length(OKdata)+...
                LambdaReg*std(param);
       acc_opt=fminsearch(OLS,acc_guess,opts);
       Age=AgeDepthModel(z,t,acc_opt,t_acc_guess,AgeW,accW,melt,eta);
        
        depth95 = 0.05 * H;
        age_at_95H(spatialIdx) = interp1(z, Age, depth95);
    
end


%% save data for plotting

%save('Output\1D_mapview_data.mat', 'sampled_coordinates','sampled_depth_values','age_at_95H');

