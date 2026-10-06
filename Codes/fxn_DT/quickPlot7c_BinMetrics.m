%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%
%% quickplot metrics by location
xlim_allM = metricBounds;

ngroups = nLoc2;
nbars = nBins;
errOffset = nan(nbars, ngroups);
legendtxt = [];
for i = 1:nBins
    legendtxt = [legendtxt; sprintf('Bin %d', i)];
end
figure('Position', get(0, 'Screensize'))
for im  = 1:5
    subplot(2,3,im), hold on
    for iLoc = 1:nLoc2
        if iLoc == 1, plotColors = colorGradient(iLocComb_all(1),:); else, plotColors = colorGradient(iLocComb_all(2),:); end

        mm = squeeze(margMetrics_Mean(:, iLoc, im));
        b = bar(iLoc, mm, 'EdgeColor', plotColors{1}, 'FaceColor', 'none', 'LineWidth', borderSize);
        for ii = 1:nBins
            b(ii).EdgeColor = plotColors{ii};
        end
    end
    for i = 1:nbars
        errOffset(i,:) = b(i).XEndPoints;
    end
    errOffset(:,1) = errOffset(:,1) - 1;
    mm = squeeze(margMetrics_Mean(:,:,im));
    erB = errorbar(errOffset, mm, squeeze(margMetrics_SE(:,:,im)), '.', 'CapSize', 0, 'LineWidth',1);
    erB(1).Color = colorGradient{iLocComb_all(1),nBins};
    erB(2).Color = colorGradient{iLocComb_all(2),nBins};

    for isubj = 1:nsubjs
        mm = squeeze(margMetrics(isubj,:,:,im));
        plot(errOffset(:,1)-.05, squeeze(mm(:,1)), sprintf('%s-', markers_allSubj{isubj}), 'Color', [colorGradient{iLocComb_all(1),nBins}, .2])
        plot(errOffset(:,2)-.05, squeeze(mm(:,2)), sprintf('%s-', markers_allSubj{isubj}), 'Color', [colorGradient{iLocComb_all(2),nBins}, .2])
    end
%     legend(legendtxt);
    if exist('anovTbl', 'var') == 1
        txt = sprintf([namesMetrics{im} ...
                       '\nLoc: F(%d) = %01.4f, p = %01.4f\n' ...
                       'Time: F(%d) = %01.4f, p = %01.4f\n' ...
                       'Loc*Time: F(%d) = %01.4f, p = %01.4f'], ...
                       anovTbl{im}{2,3}, anovTbl{im}{2,5}, anovTbl{im}{2,6}, ...
                       anovTbl{im}{3,3}, anovTbl{im}{3,5}, anovTbl{im}{3,6}, ...
                       anovTbl{im}{4,3}, anovTbl{im}{4,5}, anovTbl{im}{4,6});
    elseif im == 4, txt = "Response Consistency"; elseif im ==5, txt = "Contrast Sensitivity";
    else
        txt = namesMetrics{im};
    end
    title(txt)
    txt = {sprintf('%s', namesLocComb{iLocComb_all(1)}), sprintf('%s', namesLocComb{iLocComb_all(2)})};
    xticks(1:length(iLocComb_all));
    xticklabels(txt)
    xlabel('Location')
    ylim(xlim_allM(im, :))
    if im == 1, yline(1);end
    if im == 3, yline(.7);end
end
txt = 'Plot metrics across blocks per location for all subjects';
sgtitle(txt)
set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)
set(findobj(gcf, 'Type', 'Legend'), 'FontSize', 8)

nameFileFigure = sprintf('figs/Perceptual Learning RC/%s/%s/Metrics.jpg', locName, folderName);
saveas(gcf,nameFileFigure)

%% by bins
%% quickplot metrics by location
ncats = nBins;
xlim_allM = metricBounds;
xlim_allM2 = xlim_allM(:,2).*.8;
xlim_allM2(2) = .3;
xlim_allM2(5) = 3.3; 

plotColors = colorGradient(iLocComb_all(1),:);
plotColors2 = colorGradient(iLocComb_all(2),:);
    
