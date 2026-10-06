
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot all bins in one figure, and diff loc in separate figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wd_border = 4; % default 5
sz_ticks = 30;% default 35

shift = [0,0];

for ifeature = 1:2
    
    if ifeature==1,
        if iLocComb_all(1)==1 && iiLoc==1, yticks_ = [-.03, linspace(0, .18, 4)]; % fov vs. peri, higher ub
        else, yticks_ = [-.02, linspace(0, .12, 4)];
        end
    else,
        if iLocComb_all(1)==1 && iiLoc==1, yticks_ = [-.01, linspace(0, .12, 4)];
        else, yticks_ = [-.01, linspace(0, .07, 4)]; %[-.02, 0, .02, .04, .06];
        end
    end
    
    ymax = max(yticks_);
    ymin = min(yticks_);
    
    xaxis = axis_tuning{ifeature};
    nFilters = length(xaxis);

    if ifeature == 1
        [marg_med, marg_CI_lb, marg_CI_ub, marg_neg, marg_pos] = getCI(margORI_allSubj(:, :, :, :, itype, :), 1, 2);
        [margPred_med, margPred_CI_lb, margPred_CI_ub] = getCI(margPredORI_allSubj(:, :, :, :, itype, :), 1, 2);
        [margR2_med, margR2_neg, margR2_pos] = getCI(margR2ORI_allSubj(:, :, :, :, itype), 1, 2);
        
    else
        [marg_med, marg_CI_lb, marg_CI_ub, marg_neg, marg_pos] = getCI(margSF_allSubj(:, :, :, :, itype, :), 1, 2);
        [margPred_med, margPred_CI_lb, margPred_CI_ub] = getCI(margPredSF_allSubj(:, :, :, :, itype, :), 1, 2);
        [margR2_med, ~, ~, margR2_neg, margR2_pos]  = getCI(margR2SF_allSubj(:, :, :, :, itype), 1, 2);
        
        %         peakSF_log_med = getCI(log2(margTuningC_SF_allSubj(:, :, :, itype, 1)), 1, 2);
        %         [peakSF_log_ave, peakSF_log_lb, peakSF_log_ub] = getCI(peakSF_log_med, 2, 1);
        %         peakAmp_med = getCI(margTuningC_SF_allSubj(:, :, :, itype, 2), 1, 2);
        %         peakAmp_ave = getCI(peakAmp_med, 2, 1);
    end
    
    %% plot kernels & tuning fxn
    figure('Position', [0 0 1.1e3 8e2]) % default 8e2
    hold on%, box on
    
    % ref lines
    yline(0, 'handlevisibility', 'off', 'linewidth', wd_border, 'color', [.7, .7, .7]);
    xline(ifeature-1, 'handlevisibility', 'off', 'linewidth', wd_border, 'color', [.7, .7, .7]);
    
    iiBin=1;
    margR2_ave2 = []; margR2_SEM2=[];
    for iBin = indBins
        color = colors_perBinPerComb{iBin, iLocComb_all(iiLoc)};

        [marg_ave, ~, ~, marg_SEM_neg, marg_SEM_pos] = getCI(marg_med(:, iBin, iiLoc, :), 2, 1);
        [margPred_ave, margPred_lb, margPred_ub, ~, ~] = getCI(margPred_med(:, iBin, iiLoc, :), 2, 1);
        [margR2_ave, ~, ~, margR2_SEM, ~] = getCI(margR2_med(:, iBin, iiLoc), 2, 1);

        margR2_ave2(iiBin) = margR2_ave;
        margR2_SEM2(iiBin) = margR2_SEM;
        iiBin = iiBin+1;
        
        % plot raw data
        if nBins==3
            if flag_plotIDVD
                for isubj = 1:nsubj
                    plot(xaxis, squeeze(margPred_med(isubj, iBin, iiLoc, :)), 'color', color, 'linewidth', 1)
                end
            end
            
            plot(xaxis, marg_ave, 'o', 'linestyle', 'none', 'markersize', 1/sqrt(nFilters)*50, 'markerfacecolor', 'w', 'markeredgecolor',color, 'linewidth', 2)
            %             errorbar(xaxis_, marg_ave, marg_SEM, 'color', color, 'CapSize',0, 'linestyle', 'none', 'linewidth', 2)
            errorbar(xaxis, marg_ave, marg_SEM_neg, marg_SEM_pos, 'color', color, 'CapSize',0, 'linestyle', 'none', 'linewidth', 2)
            
        else
            plot(xaxis, marg_ave, 'o-', 'color', color_idvd, 'linewidth', 2)
        end
        
        % plot fitting lines
        %         if nBins== 3
        %             if nsubj>1
        plot(xaxis, margPred_ave', '-', 'color', color, 'linewidth', wd_border)
        patch([xaxis, flip(xaxis)], [margPred_lb', flip(margPred_ub')], color, 'FaceAlpha', .2, 'linestyle', 'none')
        %             else
        %                 plot(xaxis, margPred_ave, '-', 'color', color, 'linewidth', wd_border)
        %                 patch([xaxis, flip(xaxis)], [margPred_lb, flip(margPred_ub)], color, 'FaceAlpha', .3, 'linestyle', 'none')
        %             end
        %         end
        
    end % end of iiLoc
    
    
    %% xaxis
    xlim(axisLim{ifeature})
    %     xlabel(xlabels_tuning{ifeature}, 'FontSize', sz_label)
    xticks(axisTicks_tuning{ifeature})
    xticklabels(axisTL_tuning{ifeature})
    if ifeature==2, xticklabels(round(axisTL_tuning{ifeature}, 1)), end
    
    yticks(yticks_)
    yticklabels(round(yticks_, 2))
    ylim(yticks_([1, end]))
    
    %%
    ax = gca;
    ax.XAxis.FontSize = sz_ticks;
    ax.YAxis.FontSize = sz_ticks;
    ax.LineWidth = wd_border/1.5;
    
    %% ANOVA2 (3 bins x 29 channels on kernels)
    varNames = {'Bin', 'Channel'};
    ind_Bin = repmat(1:nBins, nsubj, nFilters);
    ind_channel = nan(nsubj, nBins, nFilters);
    for isubj = 1:nsubj, ind_channel(isubj, :, :) = repmat(1:nFilters, nBins, 1); end
    
    r_anova = squeeze(marg_med(:, :, iiLoc, :)); % nsubj x nBins x nLoc x nORI/SF
    anova_text = print_nANOVA(varNames, r_anova(:),  {ind_Bin(:), ind_channel(:)}, nsubj);
    
    %% title
    title_R2 = 'R^2:';
    for iiBin = 1:length(indBins)
        title_R2 = [title_R2, sprintf(' [Bin%d]: %.2f (%.2f)', indBins(iiBin), margR2_ave2(iiBin), margR2_SEM2(iiBin))];
    end
    title(sprintf('n%d %s [%s]\n%s\n%s', nsubj, binStrategy, namesType{itype}, anova_text, title_R2), 'fontsize', 20)
    
    %% save
    saveas(gcf, sprintf('%s/n%d_L%d_%s_nBins%d_%s.jpg', nameFigFolder_RC_marg, nsubj, iLocComb_all(iiLoc), namesFeature{ifeature}, nBins, namesType{itype}))
    
end % end of ifeature


