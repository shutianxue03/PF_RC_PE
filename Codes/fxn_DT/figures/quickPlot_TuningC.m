%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%

flagAll = input('\nPlot all locations and save (1=YES 0=NO)? ');
if flagAll
    for iloc = 1:nLoc8
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
else
    flagLocation = NaN;
    flagFeature = NaN;
    flagOri = NaN;
    flagSF = NaN;
    
    flagLocation = input('\nEnter location (1=FOVEA 2=LHM 3=UVM 4=RHM 5=LVM 6=HM 7=VM 8=PERIFOVEA 9=ALL): ');
    if flagLocation == 9, flagLocation = 1:8; end
    
    flagFeature = input('\nEnter feature to inspec (1=ORI 2=SF 3=ALL): ');
    switch flagFeature
        case 1
            flagOri = input('\nEnter tuningC to inspect (1=Peak Amplitude 2=Width 3=Bottom 4=ALL): ');
        case 2
            flagSF = input('\nEnter tuningC to inspect (1=Peak SF 2=Peak Amplitude 3=Width 4=Bottom 5=ALL): ');
        case 3
            flagFeature = 1:2;
            flagOri = input('\nEnter tuningC to inspect (1=Peak Amplitude 2=Width 3=Bottom 4=ALL): ');
            flagSF = input('\nEnter tuningC to inspect (1=Peak SF 2=Peak Amplitude 3=Width 4=Bottom 5=ALL): ');
    end
    
    if flagOri == 4, flagOri = 1:3; end
    if flagSF == 5, flagSF = 1:4; end
    
    for iLoc = 1:length(flagLocation)
        iiLoc = flagLocation(iLoc);
        plotColor = colorGradient(iiLoc,:);
        if iiLoc == 1, plotColor = colorGradient(9,:);
        elseif iiLoc == 8, plotColor = colorGradient(10,:);
        end
        
        for iFeature = 1:length(flagFeature)
            iiFeature = flagFeature(iFeature);
            if iiFeature == 1
                tuningList = flagOri;
                tuningC = margTuningCharORI;
                tuningC_mean = margTuningCharOri_Mean;
                tuningC_SE = margTuningCharOri_SE;
                nparams = nORI_TuningC;
                ifamily = 1;
                ybounds = oriBoundsTuning;
            end
            if iiFeature == 2
                tuningList = flagSF;
                tuningC = margTuningCharSF;
                tuningC_mean = margTuningCharSF_Mean;
                tuningC_SE = margTuningCharSF_SE;
                nparams = nSF_TuningC;
                ifamily = 2;
                ybounds = sfBoundsTuning;
            end
            
            for iTuning = 1:length(tuningList)
                iiTuning = tuningList(iTuning);
                
                data = [];
                IVs = [];
                close all
                figure('Units', 'pixels', 'Position', [0, 0, 1280, 1280]), hold on, box on
                
                for ibin = 1:nBins
                    barObj = bar(ibin, squeeze(tuningC_mean(iiLoc, ibin, itype, iiTuning)), ...
                        'EdgeColor', plotColor{ibin}, 'FaceColor', 'none');
                end %end of ibin

                errorbar(1:nBins, squeeze(tuningC_mean(iiLoc, :, itype, iiTuning)), squeeze(tuningC_SE(iiLoc,:,itype,iiTuning)),...
                     '.', 'Color', plotColor{nBins}, 'LineWidth', 1.5, 'CapSize', 0)
                for isubj = 1:nsubjs
                    plot ((1:nBins)-.25, squeeze(tuningC(iiLoc, isubj, :, itype, iiTuning)), ...
                        'Color', plotColor{nBins}, 'LineWidth', 1.5, 'Marker', markers_allSubj{isubj}, 'MarkerSize', markerFontSize_bar *.8)
                    data = [data, squeeze(tuningC(iiLoc, isubj, :, itype, iiTuning))'];
                    IVs = [IVs, 1:nBins];
                end %end of isubj

                txt = print_nANOVA({'Loc'}, data, {IVs});

                str = sprintf('TuningC %s [%s]: %s\n%s', namesLocComb{iiLoc}, namesFeature{iiFeature}, namesTuningC_all{ifamily}{iiTuning}, txt);
                title(str)
                ylim(ybounds(iiTuning,:))
                xticks(1:nBins)
                xticklabels({'Bin 1', 'Bin 2', 'Bin 3', 'Bin 4'})


                set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)
                set(findall(gcf, '-property', 'LineWidth'), 'LineWidth',lineSize)
                nameFileFigure = sprintf('%s/TuningC/%s_%s_%s.jpg', dirName, namesLocComb{iiLoc}, namesFeature{iiFeature}, namesTuningC_all{ifamily}{iiTuning});
                if ~exist(sprintf('%s/TuningC', dirName), 'dir'), mkdir(sprintf('%s/TuningC', dirName)), end
                saveas(gcf,nameFileFigure)
            end %end of iTuning
        end %end of iFeature
    end %end of iLoc
end %end of flagAll