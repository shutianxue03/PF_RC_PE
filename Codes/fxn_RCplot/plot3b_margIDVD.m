sz_font = 10;

for ifeature=1:2
    if ifeature == 1
        ylim_tuning = [-.05, .2]; % left y-axis, limit
        ytext_R2 = [.19, .17, .15]; % left y-axis, the height of R2 for two loc
        marg_allSubj = margORI_allSubj;
        margPred_allSubj = margPredORI_allSubj;
        margR2_allSubj = margR2ORI_allSubj;
    else
        ylim_tuning = [-.05, .15];
        ytext_R2 = [.14,  .12, .1]; % left y-axis, the height of R2 for two loc
        marg_allSubj = margSF_allSubj;
        margPred_allSubj = margPredSF_allSubj;
        margR2_allSubj = margR2SF_allSubj;
    end
    
    xaxis = axis_tuning{ifeature};
    nfilters = length(xaxis);
    
    for iiLoc = 1:nLoc2 % or for iBin = 1:nBins %
        figure('Position', [0, 0, 2e3, 1.8e3])
        
        for isubj = 1:nsubj
            subjName = subjList{isubj};
            
            subplot(3,5, isubj), hold on
            for iBin = 1:nBins % or for iiLoc = 1:nLoc2
                color = colors_perBinPerComb{iBin, iLocComb_all(iiLoc)};
                [marg_med, ~, ~, marg_CI_neg, marg_CI_pos] = getCI(marg_allSubj(isubj, :, iBin, iiLoc, itype, :), 1, 2);
                [margPred_med, margPred_lb, margPred_ub, ~, ~] = getCI(margPred_allSubj(isubj, :, iBin, iiLoc, itype, :), 1, 2);
                [~, margR2_lb, margR2_ub] = getCI(margR2_allSubj(isubj, :, iBin, iiLoc, itype), 1, 2);
                
                % extra lines
                yline(0, 'handlevisibility', 'off', 'linewidth', 1, 'color', [.7, .7, .7]);
                xline(ifeature-1, 'handlevisibility', 'off', 'linewidth', 1, 'color', [.7, .7, .7]);
                
                % plot kernels
                errorbar(xaxis, marg_med, marg_CI_neg, marg_CI_pos, 'color', color, 'CapSize',0, 'linestyle', 'none', 'linewidth', 2)
                %         plot(xaxis, marg_med, 'o', 'color', color,'MarkerEdgeColor', 'w' ,'linewidth', 1)
                
                % plot tuning fxn
                xaxis_itp = xaxis;
                plot(xaxis_itp, margPred_med', '-', 'color', color, 'linewidth', 2)
                %         patch([xaxis_itp, flip(xaxis_itp)], [margPred_lb', flip(margPred_ub')], color, 'FaceAlpha', .3, 'linestyle', 'none')
                
                % R2
                xtext_R2 = xaxis(18);
                text(xtext_R2, ytext_R2(iBin), sprintf('R^2 = [%d%%, %d%%]', round(margR2_lb*100), round(margR2_ub*100)), 'color', color)
                
            end % end of iiLoc
            
            % yaxis
            ylim(ylim_tuning)%, yticks(round(linspace(ylim_tuning(1), ylim_tuning(2), 5), 2))
            
            % xaxis
            xlim(axisLim{ifeature})
            xticks(axisTicks_tuning{ifeature})
            xticklabels(axisTL_tuning{ifeature})
            
            if isubj>1, xticklabels([]), yticklabels([]), end
            
            title(sprintf('S%d', isubj))
            
        end % isubj
        
        sgtitle(sprintf('n%d %s %s L%d', nsubj, binStrategy, namesType{itype}, iLocComb_all(iiLoc)))
        set(findall(gcf, '-property', 'fontsize'), 'fontsize', sz_font)
        saveas(gcf, sprintf('%s/n%d_%s_L%d_%s.jpg', nameFigFolder_RC_margIDVD, nsubj, namesFeature{ifeature}, iLocComb_all(iiLoc), namesType{itype}))
    end % iiLoc
    
end % ifeature