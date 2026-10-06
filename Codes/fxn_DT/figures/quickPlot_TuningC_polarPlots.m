%% Plot Polar angles
clc
itype = 2;
polarLocations = [pi pi/2 0 3*pi/2 pi];
for ifeature = 2%1:2
    if ifeature == 1
%         rlimits = [-3.5 0;
%            -1.5 1;
%            -1 1.5];
%         rmidticks = [-2, 0, 0];
        rlimits = [0 1.5;
           .25 1.75;
           -7.5 7.5];
        rmidticks = [1, 1, 0];
        tuningC = margTuningCharORI;
        tuningC_mean = margTuningCharOri_Mean;
        tuningC_SE = margTuningCharOri_SE;
        nparams = nORI_TuningC;
        ifamily = 1;
        ybounds = oriBoundsTuning;
    else
%         rlimits = [-3 .5;
%                    -3.5 0;
%                    -3 .75;
%                    -3 0];
%         rmidticks = [-2, -2, -2, -1.5];
        rlimits = [0 1.5;
                   0 1.5;
                   0 1.5;
                   -5 5];
        rmidticks = [1 1 1 0];
        tuningC = margTuningCharSF;
        tuningC_mean = margTuningCharSF_Mean;
        tuningC_SE = margTuningCharSF_SE;
        nparams = nSF_TuningC;
        ifamily = 2;
        ybounds = sfBoundsTuning;
    end
    for iparam = 4%1:nparams
        data = [];
        loc = [];
        bin = [];
        bins_all = [1 nBins];
        
        close all
        figure('Position', [0, 0, 1280, 1280]), %hold on%, box on
        
        margNorm_all = (tuningC([2 3 4 5], isubj2, [1 nBins], itype, iparam)) ./ (tuningC(1, isubj2, [1], itype, iparam));
        margNorm_all(5,:,:) = margNorm_all(1,:,:);
        margNorm = squeeze(mean(margNorm_all,2));
%         margNorm = (margNorm_all([1:4 1], :, [1 4]) - mean(margNorm_all([1:4 1], :, [1 4]), 2)) ./ std(margNorm_all([1:4 1], :, [1 4]), [],2);
% %         fprintf('%.2f\n',margNorm)
%         a = tuningC(1, :, nBins, itype, iparam) ./ (tuningC(1, :, [1], itype, iparam));
%         polarplot(linspace(0,2*pi,360), ones(1,360) .* squeeze(mean(a,2)), '-', 'Color', [0 0 0], 'LineWidth', 8.5), hold on
%         polarplot(linspace(0,2*pi,360), ones(1,360), '--', 'Color', [.25 .25 .25], 'LineWidth', 8.5)
%         error1 = mean(a,2) - std(a,[], 'all')/sqrt(nsubjs)/2;
%         error2 = mean(a,2) + std(a,[], 'all')/sqrt(nsubjs)/2;
%         if ibin == 1, errorColor = plotColors{iloc_, 1}; else, errorColor = plotColors{iloc_, 2}; end
%         polarplot([deg2rad(-45) deg2rad(-45)], [error1, error2], '-k', 'LineWidth', 10)

        polarplot(polarLocations, margNorm(:,1), '-', 'Color', [.5 .5 .5], 'LineWidth', 8.5), hold on
        polarplot(polarLocations, margNorm(:,2), '-', 'Color', [0 0 0], 'LineWidth', 8.5)
        %polarplot(linspace(0,2*pi,360),ones(1,360), 'Color', [.5 .5 .5], 'LineWidth', 12.5)
        plotColors = colorGradient2([1 3 4 5 2],[1 4]);
        for iloc_ = 2:5
            for ibin = [1 2]
                error1 = margNorm(iloc_,ibin) - std(margNorm_all(iloc_,:,ibin),[], 'all')/2;
                error2 = margNorm(iloc_,ibin) + std(margNorm_all(iloc_,:,ibin),[], 'all')/2;
                if ibin == 1, errorColor = plotColors{iloc_, 1}; else, errorColor = plotColors{iloc_, 2}; end
                polarplot([polarLocations(iloc_) polarLocations(iloc_)], [error1, error2], '-k', 'Color', errorColor, 'LineWidth', 10)
