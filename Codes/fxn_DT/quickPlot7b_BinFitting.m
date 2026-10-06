%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%
close all
nlines = 2;

%('Position', [2000 500 2000 800])
for iline = 1:nlines
   if iline == 1, plotColors = colorGradient(iLocComb_all(1),:); else, plotColors = colorGradient(iLocComb_all(2),:);end
   if iLocComb_all(iline) == 1, plotColors = colorGradient(9,:); elseif iLocComb_all(iline) == 8, plotColors = colorGradient(10,:); end
%     figure('Units','normalized', 'Position', [0 -.1 .3 .5])
    for ifeature = 1:2
        switch ifeature
            case 1, marg = margOri_Mean; margSE = margOri_SE; margPred = margPredOri_Mean; margPredSE = margPredOri_SE;
            case 2, marg = margSF_Mean; margSE = margSF_SE; margPred = margPredSF_Mean; margPredSE = margPredSF_SE;
        end
        
        for itype = 3:ntypes
            figure('Units','normalized', 'Position', [0 -.1 .3 .5]), hold on
            txt = sprintf('%s %s - %s', namesLocComb{iLocComb_all(iline)}, namesFeature{ifeature}, namesType{itype});
            title(txt)
            if ifeature==1
                ylim([-.05, .2])
                yline(margPred(1,iline,itype,15),'--')
                xline(0, '--')
                yline(0, '-k')
%                 plot(axis_tuning{ifeature}, margORI_gabor, '-k')
            else
                ylim([-.05, .1])
                xticks(0:.5:2)
                xticklabels(round(2.^(0:.5:2), 2))
                yline(max(margPred(1,iline,itype,:)),'--')
                xline(1, '--')
                yline(0,'-k')
%                 plot(axis_tuning{ifeature}, margSF_gabor, '-k')
            end

            for iBin = 1:nBins
                margPlot = squeeze(marg(iBin, iline, itype, :));
                margPlotSE = squeeze(margSE(iBin,iline, itype,:));
                margPredPlot = squeeze(margPred(iBin, iline, itype, :));
                margPredPlotSE = squeeze(margPredSE(iBin,iline, itype, :, :));

                plot(axis_tuning{ifeature}, margPlot, '.', 'color', plotColors{iBin}, 'MarkerSize', 8);
                errorbar(axis_tuning{ifeature}, margPlot, margPlotSE, 'LineStyle', 'none', 'color', plotColors{iBin}, 'CapSize', 0)
                plot(axis_tuning{ifeature}, margPredPlot, '-', 'color', plotColors{iBin}, 'LineWidth', 2)
                x = [axis_tuning{ifeature}, flip(axis_tuning{ifeature})];
                y = [margPredPlot' + margPredPlotSE(3,:), flip(margPredPlot' - margPredPlotSE(3,:))];
                patch(x, y, plotColors{iBin}(1:3), 'FaceAlpha', .3, 'linestyle', 'none');
                if ifeature==1
                    ylim([-.05, .2])
                    xlim([-90, 90]);
                    nameFileFigure = sprintf('figs/Perceptual Learning RC/%s/%s/Animation/%s/ORI/T%d_%s_ORI.jpg',locName, folderName, namesLocComb{iLocComb_all(iline)}, iBin, namesLocComb{iLocComb_all(iline)});
                    saveas(gcf,nameFileFigure)
                else
                    nameFileFigure = sprintf('figs/Perceptual Learning RC/%s/%s/Animation/%s/SF/T%d_%s_SF.jpg',locName, folderName, namesLocComb{iLocComb_all(iline)}, iBin, namesLocComb{iLocComb_all(iline)});
                    saveas(gcf,nameFileFigure)
                    ylim([-.05, .1])
                end
            end
        end
        set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)
    end
    
%     sgtitle('Kernel Fitting')
end

