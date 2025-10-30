function plot_ice_core_accs_and_err(t, mean_accs, std_accs, accs, AgeW, accW, AgeC, accC, blues, pinks, oranges, greens)
    % plot confidence intervals
    fill([-t'/1e3; flip(-t'/1e3)], ...
         [mean_accs + std_accs; flip(mean_accs - std_accs)], ...
         blues, 'FaceAlpha', 0.4, 'EdgeColor', 'none');
    fill([-t'/1e3; flip(-t'/1e3)], ...
         [mean_accs + 2*std_accs; flip(mean_accs - 2*std_accs)], ...
         blues, 'FaceAlpha', 0.2, 'EdgeColor', 'none');

    % plot accumulation rates for inverse model outputs adn WAIS Divide and Dome C ice cores
    for i = 1:5
        plot(-t/1e3, accs(:, i), 'MarkerSize', 1, 'LineWidth', 1.4, 'Color', blues * i/5);
    end

    % plot mean accumulation at ABW for p=1:5 and other deep ice core comparisons
    plot(-t/1e3, mean_accs, 'color', pinks, 'LineWidth', 1.4);
    plot(AgeW/1e3, accW, 'Color', oranges, 'LineWidth', 2);
    plot(AgeC/1e3, accC, 'Color', greens, 'LineWidth', 2);
    
    % axes settings and labels
    box on;
    grid on;
    xlabel('Age (ka)');
    ylabel({'Accumulation (m/yr)'});
    set(gca, 'fontsize', 18);
end


