%% Response Consistency
figure('Position', [0 0 800 800]), hold on
im = 4;
data = [];
loc = [];
bin = [];
for iLoc = 2:5
    plotColors = colors_comb(iLoc,:);

    cstSensitivity = squeeze(margMetrics_Mean(iLoc, :, im));
    b = bar(iLoc, cstSensitivity, 'FaceColor', plotColors, 'FaceAlpha', 0, 'EdgeColor', plotColors, 'LineWidth', 1.5);
    for i = 1:nBins
        b(i).FaceAlpha = i*.2;
        errorbar(b(i).XEndPoints, cstSensitivity(i), squeeze(margMetrics_SE(iLoc,i,im)), ...
            'Color', plotColors, 'CapSize', 0, 'LineWidth', 1.5)
        
        data = [data, squeeze(margMetrics(iLoc,:,i,im))];
        loc = [loc, ones(1,11) * iLoc];
        bin = [bin, ones(1,11) * i];
    end
end

fprintf('%s\n', print_nANOVA({'Loc', 'practice'}, data, {loc, bin}));
set(findall(gcf, '-property', 'FontSize'), 'FontSize',34)
set(findall(gcf, '-property', 'FontSize'), 'LineWidth',2)

xticklabels({'Fovea','LHM','UVM','RHM','LVM',})
xticks(1:5)
ylabel('response consitency', 'FontSize', 58)
ylim(metricBounds(im,:))
yticks(linspace(metricBounds(im,1), metricBounds(im,2), 3))
axis square

set(gca, 'LineWidth', 3.5)
set(gca().XAxis, 'TickLength', [0 0])

nameFileFigure = sprintf('%s/BehavioralMetrics_pA.jpg', dirName);
exportgraphics(gcf,nameFileFigure, 'Resolution', 300)

%% CS
figure('Position', [0 0 1600 800]), hold on
im = 5;
sem_diff_y = [3.6, 3.5, 3.5, 3.5, 3.5 3.5 3.5];
% sem_diff_y = [90 90 90 90 90 90]./100;
plotLocs = [1 8 6 7 5 3];
data = [];
loc = [];
bin = [];

for iLoc = 1:length(plotLocs)
    plotColors = colors_comb(plotLocs(iLoc),:);
%     plotColors = [1 1 1];
    cstSensitivity = squeeze(margMetrics_Mean(plotLocs(iLoc), :, im));
    b = bar(iLoc, cstSensitivity, 'FaceColor', plotColors, 'FaceAlpha', 1, 'EdgeColor', plotColors, 'LineWidth', 1.5);
    for i = 1:nBins
        b(i).FaceAlpha = (i+1)*.2;
%         b(i).FaceAlpha = 0;
        errorbar(b(i).XEndPoints, cstSensitivity(i), squeeze(margMetrics_SE(plotLocs(iLoc),i,im)), ...
            'Color', plotColors, 'CapSize', 0, 'LineWidth', 1.5)

        data = [data, squeeze(margMetrics(plotLocs(iLoc),:,i,im))];
        loc = [loc, ones(1,11) * iLoc];
        bin = [bin, ones(1,11) * i];
    end
    
%     b(1).FaceAlpha = .2;
%     b(2).FaceAlpha = 0;
%     b(3).FaceAlpha = 0;
%     b(4).FaceAlpha = 1;
    [h,p,~,stats] = ttest(squeeze(margMetrics(plotLocs(iLoc),:, 1, im)), squeeze(margMetrics(plotLocs(iLoc),:, nBins, im)), 'Alpha', .05/4);
    fprintf('%d: %.3f\n', plotLocs(iLoc), p)
end

plot([1 2], [3.3 3.3], '-k', 'LineWidth', 1.5)
errorbar(1.5, 3.3, std(squeeze(mean(margMetrics(1,:, :, im),3)) - squeeze(mean(margMetrics(8,:, :, im),3)))./sqrt(nsubjs), ...
        'Color', [0 0 0], 'CapSize', 0, 'LineWidth', 1.5)
plot([3 4], [3.3 3.3], '-k', 'LineWidth', 1.5)
errorbar(3.5, 3.3, std(squeeze(mean(margMetrics(6,:, :, im),3)) - squeeze(mean(margMetrics(7,:, :, im),3)))./sqrt(nsubjs), ...
        'Color', [0 0 0], 'CapSize', 0, 'LineWidth', 1.5)
plot([5 6], [3.3 3.3], '-k', 'LineWidth', 1.5)
errorbar(5.5, 3.3, std(squeeze(mean(margMetrics(5,:, :, im),3)) - squeeze(mean(margMetrics(3,:, :, im),3)))./sqrt(nsubjs), ...
        'Color', [0 0 0], 'CapSize', 0, 'LineWidth', 1.5)

