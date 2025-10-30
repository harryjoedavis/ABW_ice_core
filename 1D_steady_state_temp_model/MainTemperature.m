clear;
clc;
close all;


%% Parameters

% numerical
nz=5001;

%glaciological
H=1209.95+9.5; % ice thickness (m)
acc=0.33/0.910; % surface accumultion (m/yr) 
Ts=-20; %surface temperature (C) 
QG=linspace(50e-3,140e-3,91); % geothermal flux (Wm-2)
melt=0.00; % meltrate (m/yr)

% Density from shallow ice core using 'Density/MainDensity.m'
rhoi=852.3201; % density of ice
rhos=444.9961; % near surface density
Lrho=111.8045; % charactersitic length - scale at which density changes significantly 



%% Geometry
z=linspace(-H,H,nz);


%% Flow model

% Parabollic density
rho=rhoi+(rhos-rhoi)*(1-(H-z)/Lrho).^2;
rho((H-z)>Lrho)=rhoi;

% Lliboutry shape function
p=1;
eta=1-(p+2)/(p+1).*(1-z/H)+(1-z/H).^(p+2)/(p+1);
eta=eta*rhoi./rho; 
eta(z<=0)=0;

p=5;
eta2B=1-(p+2)/(p+1).*(1-z/H)+(1-z/H).^(p+2)/(p+1);
eta2B=eta2B*rhoi./rho; 
eta2B(z<=0)=0;

  
%% SS Temperature

m=zeros(size(QG));
Tb=zeros(size(QG));
for i=1:length(QG)
    T=CalculateTSS(z,acc,0.0,eta,rho,rhoi,0.0,Ts,QG(i));
    T2B=CalculateTSS(z,acc,0.0,eta2B,rho,rhoi,0.0,Ts,QG(i));
    [Tb(i),m(i)]=CalculateMelting(z,T,0.0,QG(i));
    [T2Bb(i),m2B(i)]=CalculateMelting(z,T2B,0.0,QG(i));
end


%% Save output

%save('Output/basal_melt_data_5001.mat', 'QG', 'Tb', 'T2Bb', 'm', 'm2B');

