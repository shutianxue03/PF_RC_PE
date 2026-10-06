%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%
for iloc = 1:5%nLoc8
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

        plotColor = colorGradient(iloc,:);
        if iloc == 1, plotColor = colorGradient(9,:);
        elseif iloc == 8, plotColor = colorGradient(10,:);
        end
        for iparam = 1:nparams
            data = [];
            IVs = [];
            close all
            figure('Units', 'pixels', 'Position', [0, 0, 1280, 1280]), hold on, box on
            barObj = bar(1, squeeze(tuningC_mean(iloc, 1, itype, iparam)), ...
                'EdgeColor', plotColor{1}, 'FaceColor', 'none');
            barObj = bar(2, squeeze(tuningC_mean(iloc, nBins, itype, iparam)), ...
                'EdgeColor', plotColor{nBins}, 'FaceColor', 'none');

            errorbar(1:2, squeeze(tuningC_mean(iloc, [1,nBins], itype, iparam)), squeeze(tuningC_SE(iloc,[1,nBins],itype,iparam)),...
                 '.', 'Color', plotColor{nBins}, 'LineWidth', 1.5, 'CapSize', 0)
            for isubj = 1:nsubjs
                plot ((1:2)-.25, squeeze(tuningC(iloc, isubj, [1,nBins], itype, iparam)), ...
                    'Color', plotColor{nBins}, 'LineWidth', 1.5, 'Marker', markers_allSubj{isubj}, 'MarkerSize', markerFontSize_bar *.8)
            end %end of isubj

            [h,p,~,stats] = ttest(squeeze(tuningC(iloc, :, 1, itype, iparam)), squeeze(tuningC(iloc, :, nBins, itype, iparam)), 'Alpha', .05);
            if h == 1, txt1 = '*'; else, txt1 = ''; end

            str = sprintf('TuningC %s [%s]: %s\nt(%d)=%0.2f, p=%0.2f%s', ...
                namesLocComb{iloc}, namesFeature{ifeature}, namesTuningC_all{ifamily}{iparam}, stats.df, stats.tstat, p,txt1);
        fprintf('%s\n'str)    
	title(str)
            ylim(ybounds(iparam,:))
            xticks(1:2)
            xticklabels({'Bin 1', 'Bin 4'})
            

            set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)
            set(findall(gcf, '-property', 'LineWidth'), 'LineWidth',lineSize)
            nameFileDir = sprintf('%s/TuningCTTests', dirName);
            if ~(exist(nameFileDir, 'dir')), mkdir(nameFileDir); end
            nameFileFigure = sprintf('%s/TuningCTTests/%s_%s_%s.jpg', dirName, namesLocComb{iloc}, namesFeature{ifeature}, namesTuningC_all{ifamily}{iparam});
            exportgraphics(gcf,nameFileFigure, 'Resolution', 300)
        end %end of iparam
    end %end of ifeature
end %end of iloc