% %                 
                polarplot(polarLocations(iloc_), margNorm(iloc_,ibin), 'o', 'MarkerEdgeColor', plotColors{iloc_, ibin}, 'MarkerFaceColor', 'w', 'MarkerSize', 56, 'LineWidth', 16);
		        polarplot(polarLocations(iloc_), margNorm(iloc_,ibin), 'o', 'MarkerEdgeColor', plotColors{iloc_, ibin}, 'MarkerEdgeColor', 'w', 'MarkerSize', 32, 'LineWidth', 16);
                polarplot([polarLocations(iloc_) polarLocations(iloc_)], [error1, error2], '-k', 'Color', errorColor, 'LineWidth', 10)
                data = [data, squeeze(margNorm_all(iloc_,:,ibin))];
                loc = [loc, ones(1,nsubjs) * iloc_];
                bin = [bin, ones(1,nsubjs) * ibin];
            end
            [h, p] = ttest(margNorm_all(iloc_,:,1), margNorm_all(iloc_,:,2), "Alpha", .05/5);
            if h == 1, txt1 = '*'; else, txt1 = ''; end
            fprintf('Loc 1: %sp=%.2f\n',txt1,p)
        end
        
        fprintf('%s - %s\n', namesTuningC_all{ifamily}{iparam}, print_nANOVA({'Loc', 'practice'}, data, {loc, bin}));
        rlim(rlimits(iparam,:))
        rticks([rlimits(iparam,1) rmidticks(iparam) rlimits(iparam,2)])
        
        set(findall(gcf, '-property', 'FontSize'), 'FontSize',48)
        %set(findall(gcf, '-property', 'LineWidth'), 'LineWidth',10)
        set(gca().RAxis, 'FontSize', 36)
        set(gca().ThetaAxis, 'FontSize', 58)
        set(gca(), 'ThetaTick', [0 90 180 270])
        set(gca, 'ThetaTickLabel', {'LHM', 'UVM', 'RHM', 'LVM'})
        set(gca, 'RAxisLocation', 45);
        set(gca, 'LineWidth', 12)
        set(gca, 'FontSize', 72)
        nameFileDir = sprintf('%s/TuningCTTests_all', dirName);
        if ~(exist(nameFileDir, 'dir')), mkdir(nameFileDir); end
        nameFileFigure = sprintf('%s/TuningCTTests_all/%s_%s.jpg', dirName, namesFeature{ifeature}, namesTuningC_all{ifamily}{iparam});
        exportgraphics(gcf,nameFileFigure, 'Resolution', 300)
    end %end of iparam
end %end of ifeature
%% Plot Polar angles
clc
itype = 2;
polarLocations = [pi pi/2 0 3*pi/2 pi];
for ifeature = 1:2
    if ifeature == 1
%         rlimits = [-3.5 0;
%            -1.5 1;
%            -1 1.5];
%         rmidticks = [-2, 0, 0];
        rlimits = [0 1.5;
           .25 1.75;
           -7.5 7.5];
        rmidticks = [1, 1, 0];
        tuningC = margTuningCharORI;
        tuningC_mean = margTuningCharOri_Mean;
        tuningC_SE = margTuningCharOri_SE;
        nparams = nORI_TuningC;
        ifamily = 1;
        ybounds = oriBoundsTuning;
    else
%         rlimits = [-3 .5;
%                    -3.5 0;
%                    -3 .75;
%                    -3 0];
%         rmidticks = [-2, -2, -2, -1.5];
        rlimits = [0 1.5;
                   0 1.5;
                   0 1.5;
                   -5 5];
        rmidticks = [1 1 1 0];
        tuningC = margTuningCharSF;
        tuningC_mean = margTuningCharSF_Mean;
        tuningC_SE = margTuningCharSF_SE;
        nparams = nSF_TuningC;
        ifamily = 2;
        ybounds = sfBoundsTuning;
    end
    for iparam = 1:nparams
        data = [];
        loc = [];
        bin = [];
        bins_all = [1 nBins];
        
        close all
        figure('Position', [0, 0, 1280, 1280]), %hold on%, box on
        
        margNorm_all = ((tuningC([2 3 4 5], isubj2, nBins, itype, iparam))-(tuningC([2 3 4 5], isubj2, 1, itype, iparam))) ./ ((tuningC([2 3 4 5], isubj2, nBins, itype, iparam))+(tuningC([2 3 4 5], isubj2, 1, itype, iparam)));
        margNorm_all(5,:) = margNorm_all(1,:);
        margNorm = squeeze(mean(margNorm_all,2));
