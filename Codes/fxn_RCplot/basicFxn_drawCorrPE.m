function  basicFxn_drawCorrPE(x_med_allSubj, y_med_allSubj, colors, x_ticks, y_ticks, x_ticklabels, y_ticklabels, flag_zeroMean, type_tail, text_title, markers_allSubj)

% flag_sig = basicFxn_drawCorr(x_med_allSubj, y_med_allSubj, colors, x_ticks, y_ticks, x_ticklabels, y_ticklabels, flag_zeroMean, type_corr, type_tail, text_title, markers_allSubj)
% to plot and compare two values across locations for (1) performance and (2) tuning characteristics
% and assess partial correlation while controlling for location
% Inputs:
%    x_med_allSubj: nsubj x nLoc, median of boostrapping, to plot on the x-axis
%    y_med_allSubj: nsubj x nLoc, median of boostrapping, to plot on the y-axis
%    colors: nLoc x 3, each rows indicates a location
%    x_ticks: vector, containing 5 values
%    y_ticks: vector, containing 5 values
%    x_ticklabels: vector, containing 5 values
%    y_ticklabels: vector, containing 5 values
%    flag_zeroMean: 1=subtract mean; 0=NOT
%    typeCorr: string, 'pearson'=Pearson's r; 'spearman'=spearman's rho, 'kendall'=Kendall's tau
%    type_tail: 'both' (two tail), 'left', 'right'
%    text_title
%    markers_allSubj

%% figure setting
wd_border = 2; % 2
sz_ticks = 30/2; % 30
sz_marker = 20/2; % 20
sz_title = 12; % 15
nMarkerMax = 11;

%% extract nsubj and nLoc and make assertion
[nsubj, nLoc] = size(x_med_allSubj);
assert(length(markers_allSubj) >= nsubj)

%% zero-mean
switch flag_zeroMean
    case 0 % no zero-mean
        x_med_0mean_allSubj = x_med_allSubj;
        y_med_0mean_allSubj = y_med_allSubj;
    case 1 % control for VAR 1 (control for dim2 effect), could be loc
        x_med_0mean_allSubj = x_med_allSubj - mean(x_med_allSubj, 1);
        y_med_0mean_allSubj = y_med_allSubj - mean(y_med_allSubj, 1);
    case 2 % control for VAR 2 (control for dim1 effect), could be subj
        x_med_0mean_allSubj = x_med_allSubj - mean(x_med_allSubj, 2);
        y_med_0mean_allSubj = y_med_allSubj - mean(y_med_allSubj, 2);
end

%%
% figure('Position', [0 200 1e3 1e3]);
figure('Position', [0 200 400 400]);
hold on, box on

%% idvd data
for iLoc = 1:nLoc
    for isubj = 1:nsubj
        if isubj<=nMarkerMax, faceColor = colors{iLoc}; else, faceColor = 'w'; end
        edgeColor = colors{iLoc};
        plot(x_med_0mean_allSubj(isubj, iLoc), y_med_0mean_allSubj(isubj, iLoc),  markers_allSubj{isubj}, ...
            'markerfacecolor', faceColor, 'markeredgecolor', edgeColor, ...
            'markersize', sz_marker, 'linewidth', wd_border)
    end % isubj
end % iLoc

%% group average
if flag_zeroMean==0 % otherwise averages will be [0,0]
    [x_aveSubj, ~, ~, x_semSubj] = getCI(x_med_0mean_allSubj, 2, 1);
    [y_aveSubj, ~, ~, y_semSubj] = getCI(y_med_0mean_allSubj, 2, 1);
    for iLoc = 1:nLoc
        errorbar(x_aveSubj(iLoc), y_aveSubj(iLoc), x_semSubj(iLoc), 'horizontal', 'color', colors{iLoc}, 'linewidth', wd_border*2, 'capsize', 0)
        errorbar(x_aveSubj(iLoc), y_aveSubj(iLoc), y_semSubj(iLoc), 'vertical', 'color', colors{iLoc}, 'linewidth', wd_border*2, 'capsize', 0)
    end % iLoc
end

