function Tss=TDepthSS(z,acc,melt,eta,rho,rhoi,Tm,Ts,QG)
% function Tss=TDepthSS(z,w,Ts,kc,kd,QG)
% 
% Solves: 
%    wdTdz - kd d2T/dz2 = 0
%    T(z(end))=Ts
%    dT(z(1))/dz = -QG/kc
%
% Uses trapezoidal integration:
% T(z) = Ts - int{u dz}_z^H
% where u(z)=-QG/kc*exp(int{{w/kd dz});

  
w=-(acc-melt)*eta-melt;


nIter=100;
Tss0=Ts+zeros(size(z));
 for iter=1:nIter
    kc=2*(9.828.*exp(-0.0057*(273.15+Tss0))).*rho/rhoi./(3-rho/rhoi);
    Cp=(152.5+7.122*(273.15+Tss0))/31557600;
    
    kc(z<0)=(9.828.*exp(-0.0057*(273.15)));
    Cp(z<0)=(152.5+7.122*(273.15))/31557600;
    
    kd=kc./(rho.*Cp); %Diffusivity (m2 yr-1)
     
    
    % I1= int{w/kd dz}_0^z
    I1=cumtrapz(z,w./kd);
    u=-QG./kc.*exp(I1);
    
    %I2=int{u dz}_z^H
    I2=cumtrapz(flip(z),flip(u));
    
    %T=Ts-int{u dz}_z^H
    Tss=Ts+flip(I2);
    

    %disp([num2str(iter),'/',num2str(nIter),' err=',num2str(sum(abs(Tss0-Tss)))]);
    if(sum(abs(Tss0-Tss))<1e-6)
        break;
    else
        Tss0=Tss;
    end 
 end
if(iter==nIter)
    warning('CalculateSS did not converge!');
end
[~,ib]=find(z>=0,1);
if(Tss(ib)>Tm)
    disp('Ice temperature warmer than Tm!');
    Tss0=Ts+zeros(size(z));
    for iter=1:nIter

        kc=2*(9.828.*exp(-0.0057*(273.15+Tss0))).*rho/rhoi./(3-rho/rhoi);
        Cp=(152.5+7.122*(273.15+Tss0))/31557600;

        kc(z<0)=(9.828.*exp(-0.0057*(273.15)));
        Cp(z<0)=(152.5+7.122*(273.15))/31557600;

        kd=kc./(rho.*Cp); %Diffusivity (m2 yr-1)

        % I1= int{w/kd dz}_0^z
        I1=cumtrapz(z,w./kd);
        u=exp(I1);

        %I2=int{u dz}_z^H
        I2=cumtrapz(flip(z),flip(u));
        I2=flip(I2);
        I2b=I2(ib);
        %T=Ts-int{u dz}_z^H
        Tss=Ts-(Ts-Tm)*I2/I2b;

        if(sum(abs(Tss0-Tss))<1e-6)
            break;
        else
            Tss0=Tss;
        end
    end
end

end