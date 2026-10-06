

SX_RC1_setting
subjList = {'YK', 'SP', 'SX', 'LS', 'RE', 'MD', 'AS', 'HL', 'FH', 'HA', 'CS', 'DT'};
nblocks_allSubj = [200, 240, 210, 240, 220, 220, 215, 220, 205, 210, 205, 205];
eyeD_all = [1,1,0,1,1,1,1,1,0,0,1,0]; % 1=right eye dominant; 0=left eye dominant

indSubj = [1:10, 12]; % no CS
% indSubj = 1:12;
nsubj = length(indSubj);
subjList = subjList(indSubj);
nblocks_allSubj = nblocks_allSubj(indSubj);
markers_allSubj = markers_allSubj(indSubj);
eyeD_all = eyeD_all(indSubj);

%% prepare
nLoc = 2;
namesLocComb_ = namesLocComb(iLocComb_all);
colors_comb_ = colors_comb(iLocComb_all, :);

metrics_allSubj_ = metrics_allSubj(indSubj, :, :, :);
cs_allSubj_ = 1./cst_allSubj(indSubj, :, :);
RT_allSubj_ = RT_allSubj(indSubj, :, :);
pYES_tgt_allSubj_ = pYES_tgt_allSubj(indSubj,:, :, :, :);
ebin_tgt_allSubj_ = ebin_tgt_allSubj(indSubj,:, :, :, :);
sep_allSubj_ = sep_allSubj(indSubj, :, :, :);
e2D_med_allSubj = getCI(kernels2D_allSubj(indSubj, :, :, :, :, :), 1, 2); % med kernel of each subj (to conduct t-test on FP diff)

% marg & pred & R2
margORI_allSubj_ = margORI_allSubj(indSubj, :, :, :, :);
margPredORI_allSubj_ = margPredORI_allSubj(indSubj, :, :, :, :);
margR2ORI_allSubj_ = margR2ORI_allSubj(indSubj, :, :, :);
margSF_allSubj_ = margSF_allSubj(indSubj, :, :, :, :);
margPredSF_allSubj_ = margPredSF_allSubj(indSubj, :, :, :, :);
margR2SF_allSubj_ = margR2SF_allSubj(indSubj, :, :, :);
% estimated params
estP_ORI_allSubj = margParamsORI_allSubj(indSubj, :, :, :, :);
estP_SF_allSubj = margParamsSF_allSubj(indSubj, :, :, :, :);
% tuning characteristics
tuningC_ORI_allSubj = margParams2ORI_allSubj(indSubj, :, :, :, :);
tuningC_SF_allSubj = margParams2SF_allSubj(indSubj, :, :, :, :);


% for itype = 1:3% 1=PRS; 2=ABS; 3=BOTH
itype = 3;

%% 1. plot behav measurements
namesMetrics_plus2 = [namesMetrics, 'CS', 'RT'];
yline_all = {dprime_theo, 0, threshPerf, nan, nan, nan, nan, nan, nan, nan};
ticks_scatter_all = {0:.5:2, -1:1:1, .5:.2:1, .6:.15:9, 0:.5:1, .5:.25:1, .5:.25:1, .5:.25:1, 2:4, -3:-1};
lim_scatter_all = {[0, 2], [-1.2, 1.2],  [.5, 1], [.57, .93], [-.1, 1.1], [.5, 1], [.5, 1], [.5, 1], [1.8, 4.2], [-3.2,-.8]};

iLocComb_all_ = iLocComb_all;
plot1_behavMeas


%% check if dprime, pC, criterion deviates from the reference
theo = [dprime_theo, 0, .7];
for im = [1,2,3]
    mm_med= getCI(metrics_allSubj_(:, :, :, im), 1, 2);
    mm_med = mm_med(:);
    [~, p, ~, stats] = ttest(mm_med, theo(im));
    fprintf('%s: t(%d) = %.3f, p=%.3f\n', namesMetrics{im}, stats.df, stats.tstat,p)
end

