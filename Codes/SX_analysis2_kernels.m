
% Step 2: [Local] run PF_RC_step2 to do RC analysis on ALL trials (no resampling)
% code is similar to OOD_boot (noresampling)
% use the sensitivity kernels derived from ALL trials to determine which model best captures ORI and SF

clc
close all
warning off
format compact

addpath(genpath('fxn_analysis_RC_v2'))
addpath(genpath('fxn_exp'))
addpath(genpath('fxn_MC'))
addpath(genpath('Data_OOD'))
addpath(genpath('Data_compile'))

%%
%---------------%
SX_RC1_setting
%---------------%

subjList_full = {'YK', 'SP', 'SX', 'LS', 'RE', 'MD', 'AS', 'HL', 'FH', 'HA',  'DT', 'CS', 'DU', 'SR', 'RC'};
nblocks_allSubj_full = [200, 240, 210, 240, 220, 220, 215, 220, 205, 210, 205, 205, 205, 195, 205];

nBins = 3;
flag_PatchMode = 2;
iLocComb_all = 1:8;
nTrialsPerBlock = 100;
flag_mirror = 1;

% create gabor filters
fileNameFilters = sprintf('Data_OOD/filtersFile_%d_%d.mat', nORI, nSF);
fileDirFilters = dir(fileNameFilters);
plotFlag = 0;
if isempty(fileDirFilters)
    [filter_sin, filter_cos] = SX_sim02_setFilters(stim, noise.filtersSF_all, filtersOri_all, plotFlag);
    save(fileNameFilters, 'filter_sin', 'filter_cos')
else
    load(fileNameFilters)
end
fprintf('\n\nPool of filters created: nORI=%d, nSF=%d\n', length(filtersOri_all), length(noise.filtersSF_all))

