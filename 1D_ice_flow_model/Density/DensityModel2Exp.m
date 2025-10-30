function Density=DensityModel(rhos,rhoi,L1,L2,d)
Density=zeros(size(d));

rhoc=550;
dc=L1*log((rhoi-rhos)/(rhoi-rhoc));
Density(d<=dc)=rhoi-(rhoi-rhos)*exp(-d(d<=dc)/L1);
Density(d>dc)=rhoi-(rhoi-rhoc)*exp(-(d(d>dc)-dc)/L2);
end