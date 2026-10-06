%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%
close all
nlines = 2;
%('Position', [2000 500 2000 800])
figure
for ifeature = 1:2
    switch ifeature
%         case 1, marg = margORI_allB; margPred = margPredORI_allB;
%         case 2, marg = margSF_allB; margPred = margPredSF_allB;
        case 1, marg = margOri; margPred = margPredOri;
        case 2, marg = margSF; margPred = margPredSF;
    end
    
    for itype = 3:ntypes
        for iLoc = 1:nlines
            if iLoc == 1, plotColors = colorGradient(iLocComb_all(1),:); else, plotColors = colorGradient(iLocComb_all(2),:);end
            subplot(2, nlines, (ifeature-1)*nlines + iLoc), hold on
            title(namesFeature{ifeature})
            for iBin = nBins:nBins
                [margPredRefit, ~] = fxn_refitKernels(squeeze(marg(:,iBin,iLoc,itype,:)),ifeature, lb_full_all, ub_full_all, axis_tuning{ifeature});
                plot(axis_tuning{ifeature}, mean(squeeze(marg(:,iBin, iLoc, itype, :)),1), '.-', 'Color', plotColors{iBin})
%                 plot(axis_tuning{ifeature}, squeeze(margPred(:,iBin,iLoc,itype,:)), '-', 'Color', plotColors{iBin})
                plot(axis_tuning{ifeature}, margPredRefit, '-', 'Color', plotColors{iBin}, 'LineWidth', 2)
            end
            if ifeature==1
                ylim([-.05, .25])
                xlim([-90, 90])
                yline(0, '-k')
            else
                ylim([-.05, .16])
                xticks(0:.5:2)
                xticklabels(round(2.^(0:.5:2), 2))
                yline(0,'-k')
            end
%             axis square
        end
    end
    set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)
end

sgtitle('Kernel Fitting')