%% get (partial) corr
ANOVA_indLoc = repmat(1:nLoc, nsubj, 1);
ANOVA_indSubj = repmat((1:nsubj)', 1, nLoc);
switch flag_zeroMean
    case 0 % no controlling
        [r, p_pearson] = corr(x_med_allSubj(:), y_med_allSubj(:), 'type', 'pearson', 'tail', type_tail);
        [tau, p_kendall] = corr(x_med_allSubj(:), y_med_allSubj(:), 'type', 'kendall', 'tail', type_tail);
        
    case 1 % controll for location effect, reveal subject effect
        [r, p_pearson] = partialcorr(x_med_allSubj(:), y_med_allSubj(:), ANOVA_indLoc(:), 'type', 'pearson', 'tail', type_tail);
        [tau, p_kendall] = partial_corr_kendall(x_med_allSubj(:), y_med_allSubj(:), ANOVA_indLoc(:), type_tail);
        
    case 2 % controll for subj effect,  reveal loc effect
        [r, p_pearson] = partialcorr(x_med_allSubj(:), y_med_allSubj(:), ANOVA_indSubj(:), 'type', 'pearson', 'tail', type_tail);
        [tau, p_kendall] = partial_corr_kendall(x_med_allSubj(:), y_med_allSubj(:), ANOVA_indSubj(:), type_tail);
end

%% linear regression for all loc
lm = polyfit(x_med_0mean_allSubj(:), y_med_0mean_allSubj(:), 1);
x_lm2 = linspace(min(x_med_0mean_allSubj(:)), max(x_med_0mean_allSubj(:)), 2);
yfit = polyval(lm, x_lm2);
eta2 = var(polyval(lm, x_med_0mean_allSubj(:)))/var(y_med_0mean_allSubj(:));
if min([p_pearson, p_kendall]) <.05, plot(x_lm2, yfit,'-', 'color', ones(1,3)*.4, 'handlevisibility', 'off', 'linewidth', wd_border * 2);
elseif min([p_pearson, p_kendall])<.1, plot(x_lm2, yfit,'--', 'color', ones(1,3)*.4, 'handlevisibility', 'off', 'linewidth', wd_border * 2);
end

%% corr and linear regression for each loc
text_corr_perL = [];
for iLoc = 1:nLoc
    [r, p_pearson_perL] = corr(x_med_allSubj(:, iLoc), y_med_allSubj(:, iLoc), 'type', 'pearson');
    [tau, p_kendall_perL] = corr(x_med_allSubj(:, iLoc), y_med_allSubj(:, iLoc), 'type', 'kendall');
    text_corr_perL = [text_corr_perL, sprintf('L%d: r=%.2f, p=%.3f // tau=%.2f, p=%.3f\n', iLoc, r, p_pearson_perL, tau, p_kendall_perL)];
    
    lm = polyfit(x_med_0mean_allSubj(:, iLoc), y_med_0mean_allSubj(:, iLoc), 1);
    x_lm2 = linspace(min(x_med_0mean_allSubj(:, iLoc)), max(x_med_0mean_allSubj(:, iLoc)), 2);
    yfit = polyval(lm, x_lm2);
    eta2 = var(polyval(lm, x_med_0mean_allSubj(:, iLoc)))/var(y_med_0mean_allSubj(:, iLoc));
    if min([p_pearson_perL, p_kendall_perL])<.05, plot(x_lm2, yfit,'-', 'color', colors{iLoc}, 'handlevisibility', 'off', 'linewidth', wd_border);
    elseif min([p_pearson_perL, p_kendall_perL])<.1, plot(x_lm2, yfit,'--', 'color', colors{iLoc}, 'handlevisibility', 'off', 'linewidth', wd_border);
    end
end

%% ticks and limits
if ~isnan(x_ticks), xticks(x_ticks), xlim(x_ticks([1, end])), end
if ~isnan(y_ticks), yticks(y_ticks), ylim(y_ticks([1, end])), end
if ~isnan(x_ticklabels), xticks(x_ticklabels),  end
if ~isnan(y_ticklabels), yticks(y_ticklabels),  end

%% figure format
axis square
ax = gca;
ax.XAxis.FontSize = sz_ticks;
ax.YAxis.FontSize = sz_ticks;
ax.LineWidth = wd_border;

%% title
title(sprintf('%s\nr = %.2f (p = %.3f) // tau = %.2f (p = %.3f) // eta^2=%.2f\n%s', ...
    text_title, r, p_pearson, tau, p_kendall, eta2, text_corr_perL), 'fontsize', sz_title)


