flagAll = input('\nPlot all locations and save (1=YES 0=NO)? ');
locPlots = [6 5 3 1];
locPos = [1 2 3 4];
bins_all = [1 nBins];
itype = itypes;
if flagAll
%     for iloc = 1:4%1:nLoc8
        for ifeature = 1:2
            fprintf('Feature %d:\n', ifeature)
            if ifeature == 1
                tuningC = margTuningCharORI;
                tuningC_mean = margTuningCharOri_Mean;
                tuningC_SE = margTuningCharOri_SE;
                nparams = nORI_TuningC;
                ifamily = 1;
                ybounds = oriBoundsTuning;
                sem_dplot = [.18 40 .035];
                ytic = [0 .05 .1 .15 .2;
                        0 10 20 30 40;
                        -.04 -.02 0 .02 .04];
                    
%                 sem_dplot = [.125 .1 .65 0];
%                 ybounds(1,2) = .15;
            else
                tuningC = margTuningCharSF;
                tuningC_mean = margTuningCharSF_Mean;
                tuningC_SE = margTuningCharSF_SE;
                nparams = nSF_TuningC;
                ifamily = 2;
                ybounds = sfBoundsTuning;
                sem_dplot = [3.1 .13 .65 0];
                
                ytic = [1 1.5 2 2.5 3;
                        .025 .05 .075 .1 .125;
                        .2 .3 .4 .5 .6
                         0 1 2 3 4];
%                 sem_dplot = [3.1 .1 .65 0];
%                 ybounds(2,2) = .125;
            end

            for iparam = 1:nparams
                data = [];
                IVs = [];
                close all
                figure('Units', 'pixels', 'Position', [0, 0, 1280, 1280]), hold on
                
                for iloc = 1:length(locPlots)
                    plotColor = colorGradient(locPlots(iloc),:);
                    if locPlots(iloc) == 1, plotColor = colorGradient(9,:);
                    elseif locPlots(iloc) == 8, plotColor = colorGradient(10,:);
                    end
                    barObj = bar(locPos(iloc), squeeze(tuningC_mean(locPlots(iloc), [1 nBins], itype, iparam)), ...
                        'EdgeColor', plotColor{nBins}, 'FaceColor', plotColor{nBins}, 'BarWidth', .5); %, 'BarWidth', .5
                    
                    for ibins = 1:2
                        barObj(ibins).FaceColor = plotColor{bins_all(ibins)};
                        barObj(ibins).EdgeColor = plotColor{bins_all(ibins)};
                        errorbar(barObj(ibins).XEndPoints, squeeze(tuningC_mean(locPlots(iloc), bins_all(ibins), itype, iparam)), squeeze(tuningC_SE(locPlots(iloc),bins_all(ibins),itype,iparam)),...
                                    '.', 'Color', plotColor{nBins}, 'LineWidth', 1.5, 'CapSize', 0)
                                
                        for isubj = 1:nsubjs
                            %indvd data
%                             plot ([barObj(1).XEndPoints+.1,barObj(2).XEndPoints-.1], squeeze(tuningC(locPlots(iloc), isubj, [1 3], itype, iparam)), ...
%                                 'Color', [.75 .75 .75], 'LineWidth', 1.5, 'Marker', 'none', 'MarkerSize', markerFontSize_bar *.8)
                            
                            %SEM of the difference
                            plot([barObj(1).XEndPoints, barObj(2).XEndPoints], [sem_dplot(iparam), sem_dplot(iparam)], '-k', 'LineWidth', 1.5)
                            errorbar(locPos(iloc), sem_dplot(iparam), ...
                                    std(squeeze(tuningC(locPlots(iloc), :, nBins, itype, iparam) - tuningC(locPlots(iloc), :, 1, itype, iparam)))/sqrt(11),...
                                    '-k', 'LineWidth', 1.5, 'CapSize', 0)
                            
                            data = [data, squeeze(tuningC(locPlots(iloc), isubj, :, itype, iparam))'];
                            IVs = [IVs, 1:nBins];
                        end %end of isubj
                    end %end of ibins
                    [h,p,~,~] = ttest(squeeze(tuningC(locPlots(iloc), :, 1, itype, iparam)), squeeze(tuningC(locPlots(iloc), :, nBins, itype, iparam)), 'Alpha', .05/3, 'tail', 'left');
                    if h==1, txt1 = '*'; else, txt1 = ''; end
                    fprintf('Loc %d, iparam %d, %sp=%.3f\n', locPlots(iloc), iparam, txt1, p)
                end %end of iloc

%                 txt = print_nANOVA({'Loc'}, data, {IVs});
% 
%                 str = sprintf('TuningC %s [%s]: %s\n%s', namesLocComb{locPlots(iloc)}, namesFeature{ifeature}, namesTuningC_all{ifamily}{iparam}, txt);
%                 title(str)
                ylim(ybounds(iparam,:))
                yticks(ytic(iparam,:))
                xticks(locPos)
                xticklabels({'HM', 'LVM', 'UVM'})


                set(findall(gcf, '-property', 'FontSize'), 'FontSize',56)
                set(findall(gcf, '-property', 'LineWidth'), 'LineWidth',4)
                set(gca().XAxis, 'Color', [.5 .5 .5])
                set(gca().XAxis, 'TickLength', [0 0])
                set(gca().YAxis, 'Color', [.5 .5 .5])

                nameFileFigure = sprintf('%s/TuningC/%s_%s_%s.jpg', dirName, namesLocComb{locPlots(iloc)}, namesFeature{ifeature}, namesTuningC_all{ifamily}{iparam});
                if ~exist(sprintf('%s/TuningC', dirName), 'dir'), mkdir(sprintf('%s/TuningC', dirName)), end
%                 saveas(gcf,nameFileFigure)
            end %end of iparam
        end %end of ifeature
end %end of flagAll
