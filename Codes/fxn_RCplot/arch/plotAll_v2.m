

% RCplot_setting
% if nsubj==1, errType = 1; else, errType = 2; end %1=68%CI, 2=SEM
% save('params_RCplot_temp', 'n*', 'names*', 'axis*', 'colors*','errType', 'subjName', 'subplot_locs', 'combInd', 'dprime_theo');

iLocComb_all = [1,8];

%% plot behav measurements
namesMetrics_plus2 = [namesMetrics, 'Contrast sensitivity', 'RT'];
yline_all = {dprime_theo, 0, threshPerf, nan, nan, nan, nan, nan, nan, nan};
% ticks_scatter_all = {0.4:.7:1.8, -1:1:1, .6:.1:.8, .6:.15:9, 0:.5:1, .6:.15:9, .6:.15:9, .6:.15:9, -.5:.15:-.2, -3:-1};
% lim_scatter_all = {[.26, 1.94], [-1.2, 1.2],  [.58, .82], [.57, .93], [-.1, 1.1], [.57, .93], [.57, .93], [.57, .93], [-.57, -.13], [-3.2,-.8]};

ticks_scatter_all = {0.4:.7:1.8, -1:1:1, .6:.1:.8, .6:.15:9, 0:.5:1, .6:.15:9, .6:.15:9, .6:.15:9, 2:4 -3:-1};
lim_scatter_all = {[.26, 1.94], [-1.2, 1.2],  [.58, .82], [.57, .93], [-.1, 1.1], [.57, .93], [.57, .93], [.57, .93], [1.8, 4.2], [-3.2,-.8]};

for im = 1:nmetrics + 2
    %     subplot(2,5,im), hold on
    figure('Position', [0 0 300 300]), hold on
    for iiLoc = 1:nLoc2
        if im <= nmetrics
            mm = squeeze(metrics_allSubj(:, :, iiLoc, im));
        elseif im == 9 % cs (1/cst)
%             mm = log10(cst_allSubj(:, :, iiLoc));
            mm = 1./(cst_allSubj(:, :, iiLoc));
        else % RT
            mm = log(RT_allSubj(:, :, iiLoc));
        end
        [mm_med, ~, ~, mm_neg, mm_pos] = getCI(mm, 1, 2);
        mm_med2(:, iiLoc) = mm_med;
        mm_neg2(:, iiLoc) = mm_neg;
        mm_pos2(:, iiLoc) = mm_pos;
        mm_sem = std(mm_med)/sqrt(nsubj);
        %         bar(iLoc, mm_ave)
        %         errorbar(iLoc, mm_ave, mm_sem, 'k', 'Capsize', 0)
    end % iLoc
    [~, p, ~, stats] = ttest(mm_med2(:,1), mm_med2(:,2));
    
    % grey lines: idvd
    %     for isubj = 1:nsubj, plot(1:nLoc2, mm2(isubj, :), '-', 'color', ones(1,3)*.5), end
    
    % scatter
    for isubj = 1:nsubj
        %     errorbar
        errorbar(mm_med2(isubj, 2), mm_med2(isubj, 1), ...
            mm_neg2(isubj, 1), mm_neg2(isubj, 2), ...
            mm_pos2(isubj, 1), mm_pos2(isubj, 2), ...
            '.k', 'color', ones(1,3)*.5, 'CapSize', 0, 'linewidth', 1.5)
%         plot(mm_med2(isubj, 1), mm_med2(isubj, 2), ...
%             markers_allSubj{isubj}, 'LineStyle', 'none', 'MarkerFaceColor', ones(1,3)*.5, 'MarkerEdgeColor', ones(1,3)*.5)
        plot(mm_med2(isubj, 2), mm_med2(isubj, 1), ...
            'o', 'LineStyle', 'none', 'MarkerFaceColor', 'w', 'MarkerEdgeColor', ones(1,3)*.5)
       
    end
    
    % group ave
    mm_ave = mean(mm_med2);
    mm_sd = std(mm_med2);
    mm_sem = mm_sd/sqrt(nsubj);
    errorbar(mm_ave(2), mm_ave(1), mm_sd(2), 'Horizontal', '.', 'color', [.5, 0, 1], 'linewidth', 2, 'CapSize', 0)
    errorbar(mm_ave(2), mm_ave(1), mm_sd(1), 'Vertical', '.', 'color', [.5, 0, 1], 'linewidth', 2, 'CapSize', 0)
    
    % diagonal line
    plot(lim_scatter_all{im}, lim_scatter_all{im}, 'k-')
    