%         margNorm = (margNorm_all([1:4 1], :, [1 4]) - mean(margNorm_all([1:4 1], :, [1 4]), 2)) ./ std(margNorm_all([1:4 1], :, [1 4]), [],2);
% %         fprintf('%.2f\n',margNorm)
%         a = tuningC(1, :, nBins, itype, iparam) ./ (tuningC(1, :, [1], itype, iparam));
%         polarplot(linspace(0,2*pi,360), ones(1,360) .* squeeze(mean(a,2)), '-', 'Color', [0 0 0], 'LineWidth', 8.5), hold on
%         polarplot(linspace(0,2*pi,360), ones(1,360), '--', 'Color', [.25 .25 .25], 'LineWidth', 8.5)
%         error1 = mean(a,2) - std(a,[], 'all')/sqrt(nsubjs)/2;
%         error2 = mean(a,2) + std(a,[], 'all')/sqrt(nsubjs)/2;
%         if ibin == 1, errorColor = plotColors{iloc_, 1}; else, errorColor = plotColors{iloc_, 2}; end
%         polarplot([deg2rad(-45) deg2rad(-45)], [error1, error2], '-k', 'LineWidth', 10)

        polarplot(polarLocations, margNorm(:,1), '-', 'Color', [.5 .5 .5], 'LineWidth', 8.5), hold on
%         polarplot(polarLocations, margNorm(:,2), '-', 'Color', [0 0 0], 'LineWidth', 8.5)
        %polarplot(linspace(0,2*pi,360),ones(1,360), 'Color', [.5 .5 .5], 'LineWidth', 12.5)
        plotColors = colorGradient2([1 3 4 5 2],[1 4]);
        for iloc_ = 2:5
            for ibin = 1%[1 2]
                error1 = margNorm(iloc_,ibin) - std(margNorm_all(iloc_,:,ibin),[], 'all')/2;
                error2 = margNorm(iloc_,ibin) + std(margNorm_all(iloc_,:,ibin),[], 'all')/2;
                if ibin == 1, errorColor = plotColors{iloc_, 1}; else, errorColor = plotColors{iloc_, 2}; end
                polarplot([polarLocations(iloc_) polarLocations(iloc_)], [error1, error2], '-k', 'Color', errorColor, 'LineWidth', 10)
% %                 
                polarplot(polarLocations(iloc_), margNorm(iloc_,ibin), 'o', 'MarkerEdgeColor', plotColors{iloc_, ibin}, 'MarkerFaceColor', 'w', 'MarkerSize', 56, 'LineWidth', 16);
		        polarplot(polarLocations(iloc_), margNorm(iloc_,ibin), 'o', 'MarkerEdgeColor', plotColors{iloc_, ibin}, 'MarkerEdgeColor', 'w', 'MarkerSize', 32, 'LineWidth', 16);
                polarplot([polarLocations(iloc_) polarLocations(iloc_)], [error1, error2], '-k', 'Color', errorColor, 'LineWidth', 10)
                data = [data, squeeze(margNorm_all(iloc_,:,ibin))];
                loc = [loc, ones(1,nsubjs) * iloc_];
                bin = [bin, ones(1,nsubjs) * ibin];
            end
%             [h, p] = ttest(margNorm_all(iloc_,:,1), margNorm_all(iloc_,:,2), "Alpha", .05/5);
%             if h == 1, txt1 = '*'; else, txt1 = ''; end
%             fprintf('Loc 1: %sp=%.2f\n',txt1,p)
        end
        
%         fprintf('%s - %s\n', namesTuningC_all{ifamily}{iparam}, print_nANOVA({'Loc', 'practice'}, data, {loc, bin}));
%         rlim(rlimits(iparam,:))
%         rticks([rlimits(iparam,1) rmidticks(iparam) rlimits(iparam,2)])
%         rlim([0 1])
        
        set(findall(gcf, '-property', 'FontSize'), 'FontSize',48)
        %set(findall(gcf, '-property', 'LineWidth'), 'LineWidth',10)
        set(gca().RAxis, 'FontSize', 36)
        set(gca().ThetaAxis, 'FontSize', 58)
        set(gca(), 'ThetaTick', [0 90 180 270])
        set(gca, 'ThetaTickLabel', {'LHM', 'UVM', 'RHM', 'LVM'})
        set(gca, 'RAxisLocation', 45);
        set(gca, 'LineWidth', 12)
        set(gca, 'FontSize', 72)
        nameFileDir = sprintf('%s/TuningCTTests_all', dirName);
        if ~(exist(nameFileDir, 'dir')), mkdir(nameFileDir); end
        nameFileFigure = sprintf('%s/TuningCTTests_all/%s_%s.jpg', dirName, namesFeature{ifeature}, namesTuningC_all{ifamily}{iparam});
        exportgraphics(gcf,nameFileFigure, 'Resolution', 300)
    end %end of iparam
