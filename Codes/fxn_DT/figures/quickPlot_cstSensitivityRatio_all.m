%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%
figure('Position', get(0, 'ScreenSize')), hold on

data = [];
IVs = [];
for iLoc = 1:5
    plotColor = colorGradient{iLoc,4};
    if iLoc == 1, plotColor = colors_comb(1,:); end
    if iLoc == 8, plotColor = colors_comb(8,:); end

    bObj = bar(iLoc, mean(squeeze(margCstRatio(iLoc, :))), 'FaceColor', plotColor, 'LineWidth', lineSize*1.5);
    
    errorbar(iLoc, mean(squeeze(margCstRatio(iLoc,:))), std(squeeze(margCstRatio(iLoc,:))/sqrt(nsubjs)), '.', 'Color', plotColor, 'LineWidth', lineSize*1.5, 'CapSize', 0)
    if iLoc < 6
        data = [data, margCstRatio(iLoc,:)];
        IVs = [IVs, ones(1,nsubjs).*iLoc];
    end
end

% for isubj = 1:nsubjs
%     plot(1:5, margCstRatio(1:5, isubj), 'Color', [.5, .5, .5], 'LineWidth', lineSize, 'Marker', markers_allSubj{isubj}, 'MarkerSize', markerFontSize)
% end

txt = print_nANOVA({'Loc'}, data, {IVs});
% title(txt)
fprintf('%s\n',txt)

xticks(1:5)
xticklabels(namesLocComb(1:5))
ylim([0 .16])
ylabel('CS Ratio')
set(findall(gcf, '-property', 'FontSize'), 'FontSize',36)

nameFileFigure = sprintf('%s/Magnitudes_CSTs.jpg', dirName);
exportgraphics(gcf,nameFileFigure, 'Resolution', 300)

%% 
figure('Position', get(0, 'ScreenSize')), hold on

data = [];
IV1s = [];
IV2s = [];
for iLoc = 1:5
    plotColor = colorGradient{iLoc,4};
    if iLoc == 1, plotColor = colors_comb(1,:); end
    if iLoc == 8, plotColor = colors_comb(8,:); end
    mm = squeeze(margMetrics_Mean(iLoc, :, 5));
    barObj = bar(iLoc, mm, 'FaceColor', plotColor);

    for iBin = 1:nBins
        plotColor = colorGradient{iLoc,iBin};
        if iLoc == 1, plotColor = colorGradient{9,iBin}; end
        if iLoc == 8, plotColor = colorGradient{10,iBin}; end
        barObj(iBin).FaceColor = plotColor;
    end

    errOffset(1,iLoc) = barObj(1).XEndPoints;
    errOffset(2,iLoc) = barObj(2).XEndPoints;
    errOffset(3,iLoc) = barObj(3).XEndPoints;
%     errOffset(4,iLoc) = barObj(4).XEndPoints;
    errorbar(errOffset(1:nBins, iLoc), mm, squeeze(margMetrics_SE(iLoc,1:nBins,5)), '.', 'CapSize', 0, 'LineWidth', 1, 'Color', plotColor)

    if iLoc < 6
        for isubj = 1:11
            a = squeeze(margMetrics(iLoc,isubj,:,5));
            data = [data, a'];
            IV1s = [IV1s, ones(1,nBins).*iLoc];
            IV2s = [IV2s, ones(1,nBins) * 1:nBins];
        end
    end
end
% data = squeeze(margMetrics(iLoc,isubj,:,5));
txt = sprintf('%s\n%s', print_nANOVA({'Loc','Bin'}, data', {IV1s', IV2s'}));
title(txt)

xticks(1:5)
xticklabels(namesLocComb(1:5))
ylabel('CS')
set(findall(gcf, '-property', 'FontSize'), 'FontSize',36)

nameFileFigure = sprintf('%s/Magnitudes_CSTs_all.jpg', dirName);
saveas(gcf,nameFileFigure)