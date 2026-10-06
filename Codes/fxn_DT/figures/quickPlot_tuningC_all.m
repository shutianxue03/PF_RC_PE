%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%

itype = itypes;

for iloc = 1:5%1:nLoc8
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
            for ibin = 1:nBins
                barObj = bar(ibin, squeeze(tuningC_mean(iloc, ibin, itype, iparam)), ...
                    'EdgeColor', plotColor{ibin}, 'FaceColor', 'none');
            end %end of ibin

            errorbar(1:nBins, squeeze(tuningC_mean(iloc, :, itype, iparam)), squeeze(tuningC_SE(iloc,:,itype,iparam)),...
                 '.', 'Color', plotColor{nBins}, 'LineWidth', 1.5, 'CapSize', 0)
            for isubj = 1:nsubjs
                plot ((1:nBins)-.25, squeeze(tuningC(iloc, isubj, :, itype, iparam)), ...
                    'Color', plotColor{nBins}, 'LineWidth', 1.5, 'Marker', markers_allSubj{isubj}, 'MarkerSize', markerFontSize_bar *.8)
                data = [data, squeeze(tuningC(iloc, isubj, :, itype, iparam))'];
                IVs = [IVs, 1:nBins];
            end %end of isubj
            
            txt = print_nANOVA({'Loc'}, data, {IVs});

            str = sprintf('TuningC %s [%s]: %s\n%s', namesLocComb{iloc}, namesFeature{ifeature}, namesTuningC_all{ifamily}{iparam}, txt);
            title(str)
            ylim(ybounds(iparam,:))
            xticks(1:nBins)
            xticklabels({'Bin 1', 'Bin 2', 'Bin 3', 'Bin 4'})
            

            set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)
            set(findall(gcf, '-property', 'LineWidth'), 'LineWidth',lineSize)
            nameFileFigure = sprintf('%s/TuningC/%s_%s_%s.jpg', dirName, namesLocComb{iloc}, namesFeature{ifeature}, namesTuningC_all{ifamily}{iparam});
            if ~exist(sprintf('%s/TuningC', dirName), 'dir'), mkdir(sprintf('%s/TuningC', dirName)), end
            saveas(gcf,nameFileFigure)
        end %end of iparam
    end %end of ifeature
end %end of iloc

%% Plot TTests
for iloc = 5%1:nLoc8
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
%             title(str)
            fprintf(str)
            ylim(ybounds(iparam,:))
            xticks(1:2)
            xticklabels({'Bin 1', 'Bin 4'})
            
            if ifeature == 1 && iparam == 3, yline(0, '-k', 'LineWidth', 2.5)
            elseif ifeature == 2 && iparam ==4, yline(0, '-k', 'LineWidth', 2.5)
            end

            set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)
            set(findall(gcf, '-property', 'LineWidth'), 'LineWidth',lineSize)
            nameFileDir = sprintf('%s/TuningCTTests', dirName);
            if ~(exist(nameFileDir, 'dir')), mkdir(nameFileDir); end
            nameFileFigure = sprintf('%s/TuningCTTests/%s_%s_%s.jpg', dirName, namesLocComb{iloc}, namesFeature{ifeature}, namesTuningC_all{ifamily}{iparam});
            saveas(gcf,nameFileFigure)
        end %end of iparam
    end %end of ifeature
end %end of iloc

%% Scatter Plot Params
nameFileDir = sprintf('%s/TuningCTTests/ScatterPlots', dirName);
if ~(exist(nameFileDir, 'dir')), mkdir(nameFileDir); end
for ifeature = 1:2
    close all
    if ifeature == 1
        marg_ = margTuningCharORI; 
        xlim_allM = [-.2,.2; -30, 30; -.1, .1];
        ci = margParamsOri_CI;
        iF = 1;
%         xlim_allM2 = [.2; 30;.025];
    else
        marg_ = margTuningCharSF;
        xlim_allM = [-1,1; -.1,.1; -2.5,2.5; -.1, .1; -.1, .1];
        ci = margParamsSF_CI;
        iF = 3;