end %end of ifeature
%%
clc, close all
figDir = 'figs/New_Figs/TuningC';
if ~exist(figDir,'dir'), mkdir(figDir), end
plotLocs = [1 8 6 7 5 3];

figure ('Position', [0 0 1400 800]), hold on
plotColors = colorGradient2([1 3 4 5 4],[1 4]);
plotColors_plot = plotColors([1 1 3 3 4 2],:);
plotColors_plot(2,:) = {[.5 .5 .5]};
plotColors_plot(4,:) = {[.5 0 1]};
for ifeature = 1:2
    fprintf('%s\n',namesFeature{ifeature})
    if ifeature == 1
        tuningC = margTuningCharORI;
        tuningC_mean = margTuningCharOri_Mean;
        tuningC_SE = margTuningCharOri_SE;
        nparams = nORI_TuningC;
        ifamily = 1;
        ybounds = oriBoundsTuning;
    else
        tuningC = margTuningCharSF;
        tuningC_mean = margTuningCharSF_Mean;
        tuningC_SE = margTuningCharSF_SE;
        nparams = nSF_TuningC;
        ifamily = 2;
        ybounds = sfBoundsTuning;
    end
    for iparam = 1:nparams
        data = [];
        loc = [];
        bin = [];
        clf, hold on
        margNorm_all = (tuningC(plotLocs, isubj2, [1 nBins], itype, iparam));
        for iLoc = 1:6
            tuningMarg = squeeze(mean(margNorm_all(iLoc,:,:),2));
            std_error = std(squeeze(margNorm_all(iLoc,:,:)),[],1)./sqrt(nsubjs);
            margDiff = squeeze(mean(tuningC(iLoc, isubj2, [1 nBins], itype, iparam),[1]));
            if plotLocs(iLoc) == 6
                tuningMarg = squeeze(mean(tuningC([2 4], isubj2, [1 nBins], itype, iparam),[1 2]));
                std_error = std(squeeze(mean(tuningC([2 4], isubj2, [1 nBins], itype, iparam),1)))./sqrt(nsubjs);
                margDiff = squeeze(mean(tuningC([2 4], isubj2, [1 nBins], itype, iparam),[1]));
            elseif plotLocs(iLoc) == 7
                tuningMarg = squeeze(mean(tuningC([5 3], isubj2, [1 nBins], itype, iparam),[1 2]));
                std_error = std(squeeze(mean(tuningC([5 3], isubj2, [1 nBins], itype, iparam),1)))./sqrt(nsubjs);
                margDiff = squeeze(mean(tuningC([5 3], isubj2, [1 nBins], itype, iparam),[1]));
            elseif plotLocs(iLoc) == 8
                tuningMarg = squeeze(mean(tuningC(2:5, isubj2, [1 nBins], itype, iparam),[1 2]));
                std_error = std(squeeze(mean(tuningC(2:5, isubj2, [1 nBins], itype, iparam),1)))./sqrt(nsubjs);
                margDiff = squeeze(mean(tuningC(2:5, isubj2, [1 nBins], itype, iparam),[1]));
            end
            b=bar(iLoc*.75, tuningMarg,...
                'FaceColor', plotColors_plot{iLoc,2}, 'FaceAlpha', 1, 'EdgeColor', plotColors_plot{iLoc,2}, 'LineWidth', 4.5);
            for iBin = 1:2
                errorbar(b(iBin).XEndPoints, tuningMarg(iBin), std_error(iBin), ...
                        'Color', plotColors_plot{iLoc,2}, 'CapSize', 0, 'LineWidth', 4.5)
            end
            plot([b.XEndPoints], [tuningMarg(iBin), tuningMarg(iBin)],'-k', 'LineWidth', 4.5)
            errorbar(mean([b.XEndPoints]), tuningMarg(iBin), std(margDiff(:,2)-margDiff(:,1))./sqrt(nsubjs), '-k', 'CapSize', 0, 'LineWidth', 4.5)

            b(1).FaceColor = 'w';%plotColors_plot{iLoc,2};
            b(1).FaceAlpha= .4;
