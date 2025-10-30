function Age=AgeDepthModel(z,t,acc_guess,t_acc_guess,AgeW,accW,melt,eta)
% This is just a wrapper for Matlab fminsearch digesting parameters

acc=AccumulationVariation(t,acc_guess,t_acc_guess,AgeW,accW);

Age0=AgeDepthSS(z,-(acc(1)-melt)*eta-melt); 
Age=AgeDepth(Age0,z,t,acc,melt,eta);

end