%         xlim_allM2 = [3*.8;.1;2;.04;.05*.8];
    end
    for iLoc = 1:8
        plotColor = colorGradient(iLoc,:);
        if iLoc == 1, plotColor = colorGradient(9,:);
        elseif iLoc == 8, plotColor = colorGradient(10,:);
        end
        for iparam = 1:size(marg_,5)
            figure ('Units', 'pixels', 'Position', [0, 0, 1280, 1280]), hold on, box on
            bins1 = squeeze(marg_(iLoc,:,1,itype,iparam));
            bins2 = squeeze(marg_(iLoc,:,4,itype,iparam));
            center = mean(marg_(iLoc,:,[1 4],itype,iparam),'all');
        
            for isubj = 1:nsubjs
                errorbar(bins1(isubj) - center, bins2(isubj) - center,...
                    ci(iLoc,isubj,4,itypes,iparam,1), ci(iLoc,isubj,4,itypes,iparam,2), ...
                    ci(iLoc,isubj,1,itypes,iparam,1), ci(iLoc,isubj,1,itypes,iparam,2), ...
                    'CapSize', 0, 'Color', plotColor{nBins}, 'LineWidth', lineSize)
            end

            for isubj = 1:nsubjs
                plot(bins1(isubj) - center, bins2(isubj) - center, sprintf('%s', markers_allSubj{isubj}), ...
                    'MarkerSize', markerFontSize, 'MarkerFaceColor', 'w', ...
                    'Color', plotColor{nBins});
            end

            plot((-50):.05:50, (-50):.05:50, '-k')
            
            if ifeature == 1, iifeature = 1; else, iifeature = 2; end
            title(sprintf('%s', namesTuningC_all{iifeature}{iparam}))
            ylim(xlim_allM(iparam, :))
            xlim(xlim_allM(iparam, :))
            xlabel('Bin 1')
            ylabel('Bin 4')

            axis square

            set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)
            nameFileFigure = sprintf('%s/%s_%s_%s_scatterPlot.jpg', ...
                nameFileDir, namesLocComb{iLoc}, namesFeature{ifeature}, namesTuningC_all{iF}{iparam});
            saveas(gcf,nameFileFigure)
        end %end of iparam
    end %end of iLoc
end %end of ifeature

%% for gain estParam
for iloc = 8%1:nLoc8
    for ifeature = 1:2
        if ifeature == 1
            estParam = squeeze(margParamsOri(:,:,:,3,1));
            estParam_mean = squeeze(margOri_Mean(:,:,3,1));
            estParam_SE = squeeze(margOri_SE(:,:,3,1));
            ifamily = 1;
            ybounds = [0,.2];
            iparam = 1;
        else
            estParam = squeeze(margParamsSF(:,:,:,3,2));
            estParam_mean = squeeze(margSF_Mean(:,:,3,2));
            estParam_SE = squeeze(margSF_SE(:,:,3,2));
            ifamily = 3;
            ybounds = [0,.15];
            iparam = 2;
        end

        plotColor = colorGradient(iloc,:);
        if iloc == 1, plotColor = colorGradient(9,:);
        elseif iloc == 8, plotColor = colorGradient(10,:);
        end
        
        data = [];
        IVs = [];
        close all
        figure('Units', 'pixels', 'Position', [0, 0, 1280, 1280]), hold on, box on
        barObj = bar(1, mean(squeeze(estParam(iloc, :, 1))), ...
            'EdgeColor', plotColor{1}, 'FaceColor', 'none');
        barObj = bar(2, mean(squeeze(estParam(iloc, :, 4))), ...
            'EdgeColor', plotColor{4}, 'FaceColor', 'none');

        errorbar(1:2, squeeze(mean(estParam(iloc, :, [1,4]))), estParam_SE(iloc, [1,4]),...
             '.', 'Color', plotColor{4}, 'LineWidth', 1.5, 'CapSize', 0)
        for isubj = 1:nsubjs
            plot ((1:2)-.25, squeeze(estParam(iloc, isubj, [1,4])), ...
                'Color', plotColor{4}, 'LineWidth', 1.5, 'Marker', markers_allSubj{isubj}, 'MarkerSize', markerFontSize_bar *.8)
        end %end of isubj

        [h,p,~,stats] = ttest(squeeze(estParam(iloc, :, 1)), squeeze(estParam(iloc, :, 4)), 'Alpha', .05);
        if h == 1, txt1 = '*'; else, txt1 = ''; end

        str = sprintf('TuningC %s [%s]: %s\nt(%d)=%0.2f, p=%0.2f%s', ...
            namesLocComb{iloc}, namesFeature{ifeature}, namesParams_all{ifamily}{iparam}, stats.df, stats.tstat, p,txt1);
        title(str)
        ylim(ybounds)
        xticks(1:2)
        xticklabels({'Bin 1', 'Bin 4'})
        

        set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)
        set(findall(gcf, '-property', 'LineWidth'), 'LineWidth',lineSize)
        if ~exist(sprintf('%s/estParams', dirName), 'dir'), mkdir(sprintf('%s/estParams', dirName)), end
        nameFileFigure = sprintf('%s/estParams/%s_%s_%s.jpg', dirName, namesLocComb{iloc}, namesFeature{ifeature}, namesTuningC_all{ifamily}{iparam});
        saveas(gcf,nameFileFigure)
    end %end of ifeature
end %end of iloc