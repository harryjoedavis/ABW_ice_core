function Age=AgeDepthModelv5(z,t,acc_guess,t_acc_guess,th_guess,t_th_guess,AgeW,accW,melt,eta,e)

% This is just a wrapper for Matlab fminsearch digesting parameters
if(length(th_guess)==1) % Invert for accumulation
    acc=AccumulationVariation(t,acc_guess,t_acc_guess,AgeW,accW);
    th=th_guess*ones(size(t));
elseif(length(acc_guess)==1) % Invert for thinning
    acc=acc_guess*ones(size(t));
    th=ThinningVariation(t,th_guess,t_th_guess);
else
    error("Not ready for inverting both accumulation and thinning!");
end

Age0=AgeDepthSS(z,-(acc(1)-melt)*eta-th(1)*e-melt); 
Age=AgeDepthv5(Age0,z,t,acc,th,melt,eta,e);

end