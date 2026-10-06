

load(sprintf('Data/colors_n%d.mat', nsubj))
% 11 dim of data_allSubj:
% thresh_log1
% thresh_log2
% thresh_log_mean
% acc_prs', acc_abs'
% acc_all'
% RT_prs'
% RT_abs'
% RT_all'
% dprime'
% criterion'

% get mean
mean_allSubj = mean(data_allSubj, 3);
thresh_log = mean_allSubj(:,1:2);        % two staircases, nLoc x 2
thresh_log_mean = mean(thresh_final_log_allSubj); % average of two staircases, nLoc x 1
thresh_final_log = mean(thresh_final_allSubj);
acc_prs = (mean_allSubj(:,4))';
acc_abs = (mean_allSubj(:,5))';
acc_all = (mean_allSubj(:,6))';
RT_prs = (mean_allSubj(:,7))';
RT_abs = (mean_allSubj(:,8))';
RT_all = (mean_allSubj(:,9))';
dprime = (mean_allSubj(:,10))';
criterion = (mean_allSubj(:,11))';

% get SEM
err_allSubj = std(data_allSubj, [], 3)/sqrt(nsubj);
err_thresh = err_allSubj(:,1:2);
err_thresh_ave = std(thresh_final_allSubj, [], 1)/sqrt(nsubj);
err_acc_prs = (err_allSubj(:,4))';
err_acc_abs = (err_allSubj(:,5))';
err_acc_all = (err_allSubj(:,6))';
err_RT_prs = (err_allSubj(:,7))';
err_RT_abs = (err_allSubj(:,8))';
err_RT_all = (err_allSubj(:,9))';
err_dprime = (err_allSubj(:,10))';
err_criterion = (err_allSubj(:,11))';

% get idvd data
thresh1_log_allsubj = squeeze(data_allSubj(:, 1, :));
thresh2_log_allsubj = squeeze(data_allSubj(:, 2, :));
thresh_log_mean_allsubj = thresh_final_allSubj'; % nLoc x nsubj
acc_prs_allSubj = squeeze(data_allSubj(:, 4, :));
acc_abs_allSubj = squeeze(data_allSubj(:, 5, :));
acc_all_allSubj = squeeze(data_allSubj(:, 6, :));
RT_prs_allSubj = squeeze(data_allSubj(:, 7, :));
RT_abs_allSubj = squeeze(data_allSubj(:, 8, :));
RT_all_allSubj = squeeze(data_allSubj(:, 9, :));
dprime_allSubj = squeeze(data_allSubj(:, 10, :));
criterion_allSubj = squeeze(data_allSubj(:, 11, :));

%% Figure 1: thresh, pC, SDT
plotErrorBar = 1;
drawAlldata
set(findall(gcf, '-property', 'FontSize'), 'FontSize',12)
sgtitle(sprintf('n=%d', nsubj), 'FontSize',25);

%% Figure 2: scatter plot for HVA and VMA (threshold)
left_log = thresh_final_allSubj(:,2);
right_log = thresh_final_allSubj(:,4);
UVM_log = thresh_final_allSubj(:,3);
LVM_log = thresh_final_allSubj(:,5);

% right_log = squeeze(data_allSubj(4,3,:));
% UVM_log = squeeze(data_allSubj(3,3,:));
% LVM_log = squeeze(data_allSubj(5,3,:));
HM_log = mean([left_log,right_log],2);
VM_log = mean([UVM_log,LVM_log],2);

figure('Position', [0 200 1000 400])
xlabels = {'Left', 'VM', 'UVM'};
ylabels = {'Right', 'HM', 'LVM'};
titles = {'LR diff', 'HVA', 'VMA'};


for n = 1:3 % 3 comparisons: LR. HVA, VMA
    switch n
        case 1, x = left_log; y = right_log; 
        case 2, x = VM_log; y = HM_log; 
        case 3, x = UVM_log; y = LVM_log;
    end
    x_mean = mean(x); y_mean = mean(y);
%     axismin = min([x;y]) - std([x;y]);
%     axismax = max([x;y]) + std([x;y]);
        axismin = .2;
    axismax = .7;
    
    subplot(1,3,n), hold on
    for isubj = 1:nsubj
        plot(x(isubj), y(isubj), 'o', 'MarkerFaceColor', colors(:, isubj), 'MarkerEdgeColor', 'w', 'MarkerSize', 10)
%         text(x(isubj)+.03, y(isubj), ['S', num2str(isubj)])
    end
    
    plot([axismin, axismax], [axismin, axismax], '-', 'Color', color_gray)
    plot(mean(x), mean(y), 'k.')
    errorbar(x_mean, y_mean, std(x)/sqrt(nsubj), 'horizontal', 'k')
    errorbar(x_mean, y_mean, std(y)/sqrt(nsubj), 'vertical', 'k')
    
    xlabel(xlabels{n}), ylabel(ylabels{n})

    xlim([axismin, axismax]), ylim([axismin, axismax])
    xticks(axismin:.1:axismax)
    yticks(axismin:.1:axismax)
    xticklabels(axismin:.1:axismax)
    xticklabels(axismin:.1:axismax)
%     axisTicks = linspace(axismin, axismax, 4);
%     axisTickLabels = 10.^(axisTicks);
%     xticks(axisTicks), xticklabels(round(axisTickLabels,2))
%     yticks(axisTicks), yticklabels(round(axisTickLabels,2))
    axis square
    title(titles{n})
    box on
    if n==1, legend(subjList), end
end

set(findall(gcf, '-property', 'FontSize'), 'FontSize',15)
set(findall(gcf, '-property', 'LineWidth'), 'LineWidth',1.2)
sgtitle(sprintf('PF for contrast threshold (n=%d)', nsubj), 'fontsize', 20)