fprintf('%s\n', print_nANOVA({'Loc', 'practice'}, data, {loc, bin}));

xlim([0 7])
xticklabels({'Fovea','Perifovea','HM', 'VM', 'LVM','UVM',})
xticks(1:length(plotLocs))
ylabel('contrast sensitivity')
ylim(metricBounds(im,:))

% Individual data
% mm = squeeze(margParamOri_Mean(:,:, itype, iparam));

% for isubj = 1:nsubjs
% mm = squeeze(margParamsOri(isubj,:,:,itype,iparam));
% plot(errOffset(:,1)-.05, squeeze(mm(:,1)), sprintf('%s-', markers_allSubj{isubj}), 'Color', [colorGradient{iLocComb_all(1),nBins}, .2])
% plot(errOffset(:,2)-.05, squeeze(mm(:,2)), sprintf('%s-', markers_allSubj{isubj}), 'Color', [colorGradient{iLocComb_all(2),nBins}, .2])
% end

set(findall(gcf, '-property', 'FontSize'), 'FontSize',36)
set(findall(gcf, '-property', 'FontSize'), 'LineWidth',2)
set(gca().XAxis, 'TickLength', [0 0])
% set(gca().XAxis, 'Color', [.5 .5 .5])
% set(gca().YAxis, 'Color', [.5 .5 .5])

nameFileFigure = sprintf('%s/BehavioralMetrics_CS.pdf', dirName);
exportgraphics(gcf,nameFileFigure, 'Resolution', 300)

%% CS_extent
figure('Position', [0 0 1600 800]), hold on
im = 4;
sem_diff_y = [3.6, 3.5, 3.5, 3.5, 3.5];
plotLocs = [1 8 6 7 5 3];
data = [];
loc = [];
bin = [];

for iLoc = 1:length(plotLocs)
    plotColors = colors_comb(plotLocs(iLoc),:);
%     plotColors = [1 1 1];
    cstSensitivity = squeeze(margMetrics_Mean(plotLocs(iLoc), nBins, im))-squeeze(margMetrics_Mean(plotLocs(iLoc), 1, im));
    b = bar(iLoc, cstSensitivity, 'FaceColor', 'w', 'FaceAlpha', 1, 'EdgeColor', plotColors, 'LineWidth', 8);
    
    SEM_diff = squeeze(std(squeeze(margMetrics(plotLocs(iLoc),:,nBins,im))-squeeze(margMetrics(plotLocs(iLoc),:,1,im)))./sqrt(nsubjs));
    errorbar(iLoc, cstSensitivity, SEM_diff, ...
        'Color', plotColors, 'CapSize', 0, 'LineWidth', 4.5)

    data = [data, squeeze(margMetrics(plotLocs(iLoc),:,nBins,im))-squeeze(margMetrics(plotLocs(iLoc),:,1,im))];
    loc = [loc, ones(1,11) * iLoc];
    
%     b(1).FaceAlpha = .2;
%     b(2).FaceAlpha = 0;
%     b(3).FaceAlpha = 0;
%     b(4).FaceAlpha = 1;
%     plot([b(1).XEndPoints, b(2).XEndPoints], [sem_diff_y(iLoc), sem_diff_y(iLoc)], '-k', 'LineWidth', 1.5)
%     errorbar(iLoc, sem_diff_y(iLoc), std(squeeze(margMetrics(iLoc,:, 4, im)) - squeeze(margMetrics(iLoc,:, 1, im))), ...
%             'Color', [0 0 0], 'CapSize', 0, 'LineWidth', 1.5)
    [h,p,~,stats] = ttest(squeeze(margMetrics(plotLocs(iLoc),:, nBins, im))-squeeze(margMetrics(plotLocs(iLoc),:, 1, im)), 0, 'Alpha', .05/4);
    fprintf('%d: %.3f\n', plotLocs(iLoc), p)
end
fprintf('%s\n', print_nANOVA({'Loc'}, data, {loc}));

plot([1 2], [.03 .03], '-k', 'LineWidth', 1.5)
errorbar(1.5, .03, std(squeeze(margMetrics(1,:, nBins, im)) - squeeze(margMetrics(8,:, 1, im)))./sqrt(nsubjs), ...
        'Color', [0 0 0], 'CapSize', 0, 'LineWidth', 1.5)
plot([3 4], [.03 .03], '-k', 'LineWidth', 1.5)
errorbar(3.5, .03, std(squeeze(margMetrics(6,:, nBins, im)) - squeeze(mean(margMetrics(7,:, 1, im))))./sqrt(nsubjs), ...
        'Color', [0 0 0], 'CapSize', 0, 'LineWidth', 1.5)
