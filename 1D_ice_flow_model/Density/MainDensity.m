clear;
close all;
clc;

%% Read in shallow ice core data

Data=xlsread('../../../Ferrigno data for Harry.xlsx','Density');
DepthDensity=Data(:,1);
Density=Data(:,2)*1e3;

% Make data look better
DepthDensity(isnan(Density))=[];
Density(isnan(Density))=[];

rhoi=mean(Density(DepthDensity>100)); % density of ice 
maxDepth=max(DepthDensity);
DepthDensityExtra=(maxDepth:1:200);
DensityExtra=rhoi*ones(size(DepthDensityExtra));

DepthDensity=[DepthDensity',DepthDensityExtra];
Density=[Density',DensityExtra];


%% Fit Model
 
Depth=linspace(0,max(DepthDensity),100);
param=[300,30];
OLS=@(param) sum((DensityModel(param(1),rhoi,param(2),DepthDensity)-Density).^2);
param=fminsearch(OLS,param);
rhos=param(1) % density of snow
rhoi=rhoi
Lrho=param(2) % characteristic length scale


%% Plot Figure 

figure; hold all;
plot(Density(DepthDensity<maxDepth),DepthDensity(DepthDensity<maxDepth),'.')
plot(DensityModel(rhos,rhoi,Lrho,Depth),Depth,'-b');
set(gca,'YDir','reverse');
xlabel('Density (kg m-3)');
ylabel('Depth (m)')




