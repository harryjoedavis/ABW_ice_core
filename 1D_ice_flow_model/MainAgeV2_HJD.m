clear;
clc;
close all;

%% Parameters

% glaciological
H=1209.95+9.5; % ice thickness (m) 
acc_guess=0.3348/0.910; % surface accumultion (m/yr) from shallow ice core

% irh depths 
d_4 = 874.1+9.5; % depth of 4.72 ka IRH + firn correction
d_2 = 481.8+9.5; % depth of 2.62 ka IRH

% numerical
nz=5001; % number of numerical nodes. Inversely proportional to resolution (resolution=IceThickness/(nz-1))

% Flow model parameters 
p=3; %LLiboutry

% Density from shallow ice core using 'Density/MainDensity.m'
rhoi=852.3201; % density of ice
rhos=444.9961; % near surface density
Lrho=111.8045; % charactersitic length - scale at which density changes significantly 

%% Geometry
z=linspace(0,H,nz);

%% Flow model

% Parabollic density
rho=rhoi+(rhos-rhoi)*(1-(H-z)/Lrho).^2;
rho((H-z)>Lrho)=rhoi;

% Lliboutry shape function
eta=1-(p+2)/(p+1).*(1-z/H)+(1-z/H).^(p+2)/(p+1);
eta=eta*rhoi./rho;  

% Anisotropic model (Martin and Gudmundsson, 2012)
load('eta2B');
eta2B=interp1(zd/zd(end)*z(end),etad,z,'pchip');
eta2B=eta2B*rhoi./rho;
clear zd etad;


%% Read shallow ice core data and IRH data
Data=readmatrix('Ferrigno data for Harry.xlsx','Sheet','Age-depth');
DepthData=Data(:,1); 
Time=Data(:,2); % (m_weq/yr)
Time0=2011;
AgeData=Time0-Time;

DepthData = [DepthData; d_2; d_4];
AgeData = [AgeData; 2620; 4720];

%% Calculate steady-state age

OKdata=find((Time0-AgeData<=1900)&(Time0-AgeData>1700));

AgeDepthIter=@(z,param,eta,DepthData)interp1(z,AgeDepthSS(z,-param*eta),H-DepthData);
opts = optimset('Display','iter');

OLS = @(param) sum((AgeDepthIter(z,param,eta,DepthData(OKdata))-AgeData(OKdata)).^2);
acc=fminsearch(OLS,acc_guess,opts);
Age=AgeDepthSS(z,-acc*eta);

OLS2B = @(param) sum((AgeDepthIter(z,param,eta2B,DepthData(OKdata))-AgeData(OKdata)).^2);
acc2B=fminsearch(OLS2B,acc_guess,opts);
Age2B=AgeDepthSS(z,-acc2B*eta2B);

%% Calculate gradients for ice core resolution

% dAgedz=-derivative(Age)./derivative(z);
% dAge2Bdz=-derivative(Age2B)./derivative(z);


%% Plot model outputs

Hmin=20;
known_depths = [874.1+9.5, 481.9+9.5];
known_ages = [4720, 2310];

figure;hold all;
fill([Age(z>Hmin)/1e3,flip(Age2B(z>Hmin))/1e3],[H-z(z>Hmin),flip(H-z(z>Hmin))],[0.8,0.8,0.8],'LineStyle','none');
flank=plot(Age(z>Hmin)/1e3,H-z(z>Hmin),'b');
h2B=plot(Age2B(z>Hmin)/1e3,H-z(z>Hmin),'r');
hdata=plot(AgeData/1e3,DepthData,'.k');
plot([0,120],[H,H],'--k');
irhs = plot(known_ages/1e3, known_depths, '*k', 'MarkerSize', 10, 'LineWidth', 2); 
set(gca,'Ydir','reverse');
xlabel('Age (kyr)');
ylabel('Depth(m)');
legend([flank; h2B; hdata; irhs], 'Flank  (Lliboutry p=3)', 'Dome (Martin 2012)', 'Ice core data', 'IRHs')
xlim([0,40]);
ylim([0,1350]);

flank_age = Age;
div_age = Age2B;
 
%% save data

%save('Output_2620ka/MainAgeV2_flank_div_output_5001.mat', 'flank_age','div_age');