ngroups = nBins;
nbars = nLoc2;
errOffset = nan(nbars, ngroups);
figure('Position', get(0, 'Screensize'))
for im  = 1:5
    subplot(2,3,im), hold on
    for iBin= 1:nBins
        mm = squeeze(margMetrics_Mean(iBin, :, im));
        barObj = bar(iBin, mm, 'FaceColor', plotColors{iBin});
        barObj(2).FaceColor = plotColors2{iBin};
        errOffset(1,iBin) = barObj(1).XEndPoints;
        errOffset(2,iBin) = barObj(2).XEndPoints;
        % errorLoc = repmat(iLoc,nBins, 1);
        % errorbar(errorLoc, mm, squeeze(margMetrics_SE(:,iLoc,im))', '.k', 'CapSize', 0)
    end

    % Calculate within subj SEM
    withinSEM = nan(nsubjs, nBins);
    for iBin = 1:nBins
        for isubj = 1:nsubjs
            withinSEM(isubj,iBin) = margMetrics(isubj,iBin,1,im) - margMetrics(isubj,iBin,2,im);
        end
    end
    [~, ~, ~, ~, withinSEM] = getCI(withinSEM,2,1,1,ones(nsubjs));
    plot([errOffset(1,:)',errOffset(2,:)'],[xlim_allM2(im),xlim_allM2(im)], 'k')
    errorbar((1:nBins),xlim_allM2(im).*ones(1,nBins), withinSEM, '.k', 'CapSize',0, 'LineWidth',1)
    for iBin = 1:nBins
        t1 = squeeze(margMetrics(:,iBin,1,im));
        t2 = squeeze(margMetrics(:,iBin,2,im));

        [p, ~] = vartestn([t1;t2], 'Display','off');
        if p < .05, txt = 'unequal'; else, txt = 'equal'; end

        [h, p, ~, stats] = ttest2(t1, t2, 'Alpha', .05/ncats, 'Vartype',txt);

        if h == 0, txt = 'n.s.'; elseif p < .001/ncats, txt = '***'; elseif p < .01/ncats, txt = '**'; elseif p < .05/ncats, txt = '*'; else, txt = 'n.s.'; end
        if im == 5, text(iBin,3.4, txt, 'HorizontalAlignment','center'); else, text(iBin,xlim_allM2(im)*1.1, txt, 'HorizontalAlignment','center'); end
    end

    mm = squeeze(margMetrics_Mean(:,:,im));
%     errorbar(errOffset, mm', squeeze(margMetrics_SE(:,:,im))', '.', 'CapSize', 0, 'color', colors_comb(iLocComb_all(iLoc), :))
    erB = errorbar(errOffset(1,:), mm(:,1)', squeeze(margMetrics_SE(:,1,im))', '.', 'color', plotColors{nBins}, 'CapSize', 0);
    erB = errorbar(errOffset(2,:), mm(:,2)', squeeze(margMetrics_SE(:,2,im))', '.', 'color', plotColors2{nBins}, 'CapSize', 0);
%     for isubj = 1:nsubjs
%         mm = squeeze(margMetrics(isubj,:,:,im));
%         plot(errOffset(1,:), squeeze(mm(:,1)), '.-', 'Color', colors_comb(iLocComb_all(1),:))
%         plot(errOffset(2,:), squeeze(mm(:,2)), '.-', 'Color', colors_comb(iLocComb_all(2),:))
%     end
    % legend(namesLocComb{iLocComb_all(1)}, namesLocComb{iLocComb_all(2)})

    if exist('anovTbl', 'var') == 1
        txt = sprintf([namesMetrics{im} ...
                       '\nLoc: F(%d) = %01.4f, p = %01.4f\n' ...
                       'Time: F(%d) = %01.4f, p = %01.4f\n' ...
                       'Loc*Time: F(%d) = %01.4f, p = %01.4f'], ...
                       anovTbl{im}{2,3}, anovTbl{im}{2,5}, anovTbl{im}{2,6}, ...
                       anovTbl{im}{3,3}, anovTbl{im}{3,5}, anovTbl{im}{3,6}, ...
                       anovTbl{im}{4,3}, anovTbl{im}{4,5}, anovTbl{im}{4,6});
    else
        if im == 4, txt = "Response Consistency"; elseif im == 5, txt = "Contrast Sensitivity"; else
        txt = namesMetrics{im};
        end
    end
    title(txt)
    xlabel('Bin Index')
    xticks(1:nBins)
    ylim(xlim_allM(im, :))
    if im == 1, yline(1);end
    if im == 3, yline(.7);end
end

sgtitle('Plot metrics across blocks per location for all subjects')
set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)