%             b(2).FaceColor = plotColors_plot{iLoc,2};
%             b(2).FaceAlpha= .6;


            data = [data, margNorm_all(iLoc,:)];
            loc = [loc, ones(1,nsubjs*2) * iLoc];
            bin = [bin, ones(1,nsubjs), ones(1,nsubjs).*2];

            tuningMarg = squeeze(mean(tuningC(plotLocs(iLoc), isubj2, [1 nBins], itype, iparam),[1]));
            if plotLocs(iLoc) == 6
                tuningMarg = squeeze(mean(tuningC([2 4], isubj2, [1 nBins], itype, iparam),[1]));
            elseif plotLocs(iLoc) == 7
                tuningMarg = squeeze(mean(tuningC([5 3], isubj2, [1 nBins], itype, iparam),[1]));
            elseif plotLocs(iLoc) == 8
                tuningMarg = squeeze(mean(tuningC(2:5, isubj2, [1 nBins], itype, iparam),[1]));
            end
            [h, p, ~, stats] = ttest(tuningMarg(:,1), tuningMarg(:,2), "Alpha", .05);
            if h == 1, txt1 = '*'; else, txt1 = ''; end
            fprintf('%s - Loc %i: t(%i)=%.2f, %sp=%.2f\n', namesTuningC_all{ifamily}{iparam},plotLocs(iLoc),stats.df,stats.tstat,txt1,p)

            % SEM of diff
            a = squeeze(mean(tuningC(1, isubj2, [1 nBins], itype, iparam),[1 3]));
            b = squeeze(mean(tuningC(2:5, isubj2, [1 nBins], itype, iparam),[1 3]));
            plot([.75, 1.5], [mean(a), mean(a)],'-k', 'LineWidth', 4.5)
            errorbar(1, mean(a), std(a-b)./sqrt(nsubjs), '-k', 'CapSize', 0, 'LineWidth', 4.5)
            a = squeeze(mean(tuningC([2 4], isubj2, [1 nBins], itype, iparam),[1 3]));
            b = squeeze(mean(tuningC([5 3], isubj2, [1 nBins], itype, iparam),[1 3]));
            plot([2.25, 3], [mean(a), mean(a)],'-k', 'LineWidth', 4.5)
            errorbar(2.5, mean(a), std(a-b)./sqrt(nsubjs), '-k', 'CapSize', 0, 'LineWidth', 4.5)
            a = squeeze(mean(tuningC(5, isubj2, [1 nBins], itype, iparam),[1 3]));
            b = squeeze(mean(tuningC(3, isubj2, [1 nBins], itype, iparam),[1 3]));
            plot([3.75, 4.5], [mean(a), mean(a)],'-k', 'LineWidth', 4.5)
            errorbar(4, mean(a), std(a-b)./sqrt(nsubjs), '-k', 'CapSize', 0, 'LineWidth', 4.5)
        end
%         fprintf('%s - %s\n', namesuningC_all{ifamily}{iparam}, print_nANOVA({'Loc', 'practice'}, data, {loc, bin}));
        set(gca, 'FontSize', 24)
        xticks(.75:.75:(5*.75))
        xticklabels({'Fovea', 'Perifovea', 'HM', 'LVM', 'UVM'})
        ylabel(namesTuningC_all{ifeature}{iparam})
        if ifeature==2 && iparam==1, ylim([1 2.5]), end
        if ifeature==2 && iparam==3, ylim([.2 .5]), end
%         pause
        exportgraphics(gcf, sprintf('%s/%s-%s.pdf',figDir,namesFeature{ifeature},namesTuningC_all{ifeature}{iparam}), 'Resolution', 300)
    end