plot([5 6], [.03 .03], '-k', 'LineWidth', 1.5)
errorbar(5.5, .03, std(squeeze(margMetrics(5,:, nBins, im)) - squeeze(mean(margMetrics(3,:, 1, im))))./sqrt(nsubjs), ...
        'Color', [0 0 0], 'CapSize', 0, 'LineWidth', 1.5)

xlim([0 7 ])
xticklabels({'Fovea','Perifovea','HM','VM','LVM','UVM',})
xticks(1:length(plotLocs))
ylabel('Practice Effect')
% ylim(metricBounds(im,:))
% ylim([0 1])
ylim([-.05 .05])

% Individual data
% mm = squeeze(margParamOri_Mean(:,:, itype, iparam));

% for isubj = 1:nsubjs
% mm = squeeze(margParamsOri(isubj,:,:,itype,iparam));
% plot(errOffset(:,1)-.05, squeeze(mm(:,1)), sprintf('%s-', markers_allSubj{isubj}), 'Color', [colorGradient{iLocComb_all(1),nBins}, .2])
% plot(errOffset(:,2)-.05, squeeze(mm(:,2)), sprintf('%s-', markers_allSubj{isubj}), 'Color', [colorGradient{iLocComb_all(2),nBins}, .2])
% end

set(findall(gcf, '-property', 'FontSize'), 'FontSize',36)
set(findall(gcf, '-property', 'FontSize'), 'LineWidth',2)
set(gca().XAxis, 'TickLength', [0 0])
% set(gca().XAxis, 'Color', [.5 .5 .5])
% set(gca().YAxis, 'Color', [.5 .5 .5])

nameFileFigure = sprintf('%s/BehavioralMetrics_pA_extent.pdf', dirName);
exportgraphics(gcf,nameFileFigure, 'Resolution', 300)

%% CS indvd
figure('Position', [0 0 1600 800]), hold on
im = 5;
sem_diff_y = [3.6, 3.5, 3.5, 3.5, 3.5];
ploc = [.5 1 1.5;
        2.5 3 3.5;
        8.5 9 9.5;
        4.5 5 5.5;
        6.5 7 7.5];
for iLoc = 1:5
    plotColors = colors_comb(iLoc,:);
%     plotColors = [1 1 1];
    cstSensitivity = squeeze(margMetrics_Mean(iLoc, :, im));
    for i = [1 3]
        b = bar(ploc(iLoc,i), cstSensitivity(i), 'FaceColor', plotColors, 'EdgeColor', plotColors, 'LineWidth', 2, 'BarWidth', .25);
    
        if i == 1, b.FaceAlpha = .2; else, b.FaceAlpha = 1; end
%         if i == 2, b.FaceAlpha = .4; end
        errorbar(ploc(iLoc,i), cstSensitivity(i), squeeze(margMetrics_SE(iLoc,i,im)), ...
            'Color', plotColors, 'CapSize', 0, 'LineWidth', 1.5)
    end
    
%     b(1).FaceAlpha = .2;
%     b(2).FaceAlpha = 0;
%     b(3).FaceAlpha = 0;
%     b(4).FaceAlpha = 1;
    plot([ploc(iLoc,1), ploc(iLoc,3)], [3.75, 3.75], '-k', 'LineWidth', 2.5)
    errorbar(ploc(iLoc,2), 3.75, std(squeeze(margMetrics(iLoc,:, nBins, im)) - squeeze(margMetrics(iLoc,:, 1, im))), ...
            'Color', [0 0 0], 'CapSize', 0, 'LineWidth', 2.5)
    [h,p,~,stats] = ttest(squeeze(margMetrics(iLoc,:, 1, im)), squeeze(margMetrics(iLoc,:, nBins, im)), 'Alpha', .05/5);
    fprintf('%d: %.3f\n', iLoc, p)
    mm = squeeze(margMetrics(iLoc,:, :, im));

    for isubj = 1:nsubjs
        plot([ploc(iLoc,1)+.25, ploc(iLoc,nBins)-.25], [mm(:,1), mm(:,nBins)], '-', 'Color', [.5 .5 .5], 'LineWidth', 2.5)
    end
end

xlim([-.5 10.5])
% xticklabels({sprintf('Fovea'),'LHM','RHM','LVM','UVM',})
xticks([])
% ylabel('contrast sensitivity')
ylim([1.5 4])

set(findall(gcf, '-property', 'FontSize'), 'FontSize',36)
set(findall(gcf, '-property', 'FontSize'), 'LineWidth',2)
set(gca().XAxis, 'TickLength', [0 0])
% set(gca().XAxis, 'Color', [.5 .5 .5])
% set(gca().YAxis, 'Color', [.5 .5 .5])

nameFileFigure = sprintf('%s/BehavioralMetrics_CS.jpg', dirName);
exportgraphics(gcf,nameFileFigure, 'Resolution', 300)

