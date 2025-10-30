function [bed, oldest] = plot_bed_and_oldest_ice(H, xRange)
    % add lines for bed and oldest ice
    bed = plot(xRange, [H, H], '-k', 'linewidth', 2);
    oldest = plot(xRange, [H-H/20, H-H/20], '--k', 'linewidth', 2);
end