%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%

%% Plot TTests
clc
itype = 3;
for ifeature = 1:2
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
        ifamily = 3;
        ybounds = sfBoundsTuning;
    end
    for iparam = 1:nparams
        close all
        figure('Units', 'pixels', 'Position', [0, 0, 1280, 1280]), hold on%, box on
        for iloc = 1:5%1:nLoc8
            plotColor = colorGradient(iloc,:);
            if iloc == 1, plotColor = colorGradient(9,:);
            elseif iloc == 8, plotColor = colorGradient(10,:);
            end
            data = [];
            IVs = [];
            
            barObj = bar(iloc, squeeze(tuningC_mean(iloc, [1 nBins], itype, iparam)), ...
                'EdgeColor', plotColor{nBins}, 'FaceColor', plotColor{1});
            barObj(2).FaceColor = plotColor{nBins};

            errorbar(barObj(1).XEndPoints, squeeze(tuningC_mean(iloc, [1], itype, iparam)), squeeze(tuningC_SE(iloc,[1],itype,iparam)),...
                 '.', 'Color', plotColor{nBins}, 'LineWidth', 1.5, 'CapSize', 0)
            errorbar(barObj(2).XEndPoints, squeeze(tuningC_mean(iloc, [nBins], itype, iparam)), squeeze(tuningC_SE(iloc,[nBins],itype,iparam)),...
                 '.', 'Color', plotColor{nBins}, 'LineWidth', 1.5, 'CapSize', 0)
%             for isubj = 1:nsubjs
%                 plot ((1:2)-.25, squeeze(tuningC(iloc, isubj, [1,nBins], itype, iparam)), ...
%                     'Color', plotColor{nBins}, 'LineWidth', 1.5, 'Marker', markers_allSubj{isubj}, 'MarkerSize', markerFontSize_bar *.8)
%             end %end of isubj

            [h,p,~,stats] = ttest(squeeze(tuningC(iloc, :, nBins, itype, iparam)), squeeze(tuningC(iloc, :, 1, itype, iparam)), 'Alpha', .05);
            if h == 1, txt1 = '*'; else, txt1 = ''; end
            
            ploc = nan(2,4,5);
            ploc(1,[1 2 3],:) = [.11, .075, .075, .1, .11;
                                 30, 35, 30, 25, 30;
                                 .01 .01 .01 .01 .01];
            ploc(2,:,:) = [2.2 2 2 2 2;
                           .07, .07, .05, .07, .07;
                           .5, .5, .5, .5, .5;
                           .025 .025 .025 .025 .025];

            plot([barObj(1).XEndPoints, barObj(2).XEndPoints], [ploc(ifeature, iparam, iloc) ploc(ifeature, iparam, iloc)], '-k', 'LineWidth', 1.5)
            errorbar(iloc, ploc(ifeature, iparam, iloc), std(squeeze(tuningC(iloc, :, nBins, itype, iparam)) - squeeze(tuningC(iloc, :, 1, itype, iparam)))/sqrt(11), '-k', 'LineWidth', 1.5, 'CapSize', 0)

            str = sprintf('TuningC %s [%s]: %s\nt(%d)=%0.2f, p=%0.2f%s\n', ...
                namesLocComb{iloc}, namesFeature{ifeature}, namesTuningC_all{ifamily}{iparam}, stats.df, stats.tstat, p,txt1);
%             title(str)
            fprintf(str)
            ylim(ybounds(iparam,:))
            yticks(linspace(ybounds(iparam,1), ybounds(iparam,2), 5))
            xticks([])
            if ifeature == 1 && iparam == 3, yline(0, '-k', 'LineWidth', 2.5)
            elseif ifeature == 2 && iparam ==4, yline(0, '-k', 'LineWidth', 2.5)
            end
            
        end %end of iloc
        set(findall(gcf, '-property', 'FontSize'), 'FontSize',56)
        set(findall(gcf, '-property', 'LineWidth'), 'LineWidth',2.5)
        set(gca().XAxis, 'Color', [.75 .75 .75])
        set(gca().YAxis, 'Color', [.75 .75 .75])
        nameFileDir = sprintf('%s/TuningCTTests_all', dirName);
        if ~(exist(nameFileDir, 'dir')), mkdir(nameFileDir); end
        nameFileFigure = sprintf('%s/TuningCTTests_all/%s_%s.jpg', dirName, namesFeature{ifeature}, namesTuningC_all{ifamily}{iparam});
        exportgraphics(gcf,nameFileFigure, 'Resolution', 300)
    end %end of iparam
end %end of ifeature