%% CS HM collapsed
% figure('Position', [0 0 1600 800]), hold on
% im = 5;
% sem_diff_y = [3.6, 3.5, 3.5, 3.5, 3.5];
% plotLocs = [1 6 7 5 3];
% for iLoc = 1:5
%     plotColors = colors_comb(plotLocs(iLoc),:);
% %     plotColors = [1 1 1];
%     cstSensitivity = squeeze(margMetrics_Mean(plotLocs(iLoc), :, im));
%     b = bar(iLoc, cstSensitivity, 'FaceColor', plotColors, 'FaceAlpha', 1, 'EdgeColor', plotColors, 'LineWidth', 1.5);
%     for i = 1:nBins
%         b(i).FaceAlpha = (i+1)*.2;
% %         b(i).FaceAlpha = 0;
%         errorbar(b(i).XEndPoints, cstSensitivity(i), squeeze(margMetrics_SE(plotLocs(iLoc),i,im)), ...
%             'Color', plotColors, 'CapSize', 0, 'LineWidth', 1.5)
%     end
%     
% %     b(1).FaceAlpha = .2;
% %     b(2).FaceAlpha = 0;
% %     b(3).FaceAlpha = 0;
% %     b(4).FaceAlpha = 1;
% %     plot([b(1).XEndPoints, b(2).XEndPoints], [sem_diff_y(iLoc), sem_diff_y(iLoc)], '-k', 'LineWidth', 1.5)
% %     errorbar(iLoc, sem_diff_y(iLoc), std(squeeze(margMetrics(iLoc,:, 4, im)) - squeeze(margMetrics(iLoc,:, 1, im))), ...
% %             'Color', [0 0 0], 'CapSize', 0, 'LineWidth', 1.5)
%     [h,p,~,stats] = ttest(squeeze(margMetrics(plotLocs(iLoc),:, 1, im)), squeeze(margMetrics(plotLocs(iLoc),:, nBins, im)), 'Alpha', .05/4);
%     fprintf('%d: %.3f\n', iLoc, p)
% end
% 
% xlim([0 6])
% xticklabels({sprintf('Fovea'),'HM','VM','LVM','UVM'})
% xticks(1:5)
% ylabel('contrast sensitivity')
% ylim(metricBounds(im,:))
% 
% %             mm = squeeze(margParamOri_Mean(:,:, itype, iparam));
% 
% %             for isubj = 1:nsubjs
% %                 mm = squeeze(margParamsOri(isubj,:,:,itype,iparam));
% %                 plot(errOffset(:,1)-.05, squeeze(mm(:,1)), sprintf('%s-', markers_allSubj{isubj}), 'Color', [colorGradient{iLocComb_all(1),nBins}, .2])
% %                 plot(errOffset(:,2)-.05, squeeze(mm(:,2)), sprintf('%s-', markers_allSubj{isubj}), 'Color', [colorGradient{iLocComb_all(2),nBins}, .2])
% %             end
% 
% set(findall(gcf, '-property', 'FontSize'), 'FontSize',36)
% set(findall(gcf, '-property', 'FontSize'), 'LineWidth',2)
% set(gca().XAxis, 'TickLength', [0 0])
% set(gca().XAxis, 'Color', [.5 .5 .5])
% set(gca().YAxis, 'Color', [.5 .5 .5])
% 
% nameFileFigure = sprintf('%s/BehavioralMetrics_CS.jpg', dirName);
% exportgraphics(gcf,nameFileFigure, 'Resolution', 300)

%% dprime
fprintf('dprime\n')
figure('Position', [0 0 800 800]), hold on
im = 1;
data = [];
loc = [];
bin = [];
pLoc = [1 2 5 3 4];
for iLoc = [1 2 3 4 5]
    plotColors = colors_comb(iLoc,:);

    cstSensitivity = squeeze(margMetrics_Mean(iLoc, :, im));
    b = bar(pLoc(iLoc), cstSensitivity, 'FaceColor', plotColors, 'EdgeColor', plotColors, 'LineWidth', 1.5);
    for i = 1:nBins
        %b(i).FaceAlpha = i*.2;
        errorbar(b(i).XEndPoints, cstSensitivity(i), squeeze(margMetrics_SE(iLoc,i,im)), ...
            'Color', plotColors, 'CapSize', 0, 'LineWidth', 1.5)
        data = [data, squeeze(margMetrics(iLoc,:,i,im))];
        loc = [loc, ones(1,11) * iLoc];
        bin = [bin, ones(1,11) * i];
    end
	b(1).FaceAlpha = .4;
	b(2).FaceAlpha = .6;
	b(3).FaceAlpha = .8;

    plot([b(1).XEndPoints b(nBins).XEndPoints], [2 2], 'Color', 'k', 'LineWidth', 2.5)
    errorbar(pLoc(iLoc), 2, squeeze(margMetrics_SE(iLoc,1,im)-margMetrics_SE(iLoc,nBins,im)), ...
            'Color', 'k', 'CapSize', 0, 'LineWidth', 1.5)