%     extra line
    if ~isnan(yline_all{im})
        yline(yline_all{im}, '-', 'color', ones(1,3)*.5);
        xline(yline_all{im}, '-', 'color', ones(1,3)*.5);
    end
    
    % limit
    xlim(lim_scatter_all{im})
    ylim(lim_scatter_all{im})
    % ticks and
    xticks(ticks_scatter_all{im})
    yticks(ticks_scatter_all{im})
    % ticklabels
    switch im
        case 10 % RT
            xticklabels(round(exp(ticks_scatter_all{im})*100+500))
            yticklabels(round(exp(ticks_scatter_all{im})*100+500))
%         case 9 % CS (1/cst)
%             xticklabels(round(10.^(ticks_scatter_all{im})*100))
%             yticklabels(round(10.^(ticks_scatter_all{im})*100))
%             xticklabels(round(1./(ticks_scatter_all{im})))
%             yticklabels(round(1./(ticks_scatter_all{im})))
    end
    
    xlabel(namesLocComb{iLocComb_all(2)})
    ylabel(namesLocComb{iLocComb_all(1)})
    axis square
    box on
%     title(sprintf('%s\nt(%d) = %.3f, p = %.3f', namesMetrics_plus2{im}, stats.df, stats.tstat, p))
    set(findall(gcf, '-property', 'FontSize'), 'FontSize',15)
    saveas(gcf, sprintf('talk2022/fig/RC/behavMeas_%s.jpg', namesMetrics_plus2{im}))
end % im

%% check if dprime, pC, criterion deviates from the reference
theo = [dprime_theo, 0, .7];
for im = [1,2,3]
    mm_med= getCI(metrics_allSubj(:, :, :, im), 1, 2);
mm_med = mm_med(:); 
[~, p, ~, stats] = ttest(mm_med, theo(im));
fprintf('%s: t(%d) = %.3f, p=%.3f\n', namesMetrics{im}, stats.df, stats.tstat,p)
end

%% compute the cst change across all blocks
clc
subjList = {'YK', 'SP', 'SX', 'LS', 'RE', 'MD', 'AS', 'HL', 'FH', 'HA', 'CS','DT'};
nblocks_allSubj = [200, 240, 210, 240, 220, 220, 215, 220, 205, 210, 205, 205];
nsubj = length(subjList);

deviance_allSubj = nan(nsubj, 5);
for isubj = 1:nsubj
    subjName = subjList{isubj};
    nblocks = nblocks_allSubj(isubj);
    nameBehavMeas = sprintf('Data_OOD/%s%d/%s_behavMeas.mat', subjName, nblocks, subjName);
    
    fprintf('%s...', subjName)
    load(nameBehavMeas)
    fprintf(' loaded\n')
    for iLoc = 1:5
        cst_unik = log10(unique(dataMatrix(dataMatrix(:, 5) == iLoc, 11)));
        deviance = cst_unik/median(cst_unik) - 1;
        
        fprintf('%s: dev mean = %.4f, std = %.4f\n', namesLocComb{iLoc}, mean(deviance)*100, std(deviance)*100)
        
        deviance_allSubj(isubj, iLoc) = mean(mean(deviance))*100;
    end
    clear dataMatrix
end

clc
for iLoc = 1:5
    fprintf('%s: %.2f%% (%.2f%%), ', namesLocComb{iLoc}, mean(deviance_allSubj(:, iLoc)), std(deviance_allSubj(:, iLoc)))
end

%% pYES vs. binned energy
wd_border=1; sz_ticks = 40; sz_title=40;
[pYES_med, ~, ~, pYES_neg, pYES_pos] = getCI(pYES_tgt_allSubj, 1, 2); % nsubj x ntypes x nLoc x nbins_e
[ebin_med, ~, ~, ebin_neg, ebin_pos] = getCI(ebin_tgt_allSubj, 1, 2);

RCplot_pYES_ebin_talk2022
% the ANOVA results are printed in the command window

%% 2D kernels
pCriterion = .001;
itype = 3;
e2D_med_allSubj = getCI(kernels2D_allSubj(:, :, :, itype, :, :), 1, 2); % med kernel of each subj (to conduct t-test on FP diff)
[e2D_ave, ~, ~, e2D_sd] = getCI(e2D_med_allSubj, 2, 1);

