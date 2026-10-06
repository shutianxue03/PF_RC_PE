%% Calculate separability v2
if ~exist('seperability_allv2', 'var')
    seperability_allv2 = nan(nsubjs, 1000, 5, nBins, ntypes);
    fprintf('\nCalculating separability\n')
    
    for isubj = 1:nsubjs
        fprintf('Subj: %d\n', isubj)
        for ilocs = 1:5
            for ib = 1:1000
                for ibins = 1:nBins
                    seperability_allv2(isubj, ib, ilocs,ibins,itypes) = ...
                        getSeparability(squeeze(kernels2D_all(isubj, ilocs, ib, ibins, itypes,6:37,7:30)));
                end
            end
        end
    end
    fprintf('DONE\n')
end

%% Calcuate main effects
data = [];
loc = [];
bin = [];
for iloc = 1:5
	for ibin = 1:nBins
		[med, ~, ~, ~, ~] = getCI(seperability_allv2(:,:,iloc,ibin,itypes),1,2);
		data = [data, squeeze(med)'];
		loc = [loc, ones(1,nsubjs) * iloc];
		bin = [bin, ones(1,nsubjs) * ibin];
	end
end
txt1 = print_nANOVA({'loc', 'bin'}, data, {loc, bin});
txt2 = print_nANOVA({'loc'}, data, {loc});
txt3 = print_nANOVA({'bin'}, data, {bin});
fprintf('\n%s\n', txt1)

%% Plot separability
% all locations together per bin

fprintf('Plotting separability all location per bin\n')
for ibins = 1:nBins
    fprintf('Bin%d\n',ibins)
    figure, hold on
	data = [];
	loc = [];
    for ilocs = 1:5
        fprintf('ilocs: %d\n',ilocs)
        for isubj = 1:nsubjs
            [med, lb, ub, SEM_neg, SEM_pos] = getCI(seperability_allv2(isubj,:,ilocs,ibins,itypes),1,2);
            plot(isubj - (.2 - ((ilocs-1) * .1)), med, 'o', 'MarkerFaceColor', colors_comb(ilocs,:), 'MarkerEdgeColor', [1 1 1], 'LineWidth', 1.5, 'MarkerSize', 8)
            errorbar(isubj - (.2 - ((ilocs-1) * .1)),med,SEM_neg,SEM_pos,'Color', colors_comb(ilocs,:), 'CapSize', 0, 'LineWidth', 1.5)
			[med, lb, ub, SEM_neg, SEM_pos] = getCI(seperability_allv2(:,:,ilocs,ibins,itypes),1,'all');
			plot(12 - (.2 - ((ilocs-1) * .1)), med, 'o', 'MarkerFaceColor', colors_comb(ilocs,:), 'MarkerEdgeColor', [1 1 1], 'LineWidth', 1.5, 'MarkerSize', 8)
			errorbar(12 - (.2 - ((ilocs-1) * .1)),med,SEM_neg,SEM_pos,'Color', colors_comb(ilocs,:), 'CapSize', 0, 'LineWidth', 1.5)
        end
		[med, ~, ~, ~, ~] = getCI(seperability_allv2(:,:,ilocs,ibins,itypes),1,2);
		data = [data, squeeze(med)'];
		loc = [loc, ones(1,nsubjs) * ilocs];
    end
    title(print_nANOVA({'loc'}, data, {loc}))
    xlim([0 13])
    xticks(1:11)
    xlabel('Subj')
    ylabel('Corr')
	ylim([-.5 1])

    if ~exist('Figures/separability', 'dir'), mkdir('Figures/separability'), end
    exportgraphics(gcf, sprintf('Figures/separability/bin%d.jpg', ibins), 'Resolution', 300)
end
fprintf('Done\n')

%% Plot separability
% Plot each location separatlely per bin

fprintf('Plotting separability per location per bin\n')
for ibins = 1:nBins
    fprintf('Bin%d\n',ibins)
    for ilocs = 1:5
        fprintf('loc: %d\n',ilocs)
		figure, hold on
        for isubj = 1:nsubjs
            [med, lb, ub, SEM_neg, SEM_pos] = getCI(seperability_allv2(isubj,:,ilocs,ibins,itypes),1,2);
            plot(isubj, med, 'o', 'MarkerFaceColor', colors_comb(ilocs,:), 'MarkerEdgeColor', [1 1 1], 'LineWidth', 1.5, 'MarkerSize', 8)
            errorbar(isubj,med,SEM_neg,SEM_pos,'Color', colors_comb(ilocs,:), 'CapSize', 0, 'LineWidth', 1.5)
        end
		yline(squeeze(nanmedian(seperability_allv2(:,:,ilocs,ibins,itypes),'all')), 'Color', colors_comb(ilocs,:), 'LineWidth', 1.5)
		xlim([0 12])
		xticks(1:11)
		xlabel('Subj')
		ylabel('Corr')
		ylim([-.5 1])

		if ~exist(sprintf('Figures/separability/Bin%d', ibins), 'dir'), mkdir(sprintf('Figures/separability/Bin%d', ibins)), end
		exportgraphics(gcf, sprintf('Figures/separability/Bin%d/Loc%d.jpg', ibins,ilocs), 'Resolution', 300)
    end
end
fprintf('Done\n')

%% Plot Separability
% Each location with each bin

fprintf('Plotting separability per location with each bin\n')
figure, hold on
for ilocs = 1:5
	data = [];
	loc = [];
	bin = [];
	plotColors = colorGradient(ilocs,:);
	if ilocs == 1
	   plotColors = {[.5, .5, .5],...          %Fovea
				[0, 0, 0],...
				[0, 0, 0],...
				[0, 0, 0]};
	end
	if ilocs == 2
	%            plotColors = colorGradient(9,:);
		plotColors = {'#9cff9c',...          %Fovea '#9cff9c'
				'#9cff9c',...
				[0, RGB_gradient2(4), 0],...
				[0, RGB_gradient2(4), 0]};
	elseif ilocs == 8, plotColors = colorGradient(10,:);
	end
	fprintf('ilocs: %d\n',ilocs)
	figure, hold on
	
	for isubj = 1:nsubjs
		for ibin = 1:nBins
			[med, lb, ub, SEM_neg, SEM_pos] = getCI(seperability_allv2(isubj,:,ilocs,ibin,itypes),1,2);
			plot(isubj - (.2 - ((ibin-1) * .2)), med, 'o', 'MarkerFaceColor', plotColors{ibin}, 'MarkerEdgeColor', [1 1 1], 'LineWidth', 1.5, 'MarkerSize', 8)
			errorbar(isubj - (.2 - ((ibin-1) * .2)),med,SEM_neg,SEM_pos,'Color', plotColors{ibin}, 'CapSize', 0, 'LineWidth', 1.5)
			[med, lb, ub, SEM_neg, SEM_pos] = getCI(seperability_allv2(:,:,ilocs,ibin,itypes),1,'all');
			plot(12 - (.2 - ((ibin-1) * .2)), med, 'o', 'MarkerFaceColor', plotColors{ibin}, 'MarkerEdgeColor', [1 1 1], 'LineWidth', 1.5, 'MarkerSize', 8)
			errorbar(12 - (.2 - ((ibin-1) * .2)),med,SEM_neg,SEM_pos,'Color', plotColors{ibin}, 'CapSize', 0, 'LineWidth', 1.5)
			
			[med, ~, ~, ~, ~] = getCI(seperability_allv2(isubj,:,ilocs,ibin,itypes),1,2);
			data = [data, squeeze(med)'];
			bin = [bin, ibin];
		end
	end
	title(print_nANOVA({'bin'}, data, {bin}))
	xlim([0 13])
	xticks(1:11)
	xlabel('Subj')
	ylabel('Corr')
	ylim([-.5 1])

	if ~exist('Figures/separability', 'dir'), mkdir('Figures/separability'), end
	exportgraphics(gcf, sprintf('Figures/separability/loc%d.jpg', ilocs), 'Resolution', 300)
end
fprintf('Done\n')

%% Plot Separabilty
% Mean location with each bin
fprintf('Plotting separability mean location with each bin\n')
figure, hold on
data = [];
loc = [];
bin = [];

plotColors = {[.5, .5, .5],...          %Fovea
		[0, 0, 0],...
		[0, 0, 0],...
		[0, 0, 0]};
	
	for isubj = 1:nsubjs
		for ibin = 1:nBins
			[med, lb, ub, SEM_neg, SEM_pos] = getCI(seperability_allv2(isubj,:,:,ibin,itypes),1,'all');
			plot(isubj - (.2 - ((ibin-1) * .2)), med, 'o', 'MarkerFaceColor', plotColors{ibin}, 'MarkerEdgeColor', [1 1 1], 'LineWidth', 1.5, 'MarkerSize', 8)
			errorbar(isubj - (.2 - ((ibin-1) * .2)),med,SEM_neg,SEM_pos,'Color', plotColors{ibin}, 'CapSize', 0, 'LineWidth', 1.5)
			[med, lb, ub, SEM_neg, SEM_pos] = getCI(seperability_allv2(:,:,ilocs,ibin,itypes),1,'all');
			plot(12 - (.2 - ((ibin-1) * .2)), med, 'o', 'MarkerFaceColor', plotColors{ibin}, 'MarkerEdgeColor', [1 1 1], 'LineWidth', 1.5, 'MarkerSize', 8)
			errorbar(12 - (.2 - ((ibin-1) * .2)),med,SEM_neg,SEM_pos,'Color', plotColors{ibin}, 'CapSize', 0, 'LineWidth', 1.5)
			
			[med, ~, ~, ~, ~] = getCI(seperability_allv2(isubj,:,:,ibin,itypes),1,2);
			data = [data, squeeze(med)'];
			bin = [bin, ones(1,5) * ibin];
		end
	end
	title(print_nANOVA({'bin'}, data, {bin}))
	xlim([0 13])
	xticks(1:11)
	xlabel('Subj')
	ylabel('Corr')
	ylim([-.5 1])

	if ~exist('Figures/separability', 'dir'), mkdir('Figures/separability'), end
	exportgraphics(gcf, sprintf('Figures/separability/loc_all.jpg'), 'Resolution', 300)
fprintf('Done\n')

%% Plot Separabilty
% Each location averaged across bin
fprintf('Plotting separability each location averaged across bin\n')
data = [];
loc = [];
bin = [];

for ilocs = 1:5
	plotColors = colorGradient(ilocs,:);
	if ilocs == 1
	   plotColors = {[.5, .5, .5],...          %Fovea
				[0, 0, 0],...
				[0, 0, 0],...
				[0, 0, 0]};
	end
	if ilocs == 2
	%            plotColors = colorGradient(9,:);
		plotColors = {'#9cff9c',...          %Fovea '#9cff9c'
				'#9cff9c',...
				[0, RGB_gradient2(4), 0],...
				[0, RGB_gradient2(4), 0]};
	elseif ilocs == 8, plotColors = colorGradient(10,:);
    end
    
	fprintf('ilocs: %d\n',ilocs)
	figure, hold on
	
    for isubj = 1:nsubjs
        [med, lb, ub, SEM_neg, SEM_pos] = getCI(mean(seperability_allv2(isubj,:,ilocs,:,itypes),4),1,2);
        plot(isubj, med, 'o', 'MarkerFaceColor', plotColors{ibin}, 'MarkerEdgeColor', [1 1 1], 'LineWidth', 1.5, 'MarkerSize', 8)
        errorbar(isubj, med,SEM_neg,SEM_pos,'Color', plotColors{ibin}, 'CapSize', 0, 'LineWidth', 1.5)
        [med, lb, ub, SEM_neg, SEM_pos] = getCI(mean(seperability_allv2(:,:,ilocs,:,itypes),4),1,'all');
        plot(12, med, 'o', 'MarkerFaceColor', plotColors{ibin}, 'MarkerEdgeColor', [1 1 1], 'LineWidth', 1.5, 'MarkerSize', 8)
        errorbar(12, med,SEM_neg,SEM_pos,'Color', plotColors{ibin}, 'CapSize', 0, 'LineWidth', 1.5)

        [med, ~, ~, ~, ~] = getCI(mean(seperability_allv2(isubj,:,ilocs,:,itypes),4),1,2);
        data = [data, squeeze(med)'];
        loc = [loc, ilocs];
    end
	xlim([0 13])
	xticks(1:11)
	xlabel('Subj')
	ylabel('Corr')
	ylim([-.5 1])

	if ~exist('Figures/separability', 'dir'), mkdir('Figures/separability'), end
	exportgraphics(gcf, sprintf('Figures/separability/allT_loc%d.jpg', ilocs), 'Resolution', 300)
end
fprintf(print_nANOVA({'loc'}, data, {loc}))
fprintf('Done\n')

%% Plot Separabilty
% All locations with averaged across bins
fprintf('Plotting separability all locs averaged across bins\n')
figure, hold on
data = [];
loc = [];
bin = [];
for ilocs = 1:5
	plotColors = colorGradient(ilocs,:);
	if ilocs == 1
	   plotColors = {[.5, .5, .5],...          %Fovea
				[0, 0, 0],...
				[0, 0, 0],...
				[0, 0, 0]};
	end
	if ilocs == 2
	%            plotColors = colorGradient(9,:);
		plotColors = {'#9cff9c',...          %Fovea '#9cff9c'
				'#9cff9c',...
				[0, RGB_gradient2(4), 0],...
				[0, RGB_gradient2(4), 0]};
	elseif ilocs == 8, plotColors = colorGradient(10,:);
	end
	fprintf('ilocs: %d\n',ilocs)
	
    for isubj = 1:nsubjs
        [med, lb, ub, SEM_neg, SEM_pos] = getCI(mean(seperability_allv2(isubj,:,ilocs,:,itypes),4),1,2);
        plot(isubj - (.1 - ((ilocs-1) * .05)), med, 'o', 'MarkerFaceColor', plotColors{ibin}, 'MarkerEdgeColor', [1 1 1], 'LineWidth', 1.5, 'MarkerSize', 8)
        errorbar(isubj - (.1 - ((ilocs-1) * .05)), med,SEM_neg,SEM_pos,'Color', plotColors{ibin}, 'CapSize', 0, 'LineWidth', 1.5)

        [med, ~, ~, ~, ~] = getCI(mean(seperability_allv2(isubj,:,ilocs,:,itypes),4),1,2);
        data = [data, squeeze(med)'];
        loc = [loc, ilocs];
    end
    [med, lb, ub, SEM_neg, SEM_pos] = getCI(mean(seperability_allv2(:,:,ilocs,:,itypes),4),1,'all');
    plot(12 - (.1 - ((ilocs-1) * .05)), med, 'o', 'MarkerFaceColor', plotColors{ibin}, 'MarkerEdgeColor', [1 1 1], 'LineWidth', 1.5, 'MarkerSize', 8)
    errorbar(12 - (.1 - ((ilocs-1) * .05)), med,SEM_neg,SEM_pos,'Color', plotColors{ibin}, 'CapSize', 0, 'LineWidth', 1.5)
    fprintf('%.2f\n', med)
end

title(print_nANOVA({'loc'}, data, {loc}))
xlim([0 13])
xticks(1:11)
xlabel('Subj')
ylabel('Corr')
ylim([-.5 1])
if ~exist('Figures/separability', 'dir'), mkdir('Figures/separability'), end
exportgraphics(gcf, sprintf('Figures/separability/allT_loc_all.jpg'), 'Resolution', 300)
fprintf('Done\n')