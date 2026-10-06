for iiLoc = 1:nLoc8
    close all
    %('Position', [2000 500 2000 800])
   plotColors = colorGradient(iiLoc,:);
   if iiLoc == 1
       plotColors = {[.5, .5, .5],...          %Fovea
                [0, 0, 0],...
                [0, 0, 0],...
                [0, 0, 0]};
   end
   if iiLoc == 2
%            plotColors = colorGradient(9,:);
        plotColors = {[156, 255, 156]./255,...          %Fovea '#9cff9c'
                [156, 255, 156]./255,...
                [0, RGB_gradient2(4), 0],...
                [0, RGB_gradient2(4), 0]};
   elseif iiLoc == 8, plotColors = colorGradient(10,:);
   end
%     figure('Units','normalized', 'Position', [0 -.1 .3 .5])
    for ifeature = 1%1:2
        switch ifeature
            case 1
                marg = margOri_Mean; margSE = margOri_SE; margPred = margPredOri_Mean; margPred_CI = margPredOri_SE; margR2_ = margR2_Ori;
            case 2
                marg = margSF_Mean; margSE = margSF_SE; margPred = margPredSF_Mean; margPred_CI = margPredSF_SE; margR2_ = margR2_SF;
        end

        for itype = itypes%3:ntypes
            figure('Units','normalized', 'Position', [0 0 .4 .5]), hold on

            for iBin = [1 3]%1:nBins                    
                txt = sprintf('%s', namesLocComb{iiLoc});
%                     title(txt)
                
                margPlot = squeeze(marg(iiLoc, iBin, itype, :));
                margPlotSE = squeeze(margSE(iiLoc, iBin, itype,:));
                margPredPlot = squeeze(margPred(iiLoc, iBin, itype, :));
                margPredPlotSE = squeeze(margPred_CI(iiLoc, iBin, itype, :, :));

                if iiLoc == 6
                    margPlot = squeeze(mean(marg([2 4], iBin, itype, :)));
                    margPlotSE = squeeze(mean(margSE([2 4], iBin, itype,:)));
                    margPredPlot = squeeze(mean(margPred([2 4], iBin, itype, :)));
                    margPredPlotSE = squeeze(mean(margPred_CI([2 4], iBin, itype, :, :)));
                elseif iiLoc == 7
                    margPlot = squeeze(mean(marg([5 3], iBin, itype, :)));
                    margPlotSE = squeeze(mean(margSE([5 3], iBin, itype,:)));
                    margPredPlot = squeeze(mean(margPred([5 3], iBin, itype, :)));
                    margPredPlotSE = squeeze(mean(margPred_CI([5 3], iBin, itype, :, :)));
                elseif iiLoc == 8
                    margPlot = squeeze(mean(marg(2:5, iBin, itype, :)));
                    margPlotSE = squeeze(mean(margSE(2:5, iBin, itype,:)));
                    margPredPlot = squeeze(mean(margPred(2:5, iBin, itype, :)));
                    margPredPlotSE = squeeze(mean(margPred_CI(2:5, iBin, itype, :, :)));
                end

                plot(axis_tuning{ifeature}, margPlot, '.', 'color', plotColors{iBin}, 'MarkerSize', 36);
                errorbar(axis_tuning{ifeature}, margPlot, margPlotSE, 'LineStyle', 'none', 'color', plotColors{iBin}, 'CapSize', 0)
                plot(axis_tuning{ifeature}, margPredPlot, '-', 'color', plotColors{iBin}, 'LineWidth', 6)
                x = [axis_tuning{ifeature}, flip(axis_tuning{ifeature})];
                y = [margPredPlot' + margPredPlotSE(3,:), flip(margPredPlot' - margPredPlotSE(4,:))];
                patch(x, y, plotColors{iBin}, 'FaceAlpha', .3, 'linestyle', 'none');
                if ifeature==1
                    ylim([-.05, .15])
%                         yline(margPred(iiLoc,1,itype,15),'--')
                    xline(0, '-','Color', [.5 .5 .5], 'LineWidth', 3)
                    yline(0, '-k', 'LineWidth', 3)
                    yticks([-.05 0 .05 .1 .15])
                    xticks([-90 -45 0 45 90])
%                         xticks(-90:5:90)
%                         xticks([])
%                         yticks([])
                    xlim([-90, 90])
%                         set(gca, 'xGrid', 'on')
    %                 plot(axis_tuning{ifeature}, margORI_gabor, '-k')
                else
                    ylim([-.02, .12])
                    yticks([0 .06 .12])
                    xticks(0:.5:2)
                    xticklabels(round(2.^(0:.5:2), 2))
%                         yline(max(margPred(iiLoc,1,itype,:)),'--')
                    xline(1, '-','Color', [.5 .5 .5], 'LineWidth', 3)
                    yline(0,'-k', 'LineWidth', 3)
    %                 plot(axis_tuning{ifeature}, margSF_gabor, '-k')
%                         xticks([])
%                         yticks([])
                    xlim([0,2])
                end
                set(findall(gcf, '-property', 'FontSize'), 'FontSize', 48)
%                     set(findall(gca, '-property', 'LineWidth'), 'LineWidth',3)
                set(gca().XAxis, 'LineWidth', 4)
                set(gca().YAxis, 'LineWidth', 4)
%                     set(gca().XAxis, 'TickLength', [0 0])
%                     set(gca().XAxis, 'TickLength', [0 0])
                if ifeature==1
%                         ylim([-.05, .15])
%                         xlim([-90, 90]);
                    mkdir(sprintf('%s/Animation/ORI/PDF/Bin_%d',dirName, iBin))
                    nameFileFigure = sprintf('%s/Animation/ORI/PDF/Bin_%d/%s_ORI.pdf',dirName, iBin, namesLocComb{iiLoc});
%                         exportgraphics(gcf,nameFileFigure, 'Resolution', 300)
                else
                    mkdir(sprintf('%s/Animation/SF/PDF/Bin_%d',dirName, iBin))
                    nameFileFigure = sprintf('%s/Animation/SF/PDF/Bin_%d/%s_SF.pdf',dirName, iBin, namesLocComb{iiLoc});
%                         exportgraphics(gcf,nameFileFigure, 'Resolution', 300)
%                         ylim([-.025, .075])
                end
            end
        end
%             pause
    end % end ifeature
end % end iiLoc