end
fprintf('%s\n', print_nANOVA({'Loc', 'practice'}, data, {loc, bin}));

set(findall(gcf, '-property', 'FontSize'), 'FontSize',34)
set(findall(gcf, '-property', 'FontSize'), 'LineWidth',2)
xticks(1:5)
xticklabels({'Fovea','LHM','UVM','RHM','LVM',})
ylabel('d''', 'FontSize', 56)
set(gca().XAxis, 'TickLength', [0 0])
ylim([0 3])
yticks([0 1.5 3])
yline(1.0488, 'LineWidth', 2.5, 'Color', [.5 .5 .5])
axis square

set(gca, 'LineWidth', 3.5)

nameFileFigure = sprintf('%s/BehavioralMetrics_dprime.jpg', dirName);
exportgraphics(gcf,nameFileFigure, 'Resolution', 300)

%% dprime
% fprintf('dprime\n')
% figure('Position', [0 0 800 800]), hold on
% im = 1;
% data = [];
% loc = [];
% bin = [];
% pLoc = [1 2 5 3 4];
% for iLoc = [1 2 3 4 5]
%     plotColors = colors_comb(iLoc,:);
% 
%     cstSensitivity = squeeze(margMetrics_Mean(iLoc, :, im));
%     b = bar(pLoc(iLoc), cstSensitivity, 'FaceColor', plotColors, 'EdgeColor', plotColors, 'LineWidth', 1.5);
%     for i = 1:nBins
%         %b(i).FaceAlpha = i*.2;
%         errorbar(b(i).XEndPoints, cstSensitivity(i), squeeze(margMetrics_SE(iLoc,i,im)), ...
%             'Color', plotColors, 'CapSize', 0, 'LineWidth', 1.5)
%         data = [data, squeeze(margMetrics(iLoc,:,i,im))];
%         loc = [loc, ones(1,11) * iLoc];
%         bin = [bin, ones(1,11) * i];
%     end
% 	b(1).FaceAlpha = .4;
% 	b(2).FaceAlpha = .6;
% 	b(3).FaceAlpha = .8;
% 
%     plot([b(1).XEndPoints b(nBins).XEndPoints], [2 2], 'Color', 'k', 'LineWidth', 2.5)
%     errorbar(pLoc(iLoc), 2, squeeze(margMetrics_SE(iLoc,1,im)-margMetrics_SE(iLoc,nBins,im)), ...
%             'Color', 'k', 'CapSize', 0, 'LineWidth', 1.5)
% end
% fprintf('%s\n', print_nANOVA({'Loc', 'practice'}, data, {loc, bin}));
% 
% set(findall(gcf, '-property', 'FontSize'), 'FontSize',34)
% set(findall(gcf, '-property', 'FontSize'), 'LineWidth',2)
% set(findall(gcf, '-property', 'Font'), 'Arial')
% xticks(1:5)
% xticklabels({'Fovea','LHM','UVM','RHM','LVM',})
% ylabel('d''', 'FontSize', 56)
% set(gca().XAxis, 'TickLength', [0 0])
% ylim([0 3])
% yticks([0 1.5 3])
% yline(1.0488, 'LineWidth', 2.5, 'Color', [.5 .5 .5])
% axis square
% 
% set(gca, 'LineWidth', 3.5)
% 
% nameFileFigure = sprintf('%s/BehavioralMetrics_dprime.pdf', dirName);
% exportgraphics(gcf,nameFileFigure, 'Resolution', 300)

%% criterion
fprintf('criterion\n')
figure('Position', [0 0 800 800]), hold on
im = 2;
data = [];
loc = [];
bin = [];
pLoc = [1 2 5 3 4];
for iLoc = 1:5
    plotColors = colors_comb(iLoc,:);

    cstSensitivity = squeeze(margMetrics_Mean(iLoc, :, im));
    b = bar(pLoc(iLoc), cstSensitivity, 'FaceColor', plotColors, 'FaceAlpha', 0, 'EdgeColor', plotColors, 'LineWidth', 1.5);
    for i = 1:nBins
        b(i).FaceAlpha = (i+1)*.2;
        errorbar(b(i).XEndPoints, cstSensitivity(i), squeeze(margMetrics_SE(iLoc,i,im)), ...
            'Color', plotColors, 'CapSize', 0, 'LineWidth', 1.5)
        
        data = [data, squeeze(margMetrics(iLoc,:,i,im))];
        loc = [loc, ones(1,11) * iLoc];
        bin = [bin, ones(1,11) * i];
    end

    plot([b(1).XEndPoints b(nBins).XEndPoints], [.75 .75], 'Color', 'k', 'LineWidth', 2.5)
    errorbar(pLoc(iLoc), .75, squeeze(margMetrics_SE(iLoc,1,im)-margMetrics_SE(iLoc,nBins,im)), ...
            'Color', 'k', 'CapSize', 0, 'LineWidth', 1.5)
