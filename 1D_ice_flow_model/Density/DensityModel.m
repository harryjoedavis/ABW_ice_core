function Density=DensityModel(rhos,rhoi,df,d)

% exponential
 Density=rhoi+(rhos-rhoi)*exp(-d/df);

% Parabollic
Density=rhoi+(rhos-rhoi)*(1-d/df).^2;
Density(d>df)=rhoi;
% 
end
