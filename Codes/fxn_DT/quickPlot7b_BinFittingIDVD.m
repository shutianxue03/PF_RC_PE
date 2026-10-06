%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%
%% Plot marginalized over time
% close all
% 
% iiLoc = 1;
% %('Position', [2000 500 2000 800])
% for ifeature = 1:2
%     if iiLoc == 1, color = {colors_comb(3,:)}; else, color = {colors_comb(5,:)}; end
%     plotColors = {color{1}* 1,...
%                   color{1}*.8,...
%                   color{1}*.6,...
%                   color{1}*.4,...
%                   color{1}*.2,...
%                   color{1}*.1};
%     figure
%     switch ifeature
%         case 1, marg = margOri_Mean; margSE = margOri_SE; margPred = margPredOri_Mean; margPredSE = margPredOri_SE;
%         case 2, marg = margSF_Mean; margSE = margSF_SE; margPred = margPredSF_Mean; margPredSE = margPredSF_SE;
%     end
%     for itype = 1:ntypes
%         for iBin = 1:nBins
%             subplot(ntypes, nBins, (itype-1)*nBins+iBin), hold on
%             txt = sprintf('%s %s - %s', namesLocComb{iLocComb_all(iiLoc)}, namesFeature{ifeature}, namesType{itype});
%             title(txt)
% 
%             margPlot = squeeze(marg(iBin, iiLoc, itype, :));
%             margPredPlot = squeeze(margPred(iBin, iiLoc, itype, :));
%             margPredPlotSE = squeeze(margPredSE(iBin,iiLoc, itype, :, :));
% 
%             plot(axis_tuning{ifeature}, margPlot, '.', 'color', plotColors{iBin}, 'MarkerSize', 8);
%             errorbar(axis_tuning{ifeature}, margPlot, squeeze(margSE(iBin, iiLoc, itype, :)), 'LineStyle', 'none', 'color', plotColors{iBin}, 'CapSize',0)
%             plot(axis_tuning{ifeature}, margPredPlot, '-', 'color', plotColors{iBin}, 'LineWidth', 2)
%             % errorbar(axis_tuning{ifeature}, margPredPlot, squeeze(margPredPlotSE(3, :)), 'LineStyle', 'none', 'color', plotColors{iBin})
%             x = [axis_tuning{ifeature}, flip(axis_tuning{ifeature})];
%             y = [margPredPlotSE(1,:), flip(margPredPlotSE(2,:))];
%             patch(x, y, plotColors{iBin}, 'FaceAlpha', .3, 'linestyle', 'none');
%             if ifeature==1
%                 ylim([-.05, .3])
%                 yline(margPred(1,iiLoc,itype,15),'--')
%                 xline(0, '--')
%             else
%                 ylim([-.05, .2])
%                 xticks(0:.5:2)
%                 xticklabels(round(2.^(0:.5:2), 2))
%                 yline(margParamSF_Mean(1,iiLoc,itype,2),'--')
%                 xline(1, '--')
%             end
%         end
%     end
%     set(findall(gcf, '-property', 'FontSize'), 'FontSize',12)
% end
% 
% sgtitle(sprintf('Tuning Curves over time %s', namesFeature{ifeature}))

%% Plot individual
%('Position', [2000 500 2000 800])
close all

for itype = 3:ntypes
    for iLoc = 1:2
        for ifeature = 1:2
            if iLoc == 1, plotColors = colorGradient(iLocComb_all(1),:); else, plotColors = colorGradient(iLocComb_all(2),:);end

            switch ifeature
                case 1, marg = margOri; margPred = margPredOri;
                case 2, marg = margSF; margPred = margPredSF;
            end
            for isubj = 1:nsubjs
                close all
                figure ('Units', 'normalized', 'Position',[0,0,1,.3])
                for iBin = 1:nBins
                    subplot(1, nBins, iBin), hold on
                    txt = sprintf('%s %s - Subj %s[%s]', namesLocComb{iLocComb_all(iLoc)}, namesFeature{ifeature}, subjList{isubj}, namesType{itype});
                    title(txt)
        
                    margPlot = squeeze(marg(isubj,iBin, iLoc, itype, :));
                    margPredPlot = squeeze(margPred(isubj,iBin, iLoc, itype, :));
        
                    plot(axis_tuning{ifeature}, margPlot, '.', 'color', plotColors{iBin}, 'MarkerSize', 8);
                    plot(axis_tuning{ifeature}, margPredPlot, '-', 'color', plotColors{iBin}, 'LineWidth', 2)
                    if ifeature==1
                        ylim([-.05, .3])
                        yline(margPred(isubj, 1,iLoc,itype,15),'--')
                        xline(0, '--')
                        yline(0)
                    else
                        ylim([-.05, .2])
                        xticks(0:.5:2)
                        xticklabels(round(2.^(0:.5:2), 2))
                        yline(margParamsSF(isubj,1,iLoc,itype,2),'--')
                        xline(1, '--')
                        yline(0)
                    end
                end
            set(findall(gcf, '-property', 'FontSize'), 'FontSize',12)
            sgtitle(sprintf('Tuning Curves over time %s [%s]', namesFeature{ifeature}, subjList{isubj}))
    
            locationName = namesLocComb{iLocComb_all(iLoc)};
            featureName = namesFeature{ifeature};
            nameFileFigure = sprintf('figs/Perceptual Learning RC/%s/%s/Individual Data/%s/%s/IDVD_%s_subj_%d.jpg', ...
                                    locName, folderName, locationName, namesType{itype},featureName,isubj);
            saveas(gcf,nameFileFigure)
            end
        end
    end
end