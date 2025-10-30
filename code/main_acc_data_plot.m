function main_acc_data_plot(t, mean_accs, std_accs, accs, AgeW, accW, AgeC, accC, blues, pinks, oranges, greens)
    figure;
    
    % main plot to 25 ka 
    subplot(1, 4, 1:3);
    hold on;
    plot_ice_core_accs_and_err(t, mean_accs, std_accs, accs, AgeW, accW, AgeC, accC, blues, pinks, oranges, greens);
    xlim([0 25]);
    legend('1\sigma', '2\sigma', 'p = 1', 'p = 2', 'p = 3', 'p = 4', 'p = 5', ...
           'Mean (1\leqp\leq5)', 'WAIS Divide', 'Dome C', 'fontsize', 16, ...
           'orientation', 'horizontal', 'location', 'northoutside');

    % zoom in to 0-6ka (period constrained by observations)
    subplot(1, 4, 4);
    hold on;
    plot_ice_core_accs_and_err(t, mean_accs, std_accs, accs, AgeW, accW, AgeC, accC, blues, pinks, oranges, greens);
    xlim([0 6]);
    axis square;
end