end
fprintf('%s\n', print_nANOVA({'Loc', 'practice'}, data, {loc, bin}));
set(findall(gcf, '-property', 'FontSize'), 'FontSize',34)
set(findall(gcf, '-property', 'FontSize'), 'LineWidth',2)
xticklabels({'Fovea','LHM','UVM','RHM','LVM',})
xticks(1:5)
ylabel('criterion', 'FontSize', 56)
ylim([-1 1])
yticks([-1 0 1])
yline(0,'-k','LineWidth', 2.5)
axis square

set(gca, 'LineWidth', 3.5)
set(gca().XAxis, 'TickLength', [0 0])

nameFileFigure = sprintf('%s/BehavioralMetrics_criterion.pdf', dirName);
exportgraphics(gcf,nameFileFigure, 'Resolution', 300)

%% hitRate
fprintf('hitRate\n')
figure('Position', [0 0 800 800]), hold on
im = 7;
data = [];
loc = [];
bin = [];
pLoc = [1 2 5 3 4];
for iLoc = [1 2 3 4 5]
    plotColors = colors_comb(iLoc,:);

    cstSensitivity = squeeze(margMetrics_Mean(iLoc, :, im));
    b = bar(pLoc(iLoc), cstSensitivity, 'FaceColor', plotColors, 'FaceAlpha', 0, 'EdgeColor', plotColors, 'LineWidth', 1.5);
    for i = 1:nBins
        b(i).FaceAlpha = (i+1)*.2;
        errorbar(b(i).XEndPoints, cstSensitivity(i), squeeze(margMetrics_SE(iLoc,i,im)), ...
            'Color', plotColors, 'CapSize', 0, 'LineWidth', 1.5)
        data = [data, squeeze(margMetrics(iLoc,:,i,im))];
        loc = [loc, ones(1,11) * iLoc];
        bin = [bin, ones(1,11) * i];
    end
end
fprintf('%s\n', print_nANOVA({'Loc', 'practice'}, data, {loc, bin}));

set(findall(gcf, '-property', 'FontSize'), 'FontSize',34)
set(findall(gcf, '-property', 'FontSize'), 'LineWidth',2)
xticklabels({'Fovea','LHM','UVM','RHM','LVM',})
xticks(1:5)
% ylabel('d''', 'FontSize', 56)
set(gca().XAxis, 'TickLength', [0 0])
ylim([0 1])
yticks([0 .5 1])
yline(.5, 'LineWidth', 2.5, 'Color', [.5 .5 .5])
axis square

set(gca, 'LineWidth', 3.5)

nameFileFigure = sprintf('%s/BehavioralMetrics_hitRate.jpg', dirName);
exportgraphics(gcf,nameFileFigure, 'Resolution', 300)

%% falseAlarm Rate
fprintf('falseAlarm Rate\n')
figure('Position', [0 0 800 800]), hold on
im = 6;
data = [];
loc = [];
bin = [];
pLoc = [1 2 5 3 4];
for iLoc = [1 2 3 4 5]
    plotColors = colors_comb(iLoc,:);

    cstSensitivity = squeeze(margMetrics_Mean(iLoc, :, im));
    b = bar(pLoc(iLoc), cstSensitivity, 'FaceColor', plotColors, 'FaceAlpha', 0, 'EdgeColor', plotColors, 'LineWidth', 1.5);
    for i = 1:nBins
        b(i).FaceAlpha = (i+1)*.2;
        errorbar(b(i).XEndPoints, cstSensitivity(i), squeeze(margMetrics_SE(iLoc,i,im)), ...
            'Color', plotColors, 'CapSize', 0, 'LineWidth', 1.5)
        data = [data, squeeze(margMetrics(iLoc,:,i,im))];
        loc = [loc, ones(1,11) * iLoc];
        bin = [bin, ones(1,11) * i];
    end
end
fprintf('%s\n', print_nANOVA({'Loc', 'practice'}, data, {loc, bin}));

set(findall(gcf, '-property', 'FontSize'), 'FontSize',34)
set(findall(gcf, '-property', 'FontSize'), 'LineWidth',2)
xticklabels({'Fovea','LHM','UVM','RHM','LVM',})
xticks(1:5)
% ylabel('d''', 'FontSize', 56)
set(gca().XAxis, 'TickLength', [0 0])
ylim([0 1])
yticks([0 .5 1])
yline(.5, 'LineWidth', 2.5, 'Color', [.5 .5 .5])
axis square

