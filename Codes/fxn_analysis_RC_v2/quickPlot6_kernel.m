close all
figure('Position', [0, 0, 1800, 600])
for itype = 1:ntypes
    subplot(1, ntypes, itype), hold on
    imagesc(squeeze(kernels2D(itype, :, :)))
    axis square
    title([namesType{itype}, ' ', namesLocComb{iLocComb}])
    colorbar
    set(findall(gcf, '-property', 'FontSize'), 'FontSize',15)
end
sgtitle('Kernel', 'FontSize',15)
