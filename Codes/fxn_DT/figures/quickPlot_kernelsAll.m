%% Plot 2D Sensitivity Map
for ibin = 1:nBins
	for ilocs = 1:5
		figure, hold on
		for isubj = 1:nsubjs
			subplot(4,3,isubj), hold on, axis square
			a = squeeze(kernels2D_all(isubj,1,ilocs,ibin,itypes,:,:));
			a([1:5 38:43], :) = nan;
			a(:, [1:6 31:35]) = nan;
			imagesc(a), colorbar()
			%xticks(linspace(1,31,3)), yticks(linspace(1,24,3))
			%yticklabels([3 23 43]), xticklabels([7 17 27])
			%xlim([0 44]), ylim([0 44])
			title(subjList{isubj})
		end
		if ~exist('Figures/Kernels', 'dir'), mkdir('Figures/Kernels'), end
		exportgraphics(gcf, sprintf('Figures/Kernels/loc%d_bin%d.jpg', ilocs, ibin), 'Resolution', 300)
	end
end

%% Plot 2 Loc ScatterPlot Comparisons
qLoc1 = 2;
qLoc2 = 4;
%%
for ifeature = 1:2
    if ifeature == 1
        marg = margTuningCharORI; nparams = 3; txt = 'ORI';
        axis_ticks = [0 .25;
                      5 40;
                      -.1 .05];
    else
        marg = margTuningCharSF; nparams = 4; txt = 'SF';
        axis_ticks = [1 3;
                      .05 .2;
                      0 1.2;
                      -.1 .02];
    end
    for ibin = 1:nBins
        figure('Position', [0 0 1600 800]), hold on
        for iparam = 1:nparams
            data_x = [];
            data_y = [];
            subplot(1,nparams,iparam), hold on, axis square
            
            plot(linspace(axis_ticks(iparam,1), axis_ticks(iparam,2), 100), linspace(axis_ticks(iparam,1), axis_ticks(iparam,2), 100), '-', 'Color', [.75 .75 .75])
            
            for isubj = 1:nsubjs
                data_x = [data_x; squeeze(marg(qLoc1,isubj,ibin,itypes,iparam))];
                data_y = [data_y; squeeze(marg(qLoc2,isubj,ibin,itypes,iparam))];
            end
            mdl = fitlm(data_x, data_y);

%             plot([min(data_x), max(data_x)], mdl.Coefficients{2,1} .* ([min(data_x), max(data_x)]) + mdl.Coefficients{1,1}, '-k', 'LineWidth', 4);
            [r, p] = ttest(data_x, data_y);
            subtitle(sprintf('%s\np: %.2f', namesTuningC_all{ifeature}{iparam}, p), 'FontSize', 24)
            for isubj = 1:nsubjs
                plot(marg(qLoc1,isubj,ibin,itypes,iparam), marg(qLoc2,isubj,ibin,itypes,iparam),...
                    'o', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'g', 'MarkerSize', 8)
            end
            plot(mean(marg(qLoc1,:,ibin,itypes,iparam),2), mean(marg(qLoc2,:,ibin,itypes,iparam),2),...
                    'o', 'MarkerFaceColor', [0 .5 0], 'MarkerEdgeColor', 'k', 'MarkerSize', 16)
            errorbar(mean(marg(qLoc1,:,ibin,itypes,iparam),2), mean(marg(qLoc2,:,ibin,itypes,iparam),2),...
                        std(marg(qLoc1,:,ibin,itypes,iparam))/sqrt(11), 'horizontal', 'CapSize', 0, 'LineWidth', 4, 'Color', 'k')
            errorbar(mean(marg(qLoc1,:,ibin,itypes,iparam),2), mean(marg(qLoc2,:,ibin,itypes,iparam),2),...
                std(marg(qLoc2,:,ibin,itypes,iparam))/sqrt(11), 'vertical', 'CapSize', 0, 'LineWidth', 4, 'Color', 'k')
            xlim(axis_ticks(iparam,:))
            ylim(axis_ticks(iparam,:))
            set(gca, 'FontSize', 24)
        end
        if ~exist('Figures/Scatter', 'dir'), mkdir('Figures/Scatter'), end
		exportgraphics(gcf, sprintf('Figures/Scatter/%s_bin%d.jpg', txt, ibin), 'Resolution', 300)
    end
end

%% Plot comparisons of differences between Bin 1 and Last Bin
for ifeature = 1:2
    if ifeature == 1
        marg = margTuningCharORI; nparams = 3; txt = 'ORI';
        axis_ticks = [-.1 .1;
                      -30 20;
                      -.05 .05];
    else
        marg = margTuningCharSF; nparams = 4; txt = 'SF';
        axis_ticks = [-1 1;
                      -.05 .1;
                      -.5 1;
                      -.1 .1];
    end
    figure('Position', [0 0 1600 800]), hold on
    for iparam = 1:nparams
        data_x = [];
        data_y = [];
        subplot(1,nparams,iparam), hold on, axis square
        
        plot(linspace(axis_ticks(iparam,1), axis_ticks(iparam,2), 100), linspace(axis_ticks(iparam,1), axis_ticks(iparam,2), 100), '-', 'Color', [.75 .75 .75])

        for isubj = 1:nsubjs
            a = squeeze(marg(2,isubj,3,itypes,iparam) - marg(2,isubj,1,itypes,iparam));
            b = squeeze(marg(4,isubj,3,itypes,iparam) - marg(4,isubj,1,itypes,iparam));
            data_x = [data_x; a];
            data_y = [data_y; b];
        end
        mdl = fitlm(data_x, data_y);

%             plot([min(data_x), max(data_x)], mdl.Coefficients{2,1} .* ([min(data_x), max(data_x)]) + mdl.Coefficients{1,1}, '-k', 'LineWidth', 4);
        [h, p] = ttest(data_x, data_y);
        subtitle(sprintf('%s\np: %.2f', namesTuningC_all{ifeature}{iparam}, p), 'FontSize', 24)
        for isubj = 1:nsubjs
            a = squeeze(marg(2,isubj,3,itypes,iparam) - marg(2,isubj,1,itypes,iparam));
            b = squeeze(marg(4,isubj,3,itypes,iparam) - marg(4,isubj,1,itypes,iparam));
            plot(a, b,...
                'o', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'g', 'MarkerSize', 8)
        end
        a = mean(marg(2,:,3,itypes,iparam)-marg(2,:,1,itypes,iparam),2);
        b = mean(marg(4,:,3,itypes,iparam)-marg(4,:,1,itypes,iparam),2);
        plot(a, b,...
                'o', 'MarkerFaceColor', [0 .5 0], 'MarkerEdgeColor', 'k', 'MarkerSize', 16)
        errorbar(a, b,...
                    std(marg(2,:,3,itypes,iparam)-marg(2,:,1,itypes,iparam))/sqrt(11), 'horizontal', 'CapSize', 0, 'LineWidth', 4, 'Color', 'k')
        errorbar(a, b,...
            std(marg(4,:,3,itypes,iparam)-marg(4,:,1,itypes,iparam))/sqrt(11), 'vertical', 'CapSize', 0, 'LineWidth', 4, 'Color', 'k')
        xlim(axis_ticks(iparam,:))
        ylim(axis_ticks(iparam,:))
        set(gca, 'FontSize', 24)
    end
    if ~exist('Figures/Scatter', 'dir'), mkdir('Figures/Scatter'), end
    exportgraphics(gcf, sprintf('Figures/Scatter/%s.jpg', txt), 'Resolution', 300)
end