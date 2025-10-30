clear;
clc;
close all;


%% Parameters

%glaciological.
H=1209.95+9.5; % ice thickness (m) 
acc_guess = [0.4022,0.3348,0.3640,0.4022]/0.910; % initial guesses for accumulation breakpoints
t_acc_guess=[0,-200,-2620,-4720]; % (yr) time for the acc_guess

melt=0.00; %(m/yr) basal melting varies between 0 and 0.02 m/yr

% numerical
nz=5001; %Number of numerical nodes. Inversely proportional to resolution (resolution=IceThickness/(nz-1))
nt=5001; %Number of time nodes.
t0=-31e3; %oldest time considered (yr BP) = end of WAIS Divide record

% Flow model parameters 
p_values = 1:5;

% Density from shallow ice core using 'Density/MainDensity.m'
rhoi=852.3201; % density of ice
rhos=444.9961; % near surface density
Lrho=111.8045; % charactersitic length - scale at which density changes significantly 

LambdaReg = 12500; % optimal lamda determined from l-curve analyses (see l_curve.m)


%% Geometry

z=linspace(0,H,nz);
t=linspace(t0,0,nt);


%% Calculate density 

% Parabollic density
rho=rhoi+(rhos-rhoi)*(1-(H-z)/Lrho).^2;
rho((H-z)>Lrho)=rhoi;

%% Read in long-term accumulation date from WAIS Divide ice core

% load data from WAIS (koutnik et al 2016) 
wais_data = load('WAIS_data/Koutnik_etal_2016_Figure_5_accumluation_estimates.txt');
AgeW = wais_data(:,1)';
accW = wais_data(:,3)'; %advection corrected acc
accW_smooth=movmean(accW,100,'SamplePoints',AgeW);


%% Read shallow ice core data

Data = readmatrix('Ferrigno data for Harry.xlsx', 'Sheet', 'Age-depth');
DepthData=Data(:,1); 
Time=Data(:,2); %(m_weq/yr)
Time0=2011;
AgeData=Time0-Time;

DepthData = [DepthData; 481.8+9.5; 874.1+9.5];
AgeData = [AgeData; 2620; 4720];
irh_err = [0.31, 0.28]; % age in errors for 2.62 and 4.72 ka IRH
irh_err_d = [12.85, 15.52]; % depth uncertainties for 2.62 and 4.72 ka IRHs

%% Calculate transient age 

figure;
hold on; 

% pre define matrices 
Ages = zeros(length(z), length(p_values));
dAgedz = zeros(length(z), length(p_values));
colors = jet(length(p_values));
accs = zeros(length(t), length(p_values));

% loop flow model over multiple p values
for idx = 1:length(p_values)
    p = p_values(idx);

    % vertical velo calculation
    eta=1-(p+2)/(p+1).*(1-z/H)+(1-z/H).^(p+2)/(p+1);
    eta=eta*rhoi./rho;

    % optimise to deepest irh
    OKdata=find(Time0-AgeData<=1900);
    AgeDepthIter=@(param,eta,DepthData)interp1(z,AgeDepthModel(z,t,param,t_acc_guess,AgeW,accW,melt,eta),H-DepthData);
    opts = optimset('Display','iter');

    OLS = @(param) sum((AgeDepthIter(param,eta,DepthData(OKdata))-AgeData(OKdata)).^2)/length(OKdata)+...
               LambdaReg*std(param);
    acc_opt=fminsearch(OLS,acc_guess,opts);

    Age=AgeDepthModel(z,t,acc_opt,t_acc_guess,AgeW,accW,melt,eta);
    Ages(:,idx)=Age; % store age result for this iteration

    % and calculate gradients
    dAgedz(:,idx)=-derivative(Age)./derivative(z);

    p_vals{idx} = plot(Age/1e3,H-z,'Color',colors(idx,:),'DisplayName',['p=', num2str(p)]);
    
    % store acccum
    accs(:,idx) = AccumulationVariation(t, acc_opt, t_acc_guess, AgeW, accW);
end

%% calcualte mean and standard deviation caross all simulations 

Age_mean = mean(Ages, 2); % mean across the runs
Age_std = std(Ages, 0, 2); % standard deviation 


%% extract some data for plotting 

Age_p1 = Ages(:,p_values(1)); % age-depth profile for p=1
Age_p5 = Ages(:,p_values(end)); % age-depth profile for p=5

% ice core resolution used for layer thickness calculation
dAgedz_p1 = dAgedz(:,1);
dAgedz_p5 = dAgedz(:,5);
mean_dAgedz = mean(dAgedz,2);


%% save outputs

%  save('Output/MainAgeV4_1_output_5001.mat', 'Ages', 'Age_mean', 'Age_std', 'p_values',...
%   'known_ages', 'known_depths', 'AgeData', 'DepthData', 'Hmin', 'h', 'hdata', ...
%   'irhs', 'legend_entries', 'colors', 'Age_p1', 'Age_p5', 'irh_err', 'bed',...
%   'oldest', 'dAgedz', 'mean_dAgedz', 'H', 'z', 't', 'accs', 'AgeW', 'accW', 'AgeC', 'accC');

% ('AgeW', 'accW', 'AgeC', 'accC') = age and accs from WAIS Divide (W) and  Dome C (C)


