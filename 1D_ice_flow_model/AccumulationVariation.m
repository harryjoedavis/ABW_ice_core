function acc=AccumulationVariation(t,acc_guess,t_acc_guess,AgeW,accW)
% Calculate acc for (t_acc_guess,acc_guess)

% Acc at WAIS Divide before t_Acc (ABW) but relative to Acc at ABW
accWEnd=interp1(-AgeW,accW,t_acc_guess(end));
acc=interp1(-AgeW,accW,t)*acc_guess(end)/accWEnd;

% Acc following picewise (t_Acc,Acc)
acc(t>t_acc_guess(end))=interp1(t_acc_guess,acc_guess,t(t>t_acc_guess(end)));
end