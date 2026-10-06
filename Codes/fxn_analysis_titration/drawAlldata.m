% thresh, thresh_ave, acc_prs, acc_abs, acc_all, RT_prs, RT_abs, RT_all, dprime, criterion

figure('Position',[900 200 1500 1000])
color_r = [1 0 0];     % red
color_b = [0 0 1];     % blue
color_p = [.75 .25 1]; % purple
color_o = [1, .75, 0]; % orange
color_g = [.25 .75, 0]; % green
color_k = [0 0 0];      % black
color_gray = [.5,.5,.5];
polarLoc =  [4,3,2,5,4];

%% =============== threshold ===============
% 1.1. bar plot for threshold
subplot(3,5,1), hold on, grid on
barFaceColors = [color_r; color_b; color_p];
if size(thresh_final_log, 1) == 1, thresh_final_log = thresh_final_log'; end
thresh_log_plot = ([thresh_log(:,1), thresh_log(:,2), thresh_final_log])' ;
thresh_ln = 10.^(thresh_log_plot);
thresh_ln_mean = 10.^(thresh_final_log);

if plotErrorBar
    thresh_log_allSubj_plot = cat(3, thresh1_log_allsubj, thresh2_log_allsubj, thresh_log_mean_allsubj);
    err_thresh_plot = [(err_thresh(:,1))'; (err_thresh(:,2))'; err_thresh_ave] ; % nsubj x nLoc
    minCST = (min(thresh_log_plot(:)) - max(err_thresh_plot(:)));
    maxCST = (max(thresh_log_plot(:)) + max(err_thresh_plot(:)));
else
    thresh_log_allSubj_plot = [];
    err_thresh_plot = nan(3,5);
    minCST = min(thresh_log_plot(:)) - max(std(thresh_log_plot(:)));
    maxCST = max(thresh_log_plot(:)) + max(std(thresh_log_plot(:)));
end

plotBar(thresh_log_allSubj_plot, thresh_log_plot, err_thresh_plot, barFaceColors, locNames)
ylim([minCST, maxCST])
yticks_ln = linspace(10.^(minCST), 10.^(maxCST),3);
yticks(log10(yticks_ln)), yticklabels(round(yticks_ln, 2))

legend('stair#1', 'stair#2', 'ave', 'orientation', 'horizontal', 'Location', 'south')
title('target cst thresh [all trials]')

% 1.2  polar plot for threshold
plotPolar(6, polar_ang, thresh_ln(:, polarLoc)./repmat(thresh_ln(:,1), 1, nLoc), barFaceColors)
title('threshold relative to the center')

% 1.3 HVA and VMA of threshold
plotHVA_VMA(thresh_ln(1,:), thresh_ln(2,:), thresh_ln_mean, 11)

%% =============== accuracy ===============
% 2.1. bar plot acc
subplot(3,5,2), hold on, grid on
barFaceColors = [color_o;color_g;color_k];
acc = [acc_prs; acc_abs; acc_all] *100;
if plotErrorBar
    acc_allSubj_plot = cat(3, acc_prs_allSubj, acc_abs_allSubj, acc_all_allSubj)*100;
    err_acc = [err_acc_prs; err_acc_abs; err_acc_all] * 100;
else
    acc_allSubj_plot = [];
    err_acc = nan(3,5);
end

plotBar(acc_allSubj_plot, acc, err_acc, barFaceColors, locNames)

plot([0 6], ones(1,2)*stairParams.threshPerformance*100, 'color', color_gray,  'LineWidth', 1.5)
ylim([50, 90])
title(sprintf('Accuracy (%%) [last %d%% trials]', ratioSelected*100))

% 2.2. polar plot of acc
plotPolar(7, polar_ang, [acc_prs(polarLoc)/acc_prs(1); acc_abs(polarLoc)/acc_abs(1) ;acc_all(polarLoc)/acc_all(1)], barFaceColors)
title('accuracy relative to the center')

% 2.3 HVA and VMA of acc
plotHVA_VMA(acc_prs, acc_abs, acc_all, 12)

%% =============== RT ===============
% 3.1, bar plot for RT
subplot(3,5,3); hold on, grid on
barFaceColors = [color_o; color_g; color_k];
RT = [RT_prs; RT_abs; RT_all];
if plotErrorBar
    err_RT= [err_RT_prs; err_RT_abs; err_RT_all];
    minRT = min(RT(:)) - max(err_RT(:));
    maxRT = max(RT(:)) + max(err_RT(:));
else
    err_RT = nan(3,5);
    minRT = min(RT(:)) - std(RT(:));
    maxRT = max(RT(:)) + std(RT(:));
end

plotBar([], RT, err_RT, barFaceColors, locNames)
ylim([minRT, maxRT])
legend('tgt-prs', 'tgt-abs', 'all trials', 'orientation', 'horizontal', 'Location', 'south')
title('RT (sec) [all trials]')

% 2.3. polar plot of RT
plotPolar(8, polar_ang, [RT_prs(polarLoc)/RT_prs(1); RT_abs(polarLoc)/RT_abs(1); RT_all(polarLoc)/RT_all(1)], barFaceColors)
title('RT relative to the center')

% 3.3 HVA and VMA of RT
plotHVA_VMA(RT_prs, RT_abs, RT_all, 13)

%% =============== dprime ===============
% 4.1 bar plot of dprime
subplot(3,5,4); hold on, grid on
bar(1:5, dprime);
if plotErrorBar, errorbar(1:5, dprime, err_dprime, 'k', 'LineStyle', 'none', 'handlevisibility', 'off'), end
% plot([0, 6], [dprime_theo, dprime_theo], 'color',[.5 .5 .5], 'LineWidth', 1.5)
yline(dprime_theo);
xticks(1:5), xticklabels(locNames), xtickangle(45)
ylim(dprime_theo +[-.3, .3])
yticklabels_ = (round(dprime_theo,1) - .3: .1:round(dprime_theo,1) +.3);
yticks(yticklabels_), yticklabels(yticklabels_)
title(sprintf('dprime [last %d%% trials]', ratioSelected*100))

% 4.2 polar plot of dprime
plotPolar(9, polar_ang, dprime(polarLoc)/dprime(1), 'b')
title('dprime relative to the center')

% 4.3 HVA and VMA of dprime
plotHVA_VMA(nan(1,nLoc), nan(1,nLoc), dprime, 14)

%% =============== criterion ===============
% 5.1 bar plot of criterion
subplot(3,5,5); hold on, grid on
bar(1:5, criterion);
if plotErrorBar, errorbar(1:5, criterion, err_criterion, 'k', 'LineStyle', 'none', 'handlevisibility', 'off'), end
xticks(1:5), xticklabels(locNames), xtickangle(45)
xlim([0 6]), ylim([-1, 1])
title(sprintf('criterion [last %d%% trials]', ratioSelected*100))

% 5.2 polar plot of criterion (unnecessary, as some criterion are negative and some and postive)
% plotPolar(10, polar_ang, criterion(polarLoc)/criterion(1), 'b')
% title('criterion relative to the center')



