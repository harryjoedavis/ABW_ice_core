function th=ThinningVariation(t,th_guess,t_th_guess)
    th=zeros(size(t));
    th(t>t_th_guess(end))=interp1(t_th_guess,th_guess,t(t>t_th_guess(end)));
end