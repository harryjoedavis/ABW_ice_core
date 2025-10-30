function [Tb,m]=CalculateMelting(z,T,Tm,QG)
% 
%  m = (QG-k dTdz|b)/(rhow*L)
%
 rhow=1000; %kg m-3
 L=333.5e3; % Latent Heat (J/kg)
 secondsperyear=365.5*24*3600; %(s/yr)
 dTdz=derivative(T)./derivative(z);

 [~,ib]=find(z>=0,1);
 Tb=T(ib);
 if Tb<Tm
     m=0;
 else
     kc=9.828.*exp(-0.0057*(273.15+Tb));
     dTdz=dTdz(ib);
     m=(QG-kc*dTdz)/rhow/L*secondsperyear; %m/yr  
 end
 
end