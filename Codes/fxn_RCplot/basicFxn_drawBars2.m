
function basicFxn_drawBars2(med_allSubj, ref, colors, y_ticks, y_ticklabels, flag_plotIDVD, text_title, sz_fig, markers_allSubj)

% compare to basicFxn_drawBars, this fxn draws all bins (grouped together) and all loc

% Inputs:
%    med_allSubj: nsubj x nBars, median of boostrapping
%    ref: one reference line, ylines
%    colors: nBars x 3, each rows indicates a bar
%    x_ticks: cell, containing strings indicating location names
%    y_ticks: vector, containing 3 values
%    y_ticklabels: vector, containing 3 value
%    flag_plotIdvd: 1=plot idvd data; 0=NOT
%    flag_plotDiff: ~isnan=plot SEM of difference
%    text_title: string
%    flag_pairwiseComp: 1=print pairwise comparison in the title
%    sz_fig

%% define sizes
gap = 1; % the size of gap between groups of bars
sz_marker_idvd = 8;
% sz_marker_ave = 30;
fsz_ticks = 15; % tunC: 30, MC: 20; BEHAV: 15; NOM: 20
fsz_title = 10; % font size of titlte
wd = 2; % line width of axis
wd_bar = .8; % the width of the bar (not the bar edge!!)
wd_ref = wd; % line width of the reference line
% interval_diffBar = 8; % higher, closer the comparison bar is to the top of the figure
nsubj_max = 11;
% fprintf('\n\n *** %s ***\n', text_title)

%% extract nsubj and nBars and make assertion
[nsubj, nBars, nGroups] = size(med_allSubj);
% assert(length(x_ticks) == nBars)

%% get ave/SEM
if nsubj>100
    [ave, ~, ~, sem] = getCI(med_allSubj, 1, 1);
else
    [ave, ~, ~, sem] = getCI(med_allSubj, 2, 1);
end

figure('Position', [0, 200, sz_fig])
hold on

%% plot group of bars and errorbars

for iGroup=1:nGroups
    % ===== AVE data =====
    x_start = 1+(iGroup-1)*nBars + (iGroup-1) * gap;
    x_end = x_start+nBars-1;
    x_all = x_start:x_end;
    for iBar = 1:nBars
        
        x = x_all(iBar);
        bar(x, ave(iBar, iGroup), 'FaceColor', colors{iBar, iGroup},  'EdgeColor', colors{iBar, iGroup}, 'barwidth', wd_bar, 'HandleVisibility', 'off')
        errorbar(x, ave(iBar, iGroup), sem(iBar, iGroup), '.', 'color', colors{iBar, iGroup}, 'CapSize', 0, 'linewidth', wd, 'HandleVisibility', 'off')
        
        if ave(iBar)>0
            errorbar(x, ave(iBar, iGroup), sem(iBar, iGroup), 0, '.w', 'CapSize', 0, 'linewidth', wd, 'HandleVisibility', 'off')
        else
            errorbar(x, ave(iBar, iGroup), 0, sem(iBar, iGroup), '.w', 'CapSize', 0, 'linewidth', wd, 'HandleVisibility', 'off')
        end
    end % end of iBar
    
    % ===== IDVD data =====
    if flag_plotIDVD
        
        for isubj = 1:nsubj
            if isubj<=nsubj_max, facecolor='w'; else, facecolor='k'; end
            plot(x_all, med_allSubj(isubj, :, iGroup), ['-', markers_allSubj{isubj}],  ...
                'color',ones(1,3)*.7, 'markerfacecolor', facecolor, 'markeredgecolor', ones(1,3)*.7, ...
                'markersize', sz_marker_idvd, 'linewidth', wd/2)
        end % isubj
    end
    
end % iGroup

%% draw regression line
title_regress='';
for iGroup=1:nGroups
    x_start = 1+(iGroup-1)*nBars + (iGroup-1) * gap;
    x_end = x_start+nBars-1;
    x_all = x_start:x_end;
    
    slope_allSubj = nan(nsubj, 1);
    yfit_allSubj = nan(nsubj, nBars);
    for isubj=1:nsubj
        lm = polyfit(x_all, med_allSubj(isubj, :, iGroup), 1);
        yfit_allSubj(isubj, :) = polyval(lm, x_all);
        slope_allSubj(isubj) = lm(1);
    end
    
    % plot regression line and errorbars (1SEM)
    [yfit_ave, yfit_lb, yfit_ub] = getCI(yfit_allSubj, 2, 1);
    plot(x_all, yfit_ave,'-', 'color', colors{end, iGroup}, 'handlevisibility', 'off', 'linewidth', wd);
    patch([x_all, flip(x_all)], [yfit_lb, flip(yfit_ub)], colors{end, iGroup}, 'FaceAlpha', .2, 'linestyle', 'none')
    
    % compare slope to 0
    [~, p, ~, stats]= ttest(slope_allSubj);
    title_regress = sprintf('%s / L%d: t=%.2f, p=%.3f', title_regress, iGroup, stats.tstat, p);
end % iGroup


%% draw ref
if ~isnan(ref)
    if length(ref)>1; error('ALERT: there are more than one REF!!!'), end
    yline(ref, 'color', ones(1,3)/2, 'linewidth', wd_ref, 'HandleVisibility', 'off');
end

%% conduct ANOVA (regardless of nBars)
indBar = nan(size(med_allSubj));
indGroup = indBar;
for iBar=1:nBars
    for iGroup=1:nGroups
        indBar(:, iBar, iGroup) = iBar;
        indGroup(:, iBar, iGroup) = iGroup;
    end
end
text_ANOVA = print_nANOVA({'Bin', 'Loc'}, med_allSubj(:), {indBar(:), indGroup(:)}, nsubj, 1);

%% ticks, limits and labels
if ~isnan(y_ticks), yticks(y_ticks), ylim(y_ticks([1, end])), end
if ~isnan(y_ticklabels), yticklabels(y_ticklabels), end
xticks(1:nBars), xticklabels([]) % manually add tick labels /symbols on the slide
% if ~isnan(x_label), xlabel(x_label), end
% if ~isnan(y_label), ylabel(y_label), end

% if plot idvd data, leave more space for the middle
% if flag_plotIDVD, buffer = .6; else, buffer = .5; end
xlim([1-gap, x_end+gap])

%% size
ax = gca;
ax.XAxis.FontSize = fsz_ticks;
ax.YAxis.FontSize = fsz_ticks;
ax.LineWidth = wd;

%% title
title(sprintf('%s\n%s%s\n%s', text_title, text_ANOVA, title_regress), 'fontsize', fsz_title)