%% compute the cst change across all blocks
% clc
% subjList = {'YK', 'SP', 'SX', 'LS', 'RE', 'MD', 'AS', 'HL', 'FH', 'HA', 'CS','DT'};
% nblocks_allSubj = [200, 240, 210, 240, 220, 220, 215, 220, 205, 210, 205, 205];
% nsubj = length(subjList);
%
% deviance_allSubj = nan(nsubj, 5);
% for isubj = 1:nsubj
%     subjName = subjList{isubj};
%     nblocks = nblocks_allSubj(isubj);
%     nameBehavMeas = sprintf('Data_OOD/%s%d/%s_behavMeas.mat', subjName, nblocks, subjName);
%
%     fprintf('%s...', subjName)
%     load(nameBehavMeas)
%     fprintf(' loaded\n')
%     for iLoc = 1:5
%         cst_unik = log10(unique(dataMatrix(dataMatrix(:, 5) == iLoc, 11)));
%         deviance = cst_unik/median(cst_unik) - 1;
%
%         fprintf('%s: dev mean = %.4f, std = %.4f\n', namesLocComb{iLoc}, mean(deviance)*100, std(deviance)*100)
%
%         deviance_allSubj(isubj, iLoc) = mean(mean(deviance))*100;
%     end
%     clear dataMatrix
% end
%
% clc
% for iLoc = 1:5
%     fprintf('%s: %.2f%% (%.2f%%), ', namesLocComb{iLoc}, mean(deviance_allSubj(:, iLoc)), std(deviance_allSubj(:, iLoc)))
% end

%% 2. pYES vs. binned energy
plot2_ebins

%% 3. 2D kernels
pCriterion = .001;
kernelLim = {[-.06, .6], [-.05, .25], [-.05, .25]};
[e2D_ave, ~, ~, e2D_sd] = getCI(e2D_med_allSubj(:, :, itype, :, :), 2, 1);

clc, fprintf('2 loc: MIN is %.2f, MAX is %.2f\n', min(e2D_ave(:)), max(e2D_ave(:)))
% Loc 1
figure('Position', [0 0 4e2 4e2])
RCplot_2Dkernel(squeeze(e2D_ave(1, :, :))', kernelLim{itype})
set(findall(gcf, '-property', 'FontSize'), 'FontSize',18)
title(namesLocComb{iLocComb_all(1)}, 'FontSize',20)
saveas(gcf, sprintf('VSS2023/fig/RC/kernels2D/n%d_L%d_%s.jpg', nsubj, iLocComb_all(1), namesType{itype}))

% Loc 2
figure('Position', [0 0 4e2 4e2])
RCplot_2Dkernel(squeeze(e2D_ave(2, :, :))', kernelLim{itype})
set(findall(gcf, '-property', 'FontSize'), 'FontSize',18)
title(namesLocComb{iLocComb_all(2)}, 'FontSize',20)
saveas(gcf, sprintf('VSS2023/fig/RC/kernels2D/n%d_L%d_%s.jpg', nsubj, iLocComb_all(2), namesType{itype}))

% Diff
figure('Position', [0 0 4e2 4e2])
% diff = squeeze(e2D_med_allSubj(:, 1, :, :) - e2D_med_allSubj(:, 2, :, :));
diff_ave = squeeze(e2D_ave(1, :, :) - e2D_ave(2, :, :));
fprintf('DIFF: MIN is %.2f, MAX is %.2f\n', min(diff_ave(:)), max(diff_ave(:)))
RCplot_2Dkernel(diff_ave', [-.05, .1])
set(findall(gcf, '-property', 'FontSize'), 'FontSize',18)
title(sprintf('%s minus %s', namesLocComb{iLocComb_all(1)}, namesLocComb{iLocComb_all(2)}), 'FontSize',20)
saveas(gcf, sprintf('VSS2023/fig/RC/kernels2D/n%d_L%d%d_diff_%s.jpg', nsubj, iLocComb_all(1), iLocComb_all(2), namesType{itype}))

%% 4. separability
plot4_sep

%% 5. marginalized kernels per combined loc (compare two loci)
xTLs = namesLocComb_;
title_ = sprintf('L%d%d', iLocComb_all);

for itype=3%1:3
    plot5_marg
end

%% 6. params (all trials)
close all
clc
for paramMode=1:2
    if paramMode == 1
        % estimated parameters
        params_allSubj = {estP_ORI_allSubj, estP_SF_allSubj}; title_ = 'estP';
        namesParams = {'peak SF','gain','sigma','baseline','truncation'};
    else
        % tuning characteristics
        params_allSubj = {tuningC_ORI_allSubj, tuningC_SF_allSubj}; title_ = 'tunC';
        namesParams = {'peak SF','peak','width','baseline','truncation'};
    end
    xTLs = namesLocComb(iLocComb_all);
    plot6_params
end

%% 7. correlation between params and threshold
for paramMode = 1%1:2
    if paramMode==1
        % estimated parameters
        params_allSubj = {estP_ORI_allSubj, estP_SF_allSubj}; title_ = 'estP';
        namesParams = {'peak SF','gain','sigma','baseline','truncation'};
    else
        % tuning characteristics
        params_allSubj = {tuningC_ORI_allSubj, tuningC_SF_allSubj}; title_ = 'tunC';
        namesParams = {'peak SF','peak','width','baseline','truncation'};
    end
    
    for itype=3
        plot8_corr
        close all
    end
end


fprintf('\nALL DONE\n')

