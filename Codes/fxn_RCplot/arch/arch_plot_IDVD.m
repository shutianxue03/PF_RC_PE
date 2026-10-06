
% 1. plot behav at each session
close all
for isubj = 1:nsubj
    subjName = subjList{isubj};
    nblocks = nblocks_allSubj(isubj);
    
    load(sprintf('data_OOD/%s%d/%s_behavMeas.mat', subjName, nblocks, subjName));
    
    namesMetrics_plus2 = [namesMetrics, 'Contrast sensitivity', 'RT'];
    
    bm_perSess_all = {...
        dprime_perSess_perLoc, ...
        criterion_perSess_perLoc, ...
        squeeze(pC3_perSess_perLoc(:, :, 1)), ...
        squeeze(pC3_perSess_perLoc(:, :, 2)), ...
        squeeze(pC3_perSess_perLoc(:, :, 3)), ...
        squeeze(pA3_perSess_perLoc(:, :, 1)), ...
        squeeze(pA3_perSess_perLoc(:, :, 2)), ...
        squeeze(pA3_perSess_perLoc(:, :, 3)), ...
        1./cst_perSess_perLoc, ...
        log(RT_perSess_perLoc)};
    nSess = size(dprime_perSess_perLoc,1);
    nAllTrials = nSess*100;
    
    ticks_scatter_all = {0:.5:3, -1:.5:1, 0:.2:1, 0:.2:1, 0:.2:1, 0:.2:1, 0:.2:1, 0:.2:1, 0:4, -5:1:-1};
    lim_scatter_all = {[0, 3], [-1, 1],  [0, 1], [0, 1], [0, 1], [0, 1], [0, 1], [0, 1], [1, 4], [-5,-1]};
    yline_all = {dprime_theo, 0, threshPerf, .5, .5, .5, .5, .5, nan, nan};
    
    for im = 6%1:nmetrics+2
        bm_perSess = bm_perSess_all{im};
        figure('Position', [3e3 500 1500 300])
        
        % change
        subplot(1,5,1:4), hold on, grid on
        for iLoc = 1:nLoc5
            if iLoc== 4, linestyle = '--'; else, linestyle = '-'; end
            plot(bm_perSess(:,iLoc), linestyle, 'color',colors_comb(iLoc, :), 'LineWidth', .5),
        end
        % extra line
        if ~isnan(yline_all{im}), yline(yline_all{im}, '-', 'color', ones(1,3)*.5, 'linewidth', 2); end
        
        ylim(lim_scatter_all{im})
        yticks(ticks_scatter_all{im})
        if im == 10, yticklabels(round(exp(ticks_scatter_all{im})*100+500)), end
        
        xlabel('Session #')
        ylabel(namesMetrics_plus2{im})
        xtickInd = round(quantile(1:nSess, linspace(0,1,5)));
        if nSess > 1, xlim([0, nSess + 2])
            if nSess>2, xticks(xtickInd), xticklabels(xtickInd), else, xticks([1,2]), end
        else, xlim([.5,2]), xticks(1)
        end
        
        % bar
        subplot(1,5,5), hold on, grid on
        for iLoc = 1:nLoc5
            bar(iLoc, mean(bm_perSess(:, iLoc)), 'FaceColor', 'w', 'EdgeColor', colors_comb(iLoc, :))
            errorbar(iLoc, mean(bm_perSess(:, iLoc)), std(bm_perSess(:, iLoc)), '.', 'color', colors_comb(iLoc, :), 'CapSize', 0)
        end
        
        % extra line
        if ~isnan(yline_all{im}), yline(yline_all{im}, '-', 'color', ones(1,3)*.5, 'linewidth', 2); end
        
        xticks(1:nLoc5)
        xticklabels(namesLocComb(1:nLoc5))
        ylim(lim_scatter_all{im})
        yticks(ticks_scatter_all{im})
        yticklabels([])
        
        %
        set(findall(gcf, '-property', 'FontSize'), 'FontSize',18)
        sgtitle(sprintf('%s: %d trials per loc', subjName, nAllTrials), 'FontSize',22)
    end % im
end