end
%%
clc
for ifeature=1:2
    fprintf('%s\n',namesFeature{ifeature})
    if ifeature == 1
        tuningC = margTuningCharORI;
        tuningC_mean = margTuningCharOri_Mean;
        tuningC_SE = margTuningCharOri_SE;
        nparams = nORI_TuningC;
        ifamily = 1;
        ybounds = oriBoundsTuning;
    else
        tuningC = margTuningCharSF;
        tuningC_mean = margTuningCharSF_Mean;
        tuningC_SE = margTuningCharSF_SE;
        nparams = nSF_TuningC;
        ifamily = 2;
        ybounds = sfBoundsTuning;
    end
    for iparam = 1:nparams
        data = [];
        loc = [];
        bin = [];
        margNorm_all = tuningC(1:5, isubj2, [1 nBins], itype, iparam);
        for iLoc = 2:5
            data = [data, margNorm_all(iLoc,:)];
            loc = [loc, ones(1,nsubjs*2) * iLoc];
            bin = [bin, ones(1,nsubjs), ones(1,nsubjs).*2];
        end
        fprintf('%s - %s\n', namesTuningC_all{ifamily}{iparam}, print_nANOVA({'Loc', 'practice'}, data, {loc, bin}));
    end
end

%%
clc
for ifeature = 1:2
    fprintf('%s\n',namesFeature{ifeature})
    if ifeature == 1
        tuningC = margTuningCharORI;
        tuningC_mean = margTuningCharOri_Mean;
        tuningC_SE = margTuningCharOri_SE;
        nparams = nORI_TuningC;
        ifamily = 1;
        ybounds = oriBoundsTuning;
    else
        tuningC = margTuningCharSF;
        tuningC_mean = margTuningCharSF_Mean;
        tuningC_SE = margTuningCharSF_SE;
        nparams = nSF_TuningC;
        ifamily = 2;
        ybounds = sfBoundsTuning;
    end
    for iparam = 1:nparams
        data_loc1 = squeeze(mean(tuningC(2:5, isubj2, [1 nBins], itype, iparam),[1]));
        data_loc2 = squeeze(mean(tuningC(1, isubj2, [1 nBins], itype, iparam),[1]));
        data = [data_loc1(:)', data_loc2(:)'];
        loc = [ones(1,nsubjs*2), ones(1,nsubjs*2).*2];
        bin = [ones(1,nsubjs), ones(1,nsubjs).*2, ones(1,nsubjs), ones(1,nsubjs).*2];
        fprintf('%s-Eccentricity Effect - %s\n', namesTuningC_all{ifamily}{iparam}, print_nANOVA({'Location','practice'}, data, {loc,bin}));

        data_loc1 = squeeze(mean(tuningC([2 4], isubj2, [1 nBins], itype, iparam),[1]));
        data_loc2 = squeeze(mean(tuningC([5 3], isubj2, [1 nBins], itype, iparam),[1]));
        data = [data_loc1(:)', data_loc2(:)'];
        loc = [ones(1,nsubjs*2), ones(1,nsubjs*2).*2];
        bin = [ones(1,nsubjs), ones(1,nsubjs).*2, ones(1,nsubjs), ones(1,nsubjs).*2];
        fprintf('%s- HVA - %s\n', namesTuningC_all{ifamily}{iparam}, print_nANOVA({'Location','practice'}, data, {loc,bin}));

        data_loc1 = squeeze(mean(tuningC([5], isubj2, [1 nBins], itype, iparam),[1]));
        data_loc2 = squeeze(mean(tuningC([3], isubj2, [1 nBins], itype, iparam),[1]));
        data = [data_loc1(:)', data_loc2(:)'];
        loc = [ones(1,nsubjs*2), ones(1,nsubjs*2).*2];
        bin = [ones(1,nsubjs), ones(1,nsubjs).*2, ones(1,nsubjs), ones(1,nsubjs).*2];
        fprintf('%s- VMA - %s\n', namesTuningC_all{ifamily}{iparam}, print_nANOVA({'Location','practice'}, data, {loc,bin}));

%         data = [];
%         loc = [];
%         for iLoc = 1:5
%             data = [data, squeeze(tuningC(iLoc, isubj2, nBins, itype, iparam)-tuningC(iLoc, isubj2, 1, itype, iparam))];
%             loc = [loc, ones(1,nsubjs).*iLoc];
%         end
%         fprintf('%s- Differential Effects - %s\n', namesTuningC_all{ifamily}{iparam}, print_nANOVA({'loc'}, data, {loc}));
    end
end