for flag_binStrategy=0:3
    clc
    binStrategy = binStrategy_all{flag_binStrategy+1};
    
    if flag_binStrategy == 3, indSubj = 1:11; else, indSubj = [1:6, 8:14]; end
    subjList = subjList_full(indSubj);
    nblocks_allSubj = nblocks_allSubj_full(indSubj);
    nsubj = length(subjList);
    nSess = nblocks_allSubj/5;
    
    % print
    fprintf('Bin strategy: %s\n', binStrategy)
    fprintf('Mirror: %d', flag_mirror)
    
    for isubj = 1:nsubj
        
        subjName = subjList{isubj};
        nblocks = nblocks_allSubj(isubj);
        
        fprintf('\n\n%s%d (%d/%d) ...\n', subjName, nblocks, isubj, nsubj)
        
        % ====== load binning strategy ======
        load(sprintf('Data_compile/BinStrategy/BinInfo_n%d_nBins%d_%s.mat', nsubj, nBins, binStrategy), '*_allSubj')
        iSess_start_perBin = iSess_start_perBin_allSubj{isubj};
        iSess_end_perBin = iSess_end_perBin_allSubj{isubj};
        nSess_perBin = nSess_perBin_allSubj{isubj};
        
        % ====== get dir ======
        nameBehavMeas = sprintf('Data_OOD/%s/%s_behavMeas.mat', subjName, subjName);
        dirBehavMeas = dir(nameBehavMeas);
        if flag_PatchMode == 1, namePatchMode = 'T'; else, namePatchMode = 'N'; end
        nameSourceEnergy = sprintf('Data_OOD/%s/%s_energy_%s_%d_%d.mat', subjName, subjName, namePatchMode, nORI, nSF);
        nameKernel = sprintf('Data_OOD/%s/%s_kernel_%s_%d_%d_mirror%d_%s.mat', ...
            subjName, subjName, namePatchMode, nORI, nSF, flag_mirror, binStrategy);
        
        %         if isempty(dir(nameKernel))
        % extract basic data matrix
        fprintf('  Loading Data matrix...'), tic
        load(nameBehavMeas, 'dataMatrix')
        dur = toc; fprintf('DONE (Dur %.1f min)\n', dur/60)
        
        % load the source energy (from which energy will be sampled in each bootstrapping)
        fprintf('  Loading Source Energy...'), tic
        load(nameSourceEnergy)
        if flag_PatchMode == 1, e3D_allT = e3D_target_allT; else, e3D_allT = e3D_noise_allT; end
        dur = toc; fprintf('DONE (Dur %.1f min)\n', dur/60)
        
        [ntrials_allT, nORI, nSF] = size(e3D_allT);
        ntrialsPerLoc_original = ntrials_allT/5; % ntrials per loc
        nSess = ntrials_allT/500;
        
        % quick plot
        % e3D = e3D_target_allT; for iLoc = 1:5, quickPlot_energy, end
        
        % Generate kernels per single/combined location
        fprintf('  Generating kernels per loc...'), tic
        % empty containers
        pYES_tgt_perComb_perBin = cell(nBins, nLoc8);
        ebin_tgt_perComb_perBin = pYES_tgt_perComb_perBin;
        pYES_tgt_norm_perComb_perBin = pYES_tgt_perComb_perBin;
        ebin_tgt_norm_perComb_perBin = pYES_tgt_perComb_perBin;
        kernels2D_perComb_perBin = pYES_tgt_perComb_perBin;
        intercept2D_perComb_perBin = pYES_tgt_perComb_perBin;
        margORI_perComb_perBin = pYES_tgt_perComb_perBin;
        margSF_perComb_perBin = pYES_tgt_perComb_perBin;
        
        for iBin = 1:nBins
            fprintf('\n      Bin #%d (%d sessions): ', iBin, nSess_perBin(iBin))
            
            %%%%%%%%%%%%%%
            % SELECT BINS
            %%%%%%%%%%%%%%
            iSess_all = iSess_start_perBin(iBin):iSess_end_perBin(iBin);
            nSess_ = length(iSess_all);
            
            for iLocComb = iLocComb_all
                fprintf('%s ', namesLocComb{iLocComb})
                
                if iLocComb < 6, iLoc_all = iLocComb;
                else, switch iLocComb , case 6, iLoc_all = [2,4]; case 7, iLoc_all = [3,5]; case 8, iLoc_all = 2:5; end
                end
                nLoc2 = length(iLoc_all);
                
                dataMtx_accum = [];
                e3D_accum = [];
                iPRS_accum = [];
                cst_accum = [];
                
                for iiLoc = 1:nLoc2
                    indLoc = dataMatrix(:, 5) == iLoc_all(iiLoc);
                    for iSess=1:nSess_
                        indSess = dataMatrix(:, 2) == iSess_all(iSess);
                        ind = indSess & indLoc;
                        dataMtx_accum = [dataMtx_accum; dataMatrix(ind, :)];
                        e3D_accum = cat(1, e3D_accum, e3D_allT(ind, :, :));
                        iPRS_accum = [iPRS_accum; dataMatrix(ind, 6)];
                        cst_accum = [cst_accum; dataMatrix(ind, 11)];
                    end % iSess
                    
                    assert(length(unique([size(dataMtx_accum, 1), size(e3D_accum, 1), size(iPRS_accum, 1), size(cst_accum , 1)]))==1)
                end %iiLoc
                
                assert(length(cst_accum) == nSess_perBin(iBin)*nTrialsPerBlock*nLoc2) % assert the number of trials per bin is correct
                % process data of combined location
                if iLocComb==1, ntrialsPerLoc_selected = size(cst_accum, 1); end
                
                % standardize energy
                %----------------------------------------------------%
                e3D_norm = normEnergy(e3D_accum, iPRS_accum, cst_accum);
                %----------------------------------------------------%
                
                % pYES vs. binned energy [SX_RC5_slope]
                % un-standardized energy
                %             [pYES_tgt, ebin_tgt] =  SX_RC5_slope(dataMtx_accum, e3D_accum, ntypes, nbins_e);
                
                % standardized energy
                %             [pYES_tgt_norm, ebin_tgt_norm] = SX_RC5_slope(dataMtx_accum, e3D_norm, ntypes, nbins_e);
                
                % Probit regression to get KERNELs [SX_RC6_kernel]
                kernels2D =  SX_RC6_kernel_parfor(e3D_norm, dataMtx_accum, filtersSF_all, filtersOri_all);
                
                % mirror if necessary
                if flag_mirror
                    indMir = (nORI-1)/2;
                    kk_left = kernels2D(:, 1:indMir, :);
                    kk_right = kernels2D(:, indMir+2:end, :);
                    kk_mid = kernels2D(:, indMir+1,:);
                    kk_ave = (kk_left + flip(kk_right,2))/2;
                    kernels2D = cat(2, kk_ave, kk_mid, flip(kk_ave, 2));
                end
                
                % get marginalized tuning fxns
                margORI = mean(kernels2D, 3);
                margSF = squeeze(mean(kernels2D, 2));
                
                % compile vars for each iB
                %             pYES_tgt_perComb_perBin{iBin, iLocComb} = pYES_tgt;
                %             ebin_tgt_perComb_perBin{iBin, iLocComb} = ebin_tgt;
                %             pYES_tgt_norm_perComb_perBin{iBin, iLocComb} = pYES_tgt_norm;
                %             ebin_tgt_norm_perComb_perBin{iBin, iLocComb} = ebin_tgt_norm;
                kernels2D_perComb_perBin{iBin, iLocComb} = kernels2D;
                %             intercept2D_perComb_perBin{iBin, iLocComb} = intercept2D;
                margORI_perComb_perBin{iBin, iLocComb} = margORI;
                margSF_perComb_perBin{iBin, iLocComb} = margSF;
                % R2_2D, R2_Tjur, pValues, pCat, sep
            end %iLocComb
        end % iBin
        
        dur = toc; fprintf('DONE (Dur %.1f min)\n', dur/60)
        
        % save kernels to OOD
        save(nameKernel, '*_perComb_perBin', 'ntrialsPerLoc_*')
        fprintf('  Kernels SAVED')
        dur = toc; fprintf('DONE (Dur %.1f min)\n', dur/60)
        %         else
        %             load(nameKernel)
        %             fprintf('  Kernels LOADED')
        %         end
        
        %% plot kernels of three loc pairs
        close all
        locPairs_all = [1, 8; 6, 7; 5, 3; 2,4];
        nLocPairs = size(locPairs_all, 1);
        iType = 2;
        
        %%%%% print each bin in one figure %%%
        for iBin=1:nBins
            figure('Position', [0 0 nLocPairs*300 400])
            for iiPair = 1:nLocPairs % F vs. P, HM vs. VM, LVM vs. UVM
                iLocPair = locPairs_all(iiPair, :);
                
                for iFeature = 1:2
                    if iFeature == 1, marg = margORI_perComb_perBin; ylim_ = [-.1, .25]; x_ticks = linspace(-90,90,5); x_ticklabels = x_ticks;
                    else, marg  = margSF_perComb_perBin; ylim_ = [-.05, .1];x_ticks = linspace(0,2,5); x_ticklabels = round(2.^x_ticks, 2);
                    end
                    
                    marg1 = marg{iBin, iLocPair(1)}(iType, :);
                    marg2 = marg{iBin, iLocPair(2)}(iType, :);
                    
                    % tuning functions of two loc
                    subplot(2,nLocPairs, iiPair+(iFeature-1)*nLocPairs), hold on
                    plot(axis_tuning{iFeature},  marg1, '-', 'color', colors_perBinPerComb{iBin, iLocPair(1)}, 'linewidth', 2)
                    plot(axis_tuning{iFeature},  marg2, '-', 'color', colors_perBinPerComb{iBin, iLocPair(2)}, 'linewidth', 2)
                    ylim(ylim_), xline(iFeature-1, 'k-'); yline(0, 'k-');
                    xticks(x_ticks), xticklabels(x_ticklabels)
                    title(sprintf('%s vs. %s', namesLocComb{iLocPair(1)}, namesLocComb{iLocPair(2)}))
                    legend({namesLocComb{iLocPair(1)}, namesLocComb{iLocPair(2)}}, 'Location', 'northwest')
                end  % iFeature
                
            end % iPair
            sgtitle(sprintf('[%s] %s [Bin #%d - %d sessions]', namesType{iType}, subjName, iBin, nSess_perBin(iBin)))
            %             saveas(gcf, sprintf('Fig/Kernels_mirror%d/%s_Bin%d_%d.jpg', flag_mirror, subjName, iBin, nSess_perBin(iBin)))
        end % iBin
        
        %%%%% print all bins in one figure %%%
        figure('Position', [0 0 nLocPairs*300 400]),
        for iiPair = 1:nLocPairs % F vs. P, HM vs. VM, LVM vs. UVM
            iLocPair = locPairs_all(iiPair, :);
            
            for iFeature = 1:2
                if iFeature == 1, marg = margORI_perComb_perBin; ylim_ = [-.1, .25]; x_ticks = linspace(-90,90,5); x_ticklabels = x_ticks;
                else, marg  = margSF_perComb_perBin; ylim_ = [-.05, .1];x_ticks = linspace(0,2,5); x_ticklabels = round(2.^x_ticks, 2);
                end
                
                for iBin=1:nBins
                    marg1 = marg{iBin, iLocPair(1)}(iType, :);
                    marg2 = marg{iBin, iLocPair(2)}(iType, :);
                    
                    % tuning functions of two loc
                    subplot(2, nLocPairs, iiPair+(iFeature-1)*nLocPairs), hold on
                    plot(axis_tuning{iFeature},  marg1, '-', 'color', colors_perBinPerComb{iBin, iLocPair(1)}, 'linewidth', 2)
                    plot(axis_tuning{iFeature},  marg2, '-', 'color', colors_perBinPerComb{iBin, iLocPair(2)}, 'linewidth', 2)
                    ylim(ylim_), xline(iFeature-1, 'k-'); yline(0, 'k-');
                    xticks(x_ticks), xticklabels(x_ticklabels)
                    title(sprintf('%s vs. %s', namesLocComb{iLocPair(1)}, namesLocComb{iLocPair(2)}))
                end
                
            end % iFeature
            
        end % iPair
        sgtitle(sprintf('[%s] %s [%s] nBins=%d', namesType{iType}, subjName, num2str(nSess_perBin'), nBins))
        %         saveas(gcf, sprintf('Fig/Kernels_mirror%d/%s_nBin%d_%d_%d_%d.jpg', flag_mirror, subjName, length(nSess_perBin), nSess_perBin))
        
        %         close all
    end % isubj
    
    
end % flag_binStrategy
