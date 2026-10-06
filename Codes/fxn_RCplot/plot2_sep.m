
colors = colors_perBinPerComb(:, iLocComb_all);
x_ticks = namesLocComb(iLocComb_all);
sz_fig = [350 350]; % size of the figure canvas

% get median of each observer
data_allSubj = sep_allSubj(:, :, :, :, itype); % nsubj x nB x nLoc2 x ntypes x nTunC
med_allSubj = getCI(data_allSubj, 1, 2);

% get ytick labels and ref
y_ticklabels = '';
ref = nan;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%=== CI of t-test ===
% have not decided what test to do
%         for iB = 1:nB
%             x=squeeze(data_allSubj(:, :, iB, :));[~, p, ~, stats] = ttest(x(:, 1), x(:, 2));cohenD = fxn_getES(x(:, 1), x(:, 2));
%             p_allB(iB) = p; t_allB(iB) = stats.tstat; cohenD_allB(iB) = cohenD;
%         end
%         [p_med, p_lb, p_ub] = getCI(p_allB, 1, 2);
%         [t_med, t_lb, t_ub] = getCI(t_allB, 1, 2);
%         [d_med, d_lb, d_ub] = getCI(cohenD_allB, 1, 2);
%         title_CI = sprintf('t=%.3f [%.3f, %.3f], p=%.3f [%.3f, %.3f], d=%.3f [%.3f, %.3f]', t_med, t_lb, t_ub, p_med, p_lb, p_ub, d_med, d_lb, d_ub);
%===============
%         text_title = sprintf('%s\n%s', text_title, title_CI);
text_title = sprintf('Separability - n%d %s L%d%d ', nsubj, binStrategy, iLocComb_all);
basicFxn_drawBars2(squeeze(med_allSubj(:, indBins, :)), ref, colors, linspace(.4, 1, 5), y_ticklabels, flag_plotIDVD, text_title, sz_fig, markers_allSubj);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% save
saveas(gcf, sprintf('%s/n%d_L%d%d_nBins%d.jpg', nameFigFolder_RC_sep, nsubj, iLocComb_all, length(indBins)))

