function agess=AgeDepthSS(z,w)

% AgeDepthSS Simple function to calculate 1D age in steady-state. 
% 
% age=AgeDepthSS(z,w) 
% - age is the 1d age in steady-state,
% - z is elevation, and 
% - w is vertical velocity. 
%
% It uses gaussian quadrature (gaussquad.m) to calculate:
%      AgeDepth(z)=\int_z^s{dz'/w(z')}. 


% Elevation should be sorted in ascending order
swap=0;
if (~issorted(z))
[z,I]=sort(z);
w=w(I);
swap=1;
end


nz=length(z);
agess=zeros(size(z));
for i=nz-1:-1:1
    [zg, wg] = gaussquad(1, z(i), z(i+1));
    ig=-1.0./interp1(z,w,zg);
    agess(i)=agess(i+1)+sum(wg .* ig);
end


if(swap)
    unsorted=1:length(z);
    newI(I)=unsorted;
    agess=agess(newI);
end

end