set(gca, 'LineWidth', 3.5)

nameFileFigure = sprintf('%s/BehavioralMetrics_pFA.jpg', dirName);
exportgraphics(gcf,nameFileFigure, 'Resolution', 300)

%% CS HVA VMA
figure('Position', [0 0 800 800]), hold on
im = 5;
% sem_diff_y = [3.6, 3.5, 3.5, 3.5, 3.5];
loc1 = 5;
loc2 = 3;
% ylim_all = [2 3.5];
% ytick_all = [1.5 2 2.5 3 3.5];
% ytick_all = [0 1.5 3];
% ylim_all = [0 3];
% ytick_all = [-1 0 1];
% ylim_all = [-1 1];

nameFig = 'VMA';
metricName = 'CS';
xlabel_names = {'LVM', 'UVM'};
%HVA
% plotColors = colors_comb(iLoc,:);

cstSensitivity_mean = squeeze(margMetrics_Mean(:, :, im));
cstSensitivity = squeeze(margMetrics(:, :, :, im));
errorbar(1, mean(cstSensitivity_mean(loc1,:)), squeeze(std(mean(cstSensitivity(loc1,:,:),3,'omitnan'),[],2,'omitnan'))/sqrt(nsubjs), 'LineStyle', 'none', 'CapSize', 0, 'Color', colors_comb(loc1,:), 'LineWidth', 4)
errorbar(2, mean(cstSensitivity_mean(loc2,:)), squeeze(std(mean(cstSensitivity(loc2,:,:),3,'omitnan'),[],2,'omitnan'))/sqrt(nsubjs), 'LineStyle', 'none', 'CapSize', 0, 'Color', colors_comb(loc2,:), 'LineWidth', 4)
plot(1, mean(cstSensitivity_mean(loc1,:)), 'o', 'MarkerEdgeColor', colors_comb(loc1,:), 'MarkerFaceColor', 'none', 'MarkerSize', 48, 'LineWidth',8);
plot(2, mean(cstSensitivity_mean(loc2,:)), 'o', 'MarkerEdgeColor', colors_comb(loc2,:), 'MarkerFaceColor', 'none', 'MarkerSize', 48, 'LineWidth',8);
    
[h,p,~,stats] = ttest(squeeze(mean(cstSensitivity(loc1, :, :),3)), squeeze(mean(cstSensitivity(loc2, :, :),3)), 'Alpha', .05, 'tail', 'right');
fprintf('Bin%d: t(%d)=%.3f, p=%.3f\n', 1, stats.df, stats.tstat, p)

semD = squeeze(std(mean(cstSensitivity(loc1,:,:),3,'omitnan')-mean(cstSensitivity(loc2,:,:),3,'omitnan'),[],2,'omitnan'))/sqrt(nsubjs);
plot([1 2], [3.3 3.3], '-k', 'LineWidth', 2)
errorbar(1.5, 3.3, semD, 'LineStyle', 'none', 'CapSize', 0, 'Color', [0 0 0], 'LineWidth', 4)

for isubj = 1:nsubjs
    plot([1.25, 1.75], [mean(cstSensitivity(loc1,isubj,:),3), mean(cstSensitivity(loc2,isubj,:),3)], '-', 'Color', [.7 .7 .7], 'LineWidth', 2.5)
end

ylabel(metricName)
xticklabels(xlabel_names)
xticks([1 2])
xlim([0 3])
% ylabel('Contrast Sensitivity')
% ylim(ylim_all)
% yticks(ytick_all)
% yline(0, 'LineWidth', 2.5, 'Color', 'k')
% yline(1.0488, 'LineWidth', 2.5, 'Color', 'k')

set(findall(gcf, '-property', 'FontSize'), 'FontSize',36)
% set(findall(gcf, '-property', 'FontSize'), 'LineWidth',4)
set(gca().XAxis, 'TickLength', [0 0])
% set(gca().XAxis, 'Color', [.5 .5 .5])
set(gca().XAxis, 'LineWidth', 4)
% set(gca().YAxis, 'Color', [.5 .5 .5])
set(gca().YAxis, 'LineWidth', 4)

nameFileFigure = sprintf('%s/BehavioralMetrics_%s_%s.pdf', dirName,metricName, nameFig);
exportgraphics(gcf,nameFileFigure, 'Resolution', 300)

%% CS HVA VMA
figure('Position', [0 0 800 800]), hold on
im = 4;
sem_diff_y = [3.6, 3.5, 3.5, 3.5, 3.5];
loc1 = 6;
loc2 = 7;
%HVA
% plotColors = colors_comb(iLoc,:);

