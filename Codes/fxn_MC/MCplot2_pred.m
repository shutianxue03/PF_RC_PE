
nameFigFolder_MC_pred = sprintf('%s/pred', nameFigFolder_MC); if isempty(dir(nameFigFolder_MC_pred)), mkdir(nameFigFolder_MC_pred), end
ylimits = {[-.1, .3], [-.05, .15]};

for iIC = 1:nIC_
    iBest_unik = unique(iBest_allSubj(:, iIC));
    [freq, iBest_best] = groupcounts(iBest_allSubj(:, iIC));
    nChosen = length(freq);
    
    dev_groupAVE = squeeze(mean(dev_allSubj(:, :, iIC)));
    dev_groupSEM = squeeze(std(dev_allSubj(:, :, iIC)))/sqrt(nsubj);
    [~, irank_groupAVE] = sort(dev_groupAVE); % sort based on averaged dev (for CV) for IC
    iBest_group = irank_groupAVE(1);
    dd_ = dev_groupAVE-min(dev_groupAVE);
    
    for iBin = 1:nBins
        if flag_plotPred
            figure('Position', [0, 0, 2e3, 2e3]), hold on
            for isubj = 1:nsubj
                subjName = subjList{isubj};
%                 nblocks = nblocks_allSubj(isubj);
                
                nameKernel = sprintf('Data_OOD/%s/%s_kernel_%s_%d_%d_mirror%d_%s.mat', subjName, subjName, namePatchMode, nORI, nSF, flag_mirrorMapping, binStrategy_all{flag_binStrategy+1});
                load(nameKernel, 'kernels2D_perComb_perBin')
                
                %%  extract y (i.e., kernels)
                %             [~, nORI, nSF] = size(kernels2D_perComb_perBin{1,1});
                %     kk = nan(nLoc2, nORI, nSF);
                if ifeature==1, marg = nan(nLoc2, nORI); else, marg = nan(nLoc2, nSF); end
                for iiLoc = 1:nLoc2
                    %         yData(iiLoc, :) = marg{iLoc_all(iiLoc)}(itype, :);
                    kk = squeeze(kernels2D_perComb_perBin{iBin, iLocComb_all(iiLoc)}(itype, :, :));
                    if ifeature==1, marg(iiLoc, :) = mean(kk, 2);
                    else, marg(iiLoc, :) = mean(kk, 1);
                    end
                end % iiLoc
                
                % pred (group best model)
                params_groupBest = params_est_allSubj{isubj}{iBest_group};
                ypred_groupBest = MC_predKernel(ind_tunParam_all(iBest_group, :), axis_tuning_ln, nBins, nLoc2, nBins*nLoc2, nTunParams, params_groupBest, ifamily);
                
                % pred (idvd best model)
                iBest_idvd = iBest_allSubj(isubj);
                params_idvdBest = params_est_allSubj{isubj}{iBest_idvd};
                ypred_idvdBest = MC_predKernel(ind_tunParam_all(iBest_idvd, :), axis_tuning_ln, nBins, nLoc2, nBins*nLoc2, nTunParams, params_idvdBest, ifamily);
                                
                subplot(3,5, isubj), hold on
                if iBest_idvd == iBest_group, box on, set(gca,'linewidth',2); else, box off; end
                switch ifeature
                    case 1, axis_tuning_ln = axis_tuning{ifeature};
                    case 2, axis_tuning_ln = 2.^axis_tuning{ifeature};
                end
                
                % extra line
                yline(0, '-', 'color', ones(1,3)*.8);
                xline(ifeature-1, '-', 'color', ones(1,3)*.8);
                
                % ylim
                ylim(ylimits{ifeature})
                
                Rsquared_groupBest = []; Rsquared_idvdBest = [];
                for iLine = 1:nLoc2
                    iLocComb = iLocComb_all(iLine);
                    
                    % raw kernels
                    kk = marg(iLine, :);
                    plot(axis_tuning{ifeature}, kk, markers_allSubj{isubj}, 'color', colors_comb(iLocComb_all(iLine), :))
                    
                    iLine_ = iLine + (iBin-1) * nLoc2;
                    % group best model
                    plot(axis_tuning{ifeature}, ypred_groupBest(iLine_, :), '-', 'color', colors_comb(iLocComb_all(iLine), :), 'linewidth', 2)
                    
                    % idvd best model
                    plot(axis_tuning{ifeature}, ypred_idvdBest(iLine_, :), 'k--', 'linewidth', 1)
                    
                    % Get R squared
                    Rsquared_groupBest(iLine) = getR2(kk, ypred_groupBest(iLine_, :));
                    Rsquared_idvdBest(iLine) = getR2(kk, ypred_idvdBest(iLine_, :));
                    Rsquared_groupBest_allSubj(isubj, iLine) = getR2(kk, ypred_idvdBest(iLine_, :));
                end % iline
                
     
                % xticks
                if ifeature == 2
                    xticks(0:.5:2), xticklabels([1, 1.41, 2, 2.83, 4]), xlim([0, 2])
                else, xticks(-90:45:90), xticklabels(-90:45:90), xlim([-90, 90])
                end
                % title and texts
                title(sprintf('%s\nIDVD best M%d [%s] \nIDVD best R^2 = %.0f%% & %.0f%%\nGroup best R^2 = %.0f%% & %.0f%%', ...
                    subjName, iBest_idvd, num2str(ind_tunParam_all(iBest_idvd, :)), Rsquared_idvdBest*100, Rsquared_groupBest*100))
                % [text] dev/IC of th group/idvd best model
                %             text(text_x(ifeature), text1_y(ifeature), sprintf('IDVD best M%d [%s], dev/IC = %.5f\nGroup best: dev/IC = %.5f', ...
                %                 iBest_idvd, num2str(ind_tunParam_all(iBest_idvd, :)), dev_allSubj(isubj, iBest_idvd, iIC), ...
                %                 dev_allSubj(isubj, iBest_group, iIC)))
                % [text] R2
                %             text(text_x(ifeature), text2_y(ifeature), ...
                %                 sprintf('R^2 (group/idvd):\n%s %d%%/%d%%; %s %d%%/%d%%', ...
                %                 namesLocComb{iLocComb_all(1)}, round(Rsquared_groupBest(1)*100), round(Rsquared_idvdBest(1)*100), ...
                %                 namesLocComb{iLocComb_all(2)}, round(Rsquared_groupBest(2)*100), round(Rsquared_idvdBest(2)*100)))
            end % isubj
            
            if MCmode == 3
                sgtitle(sprintf('n = %d [ORI%d SF%d] [Bin%d]\n%s - Family #%d %s\n%s-%s\nBest group model M%d [%s] R^2= %.0f%% & %.0f%%', ...
                    nsubj, nORI, nSF, iBin, namesFeature{ifeature}, ifamily, namesFamily_all{ifamily}, namesMCmode{MCmode}, ...
                    namesIC{iIC}, iBest_group, num2str(ind_tunParam_all(iBest_group, :)), mean(Rsquared_groupBest_allSubj)*100))
            else
                sgtitle(sprintf('n = %d [ORI%d SF%d] [Bin%d]\n%s - Family #%d %s\n%s\nBest group model M%d [%s] R^2= %.0f%% & %.0f%%', ...
                    nsubj, nORI, nSF, iBin, namesFeature{ifeature}, ifamily, namesFamily_all{ifamily}, namesMCmode{MCmode}, ...
                    iBest_group, num2str(ind_tunParam_all(iBest_group, :)), mean(Rsquared_groupBest_allSubj)*100))
            end
            
            if MCmode==3
                saveas(gcf, sprintf('%s/n%d_M%d_Bin%d_%s.jpg', nameFigFolder_MC_pred, nsubj, ifamily, iBin, namesIC{iIC}))
            else
                saveas(gcf, sprintf('%s/n%d_M%d_Bin%d_%s.jpg', nameFigFolder_MC_pred, nsubj, ifamily, iBin, namesMCmode{MCmode}))
            end
        end % if flag_plot
    end % iBin
end % iIC

close all