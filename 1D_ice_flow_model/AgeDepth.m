function Age = AgeDepth( Age0,z,t,acc,melt,eta )

%AGEDEPTH Calculate Age-depth
% Semilagrangian method, two time level integration [Staniforth, A., and J. Cote (1991)]

%% A few Computational parameters
niter=1;
nz=length(z);
nsteps=length(t);


% Allocating memmory
Age=zeros(nsteps,nz);
%alpha=zeros(1,nz);
%zd=zeros(1,nz);
%wm=zeros(1,nz);
%dtnow=zeros(1,nz);
% 
% f = waitbar(0,'1','Name','Calculating Age-Depth',...
%     'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
% setappdata(f,'canceling',0);

Age(1,:)=Age0;
for step=2:nsteps
    
    % Check for clicked Cancel button
    % if getappdata(f,'canceling')
    %     break
    % end
    % Update waitbar and message
    % waitbar(step/nsteps,f,'Calculating Age-Depth');

    dt=(t(step)-t(step-1));       
    dtnow=dt*ones(1,nz);

    % alpha=zi-zd
    % alpha_(r+1) = dt * w(zi-alpha_r/2,t^(n+1/2))
    
    wm=-(interp1(t,acc,t(step)-dt/2.0,'pchip')-melt)*eta-melt;
    
    alpha=dt*wm; 
    for iter=1:niter              
        out=(z-alpha>z(end));
        alpha(out)=z(out)-z(end);      
        dtnow(out)=alpha(out)./interp1(z,wm,z(out)-alpha(out)/2.0,'pchip');
        
        alpha=dtnow.*interp1(z,wm,z-alpha/2.0,'pchip');
    end
    
    zd=z-alpha;
    
    Age(step,:) = interp1(z,Age(step-1,:),zd,'pchip')+ dtnow;
    Age(step,end)=0.0;
end
% delete(f);

Age=Age(end,:);

end