cstSensitivity_mean = squeeze(margMetrics_Mean(:, :, im));
cstSensitivity = squeeze(margMetrics(:, :, :, im));iAxis
HVA = (squeeze(cstSensitivity(6,:,:)-cstSensitivity(7,:,:)))./(squeeze(cstSensitivity(6,:,:)+cstSensitivity(7,:,:))).*100;
VMA = (squeeze(cstSensitivity(5,:,:)-cstSensitivity(3,:,:)))./(squeeze(cstSensitivity(5,:,:)+cstSensitivity(3,:,:))).*100;
    
data = [];
asym = [];
bin = [];

for iBin = 1:nBins
    b1=bar(iBin, mean(HVA(:,iBin)), 'EdgeColor', 'w', 'FaceColor', colors_comb(loc1,:), 'EdgeAlpha', 0, 'LineWidth', 8);
    errorbar([b1.XEndPoints], mean(HVA(:,iBin)), squeeze(std(HVA(:,iBin),[],1))/sqrt(nsubjs), 'LineStyle', 'none', 'CapSize', 0, 'Color', colors_comb(loc1,:), 'LineWidth', 4)
    b2=bar(iBin+5, mean(VMA(:,iBin)), 'EdgeColor', 'w', 'FaceColor', colors_comb(loc2,:), 'EdgeAlpha', 0, 'LineWidth', 8);
    errorbar([b2.XEndPoints], mean(VMA(:,iBin)), squeeze(std(VMA(:,iBin),[],1))/sqrt(nsubjs), 'LineStyle', 'none', 'CapSize', 0, 'Color', colors_comb(loc2,:), 'LineWidth', 4)

    b1.FaceAlpha = (iBin+1)*.2;
    b2.FaceAlpha = (iBin+1)*.2;

    fprintf('===Bin %i===\n',iBin)
    [h,p,~,stats] = ttest(squeeze(HVA(:,iBin)), 0, 'Alpha', .05, 'tail', 'right');
    fprintf('HVA: %.3f\n', p)

    [h,p,~,stats] = ttest(squeeze(VMA(:,iBin)), 0, 'Alpha', .05, 'tail', 'right');
    fprintf('VMA: %.3f\n', p)
    fprintf('\n')

    data = [data, squeeze(HVA(:,iBin))'];
    asym = [asym, ones(1,11) * 1];
    bin = [bin, ones(1,11) * iBin];
    data = [data, squeeze(VMA(:,iBin))'];
    asym = [asym, ones(1,11) * 2];
    bin = [bin, ones(1,11) * iBin];
end

fprintf('%s\n', print_nANOVA({'Asym', 'practice'}, data, {asym, bin}));

plot([1 3], [4 4], '-k', 'LineWidth', 2)
errorbar(2, 4, std(HVA(:,3)-HVA(:,1))./sqrt(nsubjs), 'LineStyle', 'none', 'CapSize', 0, 'Color', [0 0 0], 'LineWidth', 2)

plot([6 8], [4 4], '-k', 'LineWidth', 2)
errorbar(7, 4, std(VMA(:,3)-VMA(:,1))./sqrt(nsubjs), 'LineStyle', 'none', 'CapSize', 0, 'Color', [0 0 0], 'LineWidth', 2)

% semD = std(mean(cstSensitivity(loc1, :, :),3) - mean(cstSensitivity(loc2, :, :),3),[],2)/sqrt(nsubjs);
% plot([1 2], [2.75 2.75], '-k', 'LineWidth', 2)
% errorbar(1.5, 2.75, semD, 'LineStyle', 'none', 'CapSize', 0, 'Color', [0 0 0], 'LineWidth', 8)

% for isubj = 1:nsubjs
%     plot([1, 2], [mean(cstSensitivity(loc1,isubj,:),3), mean(cstSensitivity(loc2,isubj,:),3)], '-', 'Color', [.5 .5 .5], 'LineWidth', 2.5)
% end

xticklabels({'HVA','VMA'})
xticks([2 7])
xlim([0 10])
ylabel('Asymmetry (%)')
ylim([-5 5])
% ylim([0 10])
% yticks(-5:5:5)

set(findall(gcf, '-property', 'FontSize'), 'FontSize',48)
% set(findall(gcf, '-property', 'FontSize'), 'LineWidth',4)
set(gca().XAxis, 'TickLength', [0 0])
% set(gca().XAxis, 'Color', [.5 .5 .5])
set(gca().XAxis, 'LineWidth', 4)
% set(gca().YAxis, 'Color', [.5 .5 .5])close all
set(gca().YAxis, 'LineWidth', 4)

nameFileFigure = sprintf('%s/BehavioralMetrics_pA_Asym.pdf', dirName);
exportgraphics(gcf,nameFileFigure, 'Resolution', 300)