function [div, flank, h, basal10, basal, bed, oldest, hdata, irhs] = plot_age_depth_profiles(...
                   Age_p1, Age_p5, Age_mean, div_age, flank_age, ...
                   Age_p1_basal_melt_20mmyr, Age_p1_basal_melt_10mmyr, ...
                   AgeData, DepthData, known_ages, irh_err_d, irh_err, ...
                   H, z, Hmin, pinks, blues, greens)

    % plotting function for main_plot and plot_inset

    % variance beteen inverse model outputs (p=1:5)
    h = fill([Age_p1(z>Hmin)'/1e3, flip(Age_p5(z>Hmin))'/1e3], ...
             [H-z(z>Hmin), flip(H-z(z>Hmin))], ...
             [0.8, 0.8, 0.8], 'LineStyle', 'none');

    % forward models
    div = plot(div_age / 1e3, H - z, 'color', blues, 'linewidth', 2, 'LineStyle', '--'); % divide flow
    flank = plot(flank_age / 1e3, H - z, 'color', blues, 'LineWidth', 2); % flank flow
    
    % inverse model plot 
    basal10 = plot(Age_p1_basal_melt_10mmyr / 1e3, H - z, 'color', pinks, 'linestyle', ':', 'linewidth', 2); % 10 mm/yr melting
    basal = plot(Age_p1_basal_melt_20mmyr / 1e3, H - z, 'color', pinks, 'linestyle', '--', 'linewidth', 2); % 20 mm/yr melting
    opt = plot(Age_mean / 1e3, H - z, 'color', pinks, 'linewidth', 2); % no basal melting
    
    % ice core + IRH data + bed
    hdata = plot(AgeData(1:end-2) / 1e3, DepthData(1:end-2), 'Marker', 'o', 'Color', greens, 'MarkerSize', 4, 'MarkerFaceColor', greens , 'LineWidth', 2, 'LineStyle','none');
    errorbar(known_ages / 1e3, DepthData(end-1:end), irh_err_d, irh_err_d, irh_err, irh_err, ...
             'LineStyle', 'none', 'color', 'k');
    irhs = plot(known_ages / 1e3, DepthData(end-1:end), 'xk', 'MarkerSize', 10, 'MarkerFaceColor', 'k', 'LineWidth', 2);
    [bed, oldest] = plot_bed_and_oldest_ice(H, [0, 120]);


end