nameFileFigure = sprintf('figs/Perceptual Learning RC/%s/%s/Metrics_v2.jpg', locName, folderName);
saveas(gcf,nameFileFigure)

%% Indvd metric
xlim_allM = metricBounds;
figure('Position', get(0, 'Screensize'))
for iLoc = 1:2
    if iLoc == 1, plotColors = colorGradient(iLocComb_all(1),:); else, plotColors = colorGradient(iLocComb_all(2),:); end

    for im = 1:5
        subplot(2,5,(iLoc-1)*5+im), hold on
        for iiSubj = 1:12
            pObj = plot(squeeze(margMetrics(iiSubj,:,iLoc,im))', sprintf('%s-',markers_allSubj{iiSubj}), 'Color', [plotColors{nBins}, .2]);
        end
        if im == 1, yline(1); end
        if im == 2, yline(0); end
        if im == 3, yline(.7); end
%         legend(subjList, 'NumColumns',4, 'Location', 'best')
        if im == 4, title("Response Consistency")
        elseif im == 5, title("Contrast Sensitivity")
        else, title(namesMetrics{im})
        end
        xlim([.5 nBins+.5])
        xticks(1:nBins)
        ylim(xlim_allM(im, :))
    end
end
set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)

nameFileFigure = sprintf('figs/Perceptual Learning RC/%s/%s/Metrics_Indvd.jpg', locName, folderName);
saveas(gcf,nameFileFigure)

%% Plot changes from Bin 1
% ratioMode = 2;
% 
% switch ratioMode
%     case 1, dataRatio = @(b1, b2) b2/b1 - 1;
%     case 2, dataRatio = @(b1, b2) (b2)/(b1+b2) - .5;
%     case 3, dataRatio = @(b1, b2) (b2-b1)/(b1+b2);
% end
% 
% xlim_allM = [-.25, .25];
% 
% ngroups = nLoc2;
% nbars = nBins;
% errOffset = nan(nbars, ngroups);
% 
% figure('Position', get(0, 'Screensize'))
% for im  = 1:5
%     subplot(2,3,im), hold on
%     for iLoc = 1:nLoc2
%         if iLoc == 1, plotColors = colorGradient(iLocComb_all(1),:); else, plotColors = colorGradient(iLocComb_all(2),:); end
% 
%         % calculate ratio
%         ratioMetric = squeeze(margMetrics_Mean(:,iLoc,im));
%         for iBin = 2:nBins
%             ratioMetric(iBin) = dataRatio(ratioMetric(1), ratioMetric(iBin));
%         end
%         ratioMetric(1) = dataRatio(ratioMetric(1), ratioMetric(1));
% 
%         mm = ratioMetric;
%         b = bar(iLoc, mm, 'FaceColor', plotColors{1});
%         for ii = 1:nBins
%             b(ii).FaceColor = plotColors{ii};
%         end
%     end
% 
%     if im == 4, txt = "Response Consistency"; elseif im ==5, txt = "Contrast Sensitivity";
%     else
%         txt = namesMetrics{im};
%     end
%     title(txt)
%     txt = {sprintf('%s', namesLocComb{iLocComb_all(1)}), sprintf('%s', namesLocComb{iLocComb_all(2)})};
%     xticks(1:length(iLocComb_all));
%     xticklabels(txt)
%     xlabel('Location')
%     ylim(xlim_allM)
% end
% txt = 'Plot metrics across blocks per location for all subjects';
% sgtitle(txt)
% set(findall(gcf, '-property', 'FontSize'), 'FontSize',15)
% set(findobj(gcf, 'Type', 'Legend'), 'FontSize', 8)
% 
% nameFileFigure = sprintf('figs/Perceptual Learning RC/Fovea&Periphery(5)/%s/Metrics_ratio.jpg', folderName);
% saveas(gcf,nameFileFigure)