% Fovea
figure('Position', [0 0 4e2 4e2])
RCplot_2Dkernel(squeeze(e2D_ave(1, :, :))', [-.05, .3])
set(findall(gcf, '-property', 'FontSize'), 'FontSize',18)
title('Fovea', 'FontSize',20)
saveas(gcf, 'talk2022/fig/RC/kernel2D_fovea.jpg')

% Fovea
figure('Position', [0 0 4e2 4e2])
RCplot_2Dkernel(squeeze(e2D_ave(2, :, :))', [-.05, .3])
set(findall(gcf, '-property', 'FontSize'), 'FontSize',18)
title('Periphery', 'FontSize',20)
saveas(gcf, 'talk2022/fig/RC/kernel2D_peri.jpg')

% Diff
figure('Position', [0 0 4e2 4e2])
% diff = squeeze(e2D_med_allSubj(:, 1, :, :) - e2D_med_allSubj(:, 2, :, :));
diff_ave = squeeze(e2D_ave(1, :, :) - e2D_ave(2, :, :));
RCplot_2Dkernel(diff_ave', [-.05, .1])
set(findall(gcf, '-property', 'FontSize'), 'FontSize',18)
title('Fovea minus Periphery', 'FontSize',20)
saveas(gcf, 'talk2022/fig/RC/kernel2D_diff.jpg')

%% separability
[sep_med, ~, ~, sep_neg, sep_pos] = getCI(sep_allSubj(:, :, :, itype), 1, 2);
wd_border = 3; sz_label = 40; sz_ticks = 30; sz_title = 40; 
figure('Position', [0 400 1000 600])
hold on
for iiLoc = 1:nLoc2
    x  =(1:nsubj) + .05 * (-1)^iiLoc;
    errorbar(x, sep_med(:, iiLoc), sep_neg(:, iiLoc), sep_pos(:, iiLoc), ['.', colors2{iiLoc}], 'CapSize', 0, 'linewidth', wd_border/2, 'handlevisibility', 'off')
    plot(x, sep_med(:, iiLoc), 'o','MarkerEdgeColor', 'w', 'MarkerFaceColor', colors2{iiLoc}, 'MarkerSize', 20)
end
ylabel('Correlation', 'FontSize', sz_label)
ylim([0, 1])
xlim([0,nsubj+1])
xticks(1:nsubj)
yticks([0,.5:.1:1])
xticklabels(1:nsubj)
xlabel('Observer #')
box on
ax = gca; ax.XAxis.FontSize = sz_ticks; ax.YAxis.FontSize = sz_ticks; ax.LineWidth = wd_border;
[ll, objh] = legend({'Fovea', 'Periphery'}, 'Location', 'southeast','FontSize', sz_ticks);
objhl = findobj(objh, 'type', 'line');
set(objhl, 'Markersize', 20);
title('ORI-SF separability', 'FontSize', sz_title)
saveas(gcf, 'talk2022/fig/RC/sep.jpg')


%% marginalized kernels per combined loc
% RCplot_MARGCombLoc
itype = 3;
ytext_R2_all = {[.2-.1/5, .2-.1/5*2.5], [.12-.06/5, .12-.06/5*2.5]};
ystars  = [.2-.1*2.6, .12-.06*2.6];
sz_ticks = 20; sz_label=25; sz_text = 25;sz_stars = 15;
for ifeature = 1:2
    xaxis = axis_tuning{ifeature};
    nfilters = length(xaxis);
    
    nameModelParams = namesParams_unit_perF{ifeature};
    nparams = length(nameModelParams);
    
    figure('Position', [0 0 1000 500])
    hold on, box on
    peak{ifeature} = nan(2, nsubj);
    for iiLoc = 1:2
        if ifeature == 1
            marg_med = getCI(margORI_allSubj(:, :, iiLoc, itype, :), 1, 2); % for the convenience of getting the peak
            margPred_med = getCI(margPredORI_allSubj(:, :, iiLoc, itype, :), 1, 2); % for the convenience of getting the peak
            margR2_med = getCI(margR2ORI_allSubj(:, :, iiLoc, itype), 1, 2); % for the convenience of getting the peak
        else
            marg_med = getCI(margSF_allSubj(:, :, iiLoc, itype, :), 1, 2); % for the convenience of getting the peak
            margPred_med = getCI(margPredSF_allSubj(:, :, iiLoc, itype, :), 1, 2); % for the convenience of getting the peak
            margR2_med = getCI(margR2SF_allSubj(:, :, iiLoc, itype), 1, 2); % for the convenience of getting the peak
        end
        
        color = colors2{iiLoc};
        
        [marg_ave, ~, ~, marg_SEM] = getCI(marg_med, 2);
        [margPred_ave, margPred_lb, margPred_ub, ~, ~] = getCI(margPred_med, 2);
        [margR2_ave, ~, ~, margR2_SEM, ~] = getCI(margR2_med, 2);
        
        % get the peak
        [~, maxInd] = max(marg_med, [], 2);
        peak{ifeature}(iiLoc, :) = xaxis(maxInd);
        
        % extra lines
        yline(0, 'handlevisibility', 'off', 'linewidth', 1, 'color', [.7, .7, .7]);
        xline(ifeature-1, 'handlevisibility', 'off', 'linewidth', 1, 'color', [.7, .7, .7]);
        
        % plot raw data
        errorbar(xaxis, marg_ave, marg_SEM, 'color', color, 'CapSize',0, 'linestyle', 'none', 'linewidth', 2)
        plot(xaxis, marg_ave, 'o', 'linestyle', 'none', 'markersize', 1/sqrt(nfilters)*50, 'markerfacecolor', color, 'markeredgecolor','w')
        
        %         for isubj = 1:nsubj
        %             plot(xaxis, marg_med(isubj, :), 'o', 'color', ones(1,3)*.5)
        %             plot(xaxis, margPred_med(isubj, :), '-', 'color', ones(1,3)*.5)
        %             title(margR2_med(isubj))
        %         end
        
%         plot fitting lines

        plot(xaxis, margPred_ave, '-', 'color', color, 'linewidth', 2)
        patch([xaxis, flip(xaxis)], [margPred_lb, flip(margPred_ub)], color, 'FaceAlpha', .3, 'linestyle', 'none')
        
        %  print R2
        text(xaxis(1), ytext_R2_all{ifeature}(iiLoc), sprintf('R^2 = %.2f (   %.2f)', margR2_ave, margR2_SEM), ...
            'color', color, 'fontsize', sz_text)
        
    end % end of iiLoc
    
    % ==================
    % combare two lines
    y = getCI(margORI_allSubj(:, :, :, itype, :), 1, 2, 'tail', 'right');
    for ifilter = 1:nfilters
        [h,p] = ttest2(squeeze(y(:, 1, ifilter)), squeeze(y(:, 2, ifilter)));
        p = p*nfilters;
        if p<.01, plot(xaxis(ifilter), ystars(ifeature), 'k*', 'MarkerSize', sz_stars), end
    end
    % ==================
    
    % xaxis
    xlim(axisLim{ifeature})
    %     xlabel(xlabels_tuning{ifeature}, 'FontSize', sz_label)
    xticks(axisTicks_tuning{ifeature})
    xticklabels(axisTL_tuning{ifeature})
    
    % yaxis
    if ifeature==1
        yticks(-.1:.1: .2)
        ylim([-.12, .22])
    else
        yticks(-.06:.06: .12)
        ylim([-.072, .132])
    end
    
    ax = gca;
    ax.XAxis.FontSize = sz_ticks;
    ax.YAxis.FontSize = sz_ticks;
    ax.LineWidth = wd_border/1.5;
    
    ylabel('Kernel (a.u.)', 'fontsize', sz_label)
    
    saveas(gcf, sprintf('talk2022/fig/RC/marg_%s.jpg', namesFeature{ifeature}))
end % end of ifeature

%% ANOVA2 (29 channel x 2 loc on kernels)

%% plot the peak of the tuning functions
clc
close all

fprintf('========== PEAK ==========\n')
ytext = [8, 8; 1.4, 1.4]; % y of the p sign for each bar
yDiffSEM = [11,11; 1.55, 1.55]; % y of the center of the diff SEM errorbar
ytext_diffSEM = [14,14; 1.7, 1.7]; % y of the p sign for the diff SEM errorbar

figure('Position', [0, 800, 800, 250])
for ifeature = 1:2
    subplot(1,2,ifeature), hold on
    % this part comes first to draw the ref. line at the bottom
    if ifeature== 1, ylim([-20,20]), yline(0, 'k--', 'linewidth', 1); yticks(-20:10:20), ylabel('Orientation peak (deg)')
    else, ylim([0, 2]), yline(1, 'k--', 'linewidth', 1); yticks(0:.5:2), yticklabels(round(2.^(0:.5:2), 2)), ylabel('SF peak (cpd)')
    end
    
    % group average
    for iiLoc = 1:2
        pp = peak{ifeature}(iiLoc, :);
        pp_groupAve = mean(pp);
        pp_groupSEM = std(pp)/sqrt(nsubj);
        errorbar(iiLoc, pp_groupAve, pp_groupSEM, '.', 'color', colors2{iiLoc}, 'CapSize', 0)
        bar(iiLoc, pp_groupAve, 'edgecolor', colors2{iiLoc}, 'facecolor','none')
        
        % compare with the ref
        [~, p, ci, stats] = ttest(pp, ifeature-1)
        ss = getString_starts(p);
        %         ss = sprintf('p = %.3f', round(p,3));
        text(iiLoc, ytext(ifeature, iiLoc), ss, 'HorizontalAlignment', 'center')
        %         fprintf('[%s] %s: t(%d) = %.2f, p = %.3f\n', namesFeature{ifeature}, names2Loc{iiLoc}, stats.df, stats.tstat, p)
    end
    
    [~, p, ci, stats] = ttest(peak{ifeature}(:), ifeature-1);
    fprintf('[%s] both loc: t(%d) = %.2f, p = %.3f\n', namesFeature{ifeature}, stats.df, stats.tstat, p)
    
    %         ss = sprintf('p = %.3f', round(p,3));
    % compare two bins
    bin1 = peak{ifeature}(1, :);
    bin2 = peak{ifeature}(2, :);
    [h,p,ci,stats] = ttest2(bin1, bin2);
    diffSEM = std(bin1 - bin2)/sqrt(nsubj);
    errorbar(1.5, yDiffSEM(ifeature, iiLoc), diffSEM, 'k', 'CapSize', 0)
    plot([1,2], [yDiffSEM(ifeature, iiLoc), yDiffSEM(ifeature, iiLoc)], 'k-')
    ss = getString_starts(p);
    text(1.5, ytext_diffSEM(ifeature, iiLoc), ss, 'HorizontalAlignment', 'center')
    
    % idvd data
    for isubj = 1:nsubj
        plot([1,2], [peak{ifeature}(1,isubj), peak{ifeature}(2,isubj)], '.-', 'color', ones(1,3)*.7, 'linewidth', 2)
    end
    
    xlim([.1, 2.9])
    xticks(1:2)
    %     xticklabels(names2Loc(1:2))
    
end
set(findall(gcf, '-property', 'FontSize'), 'FontSize',18)
set(findall(gcf, '-property', 'LineWidth'), 'LineWidth',2)
saveas(gcf, sprintf('talk2022/fig/RC/KernelPeak.jpg'))

%% estimated params (itype=3, all trials)
close all
clear ydiffErr

wd_border = 1;
RCplot_setting_margParams % define ticks,limits and the loc of texts
sz_marker = 20;
margParams = {margParamsORI_allSubj , margParamsSF_allSubj };

itype = 3; % reemphasize
for ifeature = 1:2
    xaxis = axis_tuning{ifeature};
    nfilters = length(xaxis);
    xaxis_itp = axis_itp_tuning{ifeature};
    ifamily = ifamily_perF(ifeature);
    namesParams = namesParams_all{ifamily};
    nparams_full = length(namesParams);
%     namesParams_unit = nameParams{ifeature};
    
    for iparam = 1:nparams_full
        
        figure('Position', [3e3 200 350 600]);
        pp = margParams{ifeature}(:, :, :, itype, :);
        if (ifeature == 2) && ~isempty((find(iparam == [1, 3]))), pp = log2(pp);end
        
        [params_med, ~, ~, params_neg, params_pos] = getCI(pp, 1, 2); % CI for errorbar in the scatter plot
        [params_ave, ~, ~, params_sem] = getCI(params_med, 2, 1);
        
        %%%%%%%%
        %       bar       %
        %%%%%%%%
        subplot(2,1, 1), hold on, box on
        
        for iiLoc = 1:nLoc2
            %             bar(iiLoc, params_ave(iiLoc, iparam), 'FaceColor', 'w', 'EdgeColor', colors2{iiLoc}, 'BarWidth', .5, 'linewidth', wd_border)
            errorbar(iiLoc, params_ave(iiLoc, iparam), params_sem(iiLoc, iparam), '.', ...
                'color', colors2{iiLoc}, 'CapSize', 0, 'linewidth', 2)
            plot(iiLoc, params_ave(iiLoc, iparam), 'o', 'MarkerFaceColor' , colors2{iiLoc}, ...
                'MarkerEdgeColor', 'w', 'MarkerSize', sz_marker, 'linewidth', 2)
        end % end of iiLoc
        
        % compare and draw sem of diff
        x1 = params_med(:, 1, iparam);
        x2 = params_med(:, 2, iparam);
        diff_sem = std(x1-x2)/sqrt(nsubj);
        [~, p,~, stats] = ttest(x1, x2)
        
        errorbar(1.5, ydiffErr{ifeature}(iparam), diff_sem, 'k', 'CapSize', 0, 'linewidth', wd_border)
        plot([1,2], [ydiffErr{ifeature}(iparam), ydiffErr{ifeature}(iparam)], 'k-', 'linewidth', wd_border)
        string_s = getString_starts(p);
        text(1.5, ydiffErr{ifeature}(iparam)+diff_sem*2, sprintf('p = %.3f', p), 'HorizontalAlignment', 'center', 'fontsize', sz_title)
        
        axis square
        xticks(1:nLoc2)
        xlim([.3, nlines+.7])
        xticklabels(namesLocComb(iLocComb_all)) % do NOT delete the extra curly brackets!!
        yticks(ticks{ifeature, iparam})
        ylabel(sprintf('%s %s', namesFeature{ifeature}, namesParams{iparam}))
        if (ifeature == 2) && ~isempty((find(iparam == [1, 3]))), yticklabels(round(2.^ticks{ifeature, iparam}, 2));end
        ylim(lim{ifeature, iparam})
        
        xlabel('') % to ensure the same shape of the bar plot on the left & the scatter plot on the right
        %%%%%%%%
        %    scatter   %
        %%%%%%%%
        if nlines==2 % 1 = the param is fixed, thus no need to make the scatter plot
            subplot(2,1, 2), hold on, box on
            
            % diagonal line
            plot(lim{ifeature, iparam}, lim{ifeature, iparam}, 'k-', 'linewidth', wd_border)
            
            % IDVD data
            errorbar(params_med(:,1, iparam), params_med(:,2, iparam), ...
                params_neg(:,2, iparam), params_pos(:,2, iparam), ...
                params_neg(:,1, iparam), params_pos(:,1, iparam), ...
                '.', 'color', ones(1,3)*.5, 'CapSize', 0, 'linewidth', wd_border/2)
            for isubj = 1:nsubj
                plot(params_med(isubj,1, iparam), params_med(isubj,2, iparam), markers_allSubj{isubj}, ...
                    'linestyle', 'none', 'MarkerFaceColor', 'w', 'MarkerEdgeColor', ones(1,3)*.5, 'linewidth', 2)
            end
            
            % group ave (purple cross)
            errorbar(params_ave(1, iparam), params_ave(2, iparam), params_sem(1, iparam), 'horizontal', 'color', [1,0,1], 'linewidth', 2, 'CapSize', 0)
            errorbar(params_ave(1, iparam), params_ave(2, iparam), params_sem(2, iparam), 'vertical', 'color', [1,0,1], 'linewidth', 2, 'CapSize', 0)
            
            %
            %             xticks(ticks{ifeature, iparam})
            %             yticks(ticks{ifeature, iparam})
            %             xlim(lim{ifeature, iparam})
            %             ylim(lim{ifeature, iparam})
            
            xticks(ticks{ifeature, iparam})
            yticks(ticks{ifeature, iparam})
            if (ifeature == 2) && ~isempty((find(iparam == [1, 3])))
                xticklabels(round(2.^ticks{ifeature, iparam}, 2));
                yticklabels(round(2.^ticks{ifeature, iparam}, 2));
            end
            
            xlim(lim{ifeature, iparam})
            ylim(lim{ifeature, iparam})
            
            xlabel(namesLocComb{iLocComb_all(1)})
            ylabel(namesLocComb{iLocComb_all(2)})
            axis square
        end % if nlines == 2
        
        set(findall(gcf, '-property', 'FontSize'), 'FontSize',18)
        set(findall(gcf, '-property', 'FontSize'), 'linewidth',2)
        %         sgtitle(sprintf('%s %s', namesFeature{ifeature}, namesParams_unit{iparam}), 'FontSize',20)
        saveas(gcf, sprintf('talk2022/fig/RC/params_%s_p%d.jpg', namesFeature{ifeature}, iparam))
        
    end % end of iparam
end % end of ifeature

%% correlation between params and threshold
close all

itype = 3; % reemphasize
wd_border = 4;
sz_title = 20;
sz_label = 20; %40
sz_ticks = 20; % 30
sz_marker = 10;
zeroMeanCond = 3; % 1. no controlling for 3rd-party vars; 2. reveal the loc effect; 3. reveal the observer effect

xTicks_0 = [.5, -1, 5e2, -.6, 60]; % the starting point of the ticks
xTicks_i = [.6, 1, 1e2, .2, 15]; % the interval of the ticks
xTicks_1 = [1.7, 1, 7e2, -.2, 90]; % the endpoint of the ticks

% y axis (params, better to be copied from RCplot_params_VSS2022)
yTicks_0 = {[.09, 10, -.02], [1.4, .02,  .2,    -.02,  0]}; % the starting point of the ticks
yTicks_i = {[.03,   2,   .01],  [.2,   .02, .03,  .01,     1.5]}; % the interval of the ticks
yTicks_1 = {[.21,   18,  .02],  [2.2, .1,    .32,  .02,    6]}; % the endpoint of the ticks

namesBehav = {'Contrast sensitivity', 'Resp. consistency'}; nBehav = length(namesBehav);
if zeroMeanCond == 3
    text_corr_subjEffect = cell(2, nBehav, 5);
end

% for (partial) corr
indLoc = repmat([1,2], nsubj,1); indLoc = indLoc(:);
indSubj = repmat((1:nsubj)', 1, nLoc2); indSubj = indSubj(:);

for iBehav = 1%:nBehav % 1=cst 2=pA
    for ifeature = 1%:2
        ifamily = ifamily_perF(ifeature);
        namesParams_unit_perF = namesParams_all{ifamily};
        nparams = length(namesParams_unit_perF);
        
        for iparam = 2%:nparams
            % extract IDVD y (params)
            [y_med, ~, ~, y_neg, y_pos] = getCI(margParams{ifeature}(:, :, :, itype, iparam), 1, 2);
            
            figure('Position', [3e3 200 600 500]);
            hold on, box on
            
            % obtain calculate lim and ticks
            %             xLim = getLim(xTicks_0, xTicks_i, xTicks_1, im);
            %             xTicks = getTicks(xTicks_0, xTicks_i, xTicks_1, im);
            %             yLim = getLim(yTicks_0{ifeature}, yTicks_i{ifeature}, yTicks_1{ifeature}, iparam);
            %             yTicks = getTicks(yTicks_0{ifeature}, yTicks_i{ifeature}, yTicks_1{ifeature}, iparam);
            %
            % extract and process data
            % extract IDVD x (CST or pA)
            if iBehav == 1 % cs (1/cst)
                [x_med, ~, ~, x_neg, x_pos] = getCI(1./(cst_allSubj), 1, 2);
            else % pA
                [x_med, ~, ~, x_neg, x_pos] = getCI(metrics_allSubj(:, :,:, 6), 1, 2);
            end
            
            % zero-mean (or not)
            switch zeroMeanCond
                case 1 % do NOT zero-mean
                    x_plot = x_med;
                    y_plot = y_med;
                case 2 % subtract observer mean (to reveal the location effect)
                    x_plot = x_med - mean(x_med, 2);
                    y_plot = y_med - mean(y_med, 2);
                case 3 % subtract loc mean (to reveal the observer effect)
                    x_plot = x_med - mean(x_med, 1);
                    y_plot = y_med - mean(y_med, 1);
                case 4 % subtract both means (not reveal any effect, just to center the center of two datasets at 0)
                    x_plot = x_med - mean(x_med, [1,2]);
                    y_plot = y_med - mean(y_med, [1,2]);
            end
            
            % group ave and sem
            [x_ave, ~, ~, x_sem] = getCI(x_plot, 2, 1);
            [y_ave, ~, ~, y_sem] = getCI(y_plot, 2, 1);
            
            % linear regression
            lm = polyfit(x_plot(:), y_plot(:), 1);
            x_lm2 = linspace(min(x_plot(:)) - std(x_plot(:)), max(x_plot(:)) + std(x_plot(:)), 2);
            yfit = polyval(lm, x_lm2);
            plot(x_lm2, yfit);
            % plot the CI of ln regression
            %             mdl = fitlm(table(x_plot(:), y_plot(:)));
            %             plot(mdl)
            
            %%%%%%%
            %    plot     %
            %%%%%%%
            for iiLoc = 1:nLoc2
  
                % plot idvd data and CI
                errorbar(x_plot(:, iiLoc), y_plot(:, iiLoc), y_neg(:, iiLoc), y_pos(:, iiLoc), x_neg(:, iiLoc), x_pos(:, iiLoc), ...
                    '.', 'color', colors2{iiLoc}, 'CapSize', 0, 'linewidth', wd_border/2)
%                 for isubj = 1:nsubj
%                     plot(x_plot(isubj, iiLoc), y_plot(isubj, iiLoc), markers_allSubj{isubj}, 'MarkerSize', sz_marker, 'MarkerFaceColor', 'w', 'MarkerEdgeColor',  colors2{iiLoc}, 'linewidth', 2)
%                 end
                plot(x_plot(:, iiLoc), y_plot(:, iiLoc), 'o', ...
                    'MarkerSize', sz_marker, 'MarkerFaceColor', 'w', 'MarkerEdgeColor',  colors2{iiLoc}, 'linewidth', 2)
                
                % plot group ave and SEM
                if zeroMeanCond == 3 % reveal observer effect, thus two crosses will overlap at (0,0)
                    color_ = [.75, 0, .75];
                else
                    color_= colors2{iiLoc};
                end
                %                 errorbar(x_ave(iiLoc), y_ave(iiLoc), x_sem(iiLoc), 'horizontal', '.','color',color_, 'CapSize', 0, 'linewidth', 8)
                %                 errorbar(x_ave(iiLoc), y_ave(iiLoc), y_sem(iiLoc), 'vertical', '.','color',color_, 'CapSize', 0, 'linewidth', 8)
            end % end of iLoc
            
            % plot linear regression
            plot(x_lm2, yfit, 'k-', 'handlevisibility', 'off', 'linewidth', 2)
            % extra lines
            if (ifeature == 1) && (iparam == 3), yline(0, 'color', ones(1,3)*.5); end
            
            %             if zeroMeanCond == 1
            %                 xlim(xLim), ylim(yLim)
            %                 xticks(xTicks), if im == 4, xticklabels(round(10.^xTicks * 100)), else, xticklabels(xTicks), end
            %                 yticks(yTicks), yticklabels(yTicks)
            %             end
            ax = gca;
            ax.XAxis.FontSize = sz_ticks;
            ax.YAxis.FontSize = sz_ticks;
            ax.LineWidth = wd_border/1.2;
            
            % label
            %             if zeroMeanCond == 1
            xlabel(sprintf('%s', namesBehav{iBehav}), 'fontsize', sz_label)
            ylabel(sprintf('%s %s', namesFeature{ifeature}, namesParams_unit_perF{iparam}), 'fontsize', sz_label),
            %             else
            %                 xlabel(sprintf('Zero-meaned %s', namesPerf{im}), 'fontsize', sz_label)
            %                 ylabel(sprintf('Zero-meaned %s %s', namesFeature{ifeature}, nameParams_unit_perF{ifeature}{iparam}), 'fontsize', sz_label),
            %             end
            
            % get corr (use the RAW data (x/y_med), not the zero-meaned data (x/y_plot)!!)
            x_corr = x_med(:);
            y_corr = y_med(:);
            
            switch zeroMeanCond
                case 1 % linear regression
                    [r, p] = corr(x_corr, y_corr);
                case 2 % partial correlation - control for subj (to reveal loc effect)
                    [r, p] = partialcorr([x_corr, y_corr], indSubj);
                    r = r(2,1); p = p(2,1);
                case 3 % partial correlation - control for location (to reveal subj effect)
                    [r, p] = partialcorr([x_corr, y_corr], indLoc);
                    r = r(2,1); p = p(2,1);
                case 4 % partial correlation - control for both loc and subj
                    [r, p] = partialcorr([x_corr, y_corr], [indLoc, indSubj]);
                    r = r(2,1); p = p(2,1);
            end
            
            %             ss = getString_starts(p);
            %             text_corr = sprintf('r = %.2f %s', round(r,2), ss);

            text_corr = sprintf('r = %.2f (p = %.3f)\n', round(r,2), round(p,3));
            % two loc
            for iiLoc = 1:nLoc2
                [r, p] = corr(x_med(:, iiLoc), y_med(:, iiLoc));
                text_corr = [text_corr, sprintf('%s: r = %.2f (p = %.3f)\n', namesLocComb{iLocComb_all(iiLoc)}, round(r,2), round(p,3))];
            end
            if zeroMeanCond == 3
                text_corr_subjEffect{ifeature, iBehav, iparam} = text_corr;
            end
            %             title(sprintf('%s\n[%s]', text_corr, text_corr_subjEffect{ifeature, iBehav, iparam}), 'fontsize', sz_title)
            title(text_corr, 'fontsize', sz_title)
            axis square
            saveas(gcf, sprintf('talk2022/fig/RC/corr_%s_%s_p%d_ctrl%d.jpg', namesBehav{iBehav}, namesFeature{ifeature}, iparam, zeroMeanCond>1))
            
        end %  end of iparam
    end % end of ifeature
end % iBehav


