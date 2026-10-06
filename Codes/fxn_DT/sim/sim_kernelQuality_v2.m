addpath(genpath('Data_OOD'))
addpath(genpath('fxn_DT'))
addpath(genpath('fxn_exp'))
addpath(genpath('fxn_MC'))
addpath(genpath('fxn_analysis_RC_v2'))
addpath(genpath('Figures'))
datetime('now')
clear

%% Sim parameters
nTrials_all = [400:200:2000];
SX_RC1_setting

flagPlot = 1;
flagNorm = 1;

% Save Figure Locations
figureFolder_path = sprintf('Figures/sim_seperability');
if ~exist(figureFolder_path, 'dir'), mkdir(figureFolder_path), end

%% Containers
seperability_all = nan(1, length(nTrials_all));
kernels2D_all = nan(length(nTrials_all),nORI,nSF);

margORI_all = nan(length(nTrials_all), nORI);
margSF_all = nan(length(nTrials_all), nSF);
margPredORI_all = margORI_all;
margPredSF_all = margSF_all;
margParamsORI_all = nan(length(nTrials_all),3);
margParamsSF_all = nan(length(nTrials_all),4);
margParams2ORI_all = nan(length(nTrials_all),3);
margParams2SF_all = nan(length(nTrials_all),4);
margORI_norm_all = margORI_all;
margSF_norm_all = margSF_all;
margPredORI_norm_all = margORI_all;
margPredSF_norm_all = margSF_all;
margParamsORI_norm_all = margParamsORI_all;
margParamsSF_norm_all = margParamsSF_all;
margParams2ORI_norm_all = margParams2ORI_all;
margParams2SF_norm_all = margParams2SF_all;

statsFolder_path = sprintf('%s/stats', figureFolder_path);
if ~exist(statsFolder_path, 'dir'), mkdir(figureFolder_path), end
%% Generate Percpetual Template
params_all = cell(1,2);
SX_normPDF = @(x,mu,sigma) exp(-(x-mu).^2/(2*sigma^2));

% ORI
gain = .1;
width = 20;
base = .01;
params_all{1} = [gain, width, base];
y = gain * SX_normPDF(axis_tuning{1}, 0, width) + base;
oriTemplate = y;%repmat(y,nORI,1);

% SF
peakSF = 2;
gain = .05;
width = .6;
base = -.01;
params_all{2} = [peakSF, gain, width, base];
y = gain * 10.^(-(log10(2.^axis_tuning{2} / peakSF) / width).^2) + base;
sfTemplate = y;%repmat(y,nSF,1);

perceptual_template = oriTemplate .* sfTemplate';

if flagPlot
    figure
    imagesc(perceptual_template), colorbar()
    xticks([5, 10, 15, 20, 25]), xticklabels(round([2.^axis_tuning{2}(5), 2.^axis_tuning{2}(10), 2.^axis_tuning{2}(15), 2.^axis_tuning{2}(20), 2.^axis_tuning{2}(25)],2)), xlabel('SF')
    yticks([5, 10, 15, 20, 25]), yticklabels(round([axis_tuning{1}(5), axis_tuning{1}(10), axis_tuning{1}(15), axis_tuning{1}(20), axis_tuning{1}(25)],2)), ylabel('ORI')
    set(gca, 'FontSize', 18)
	exportgraphics(gcf, sprintf('%s/template.jpg', figureFolder_path), 'Resolution', 300)
end

%% Simulate Sizes
for iSim = 1:length(nTrials_all)
    close all
    
    %% Sim params
    nTrials = nTrials_all(iSim);
    
    %% Generate energy patches
    gabor_cst = 1;

    patch_allT = cell(1,nTrials);
    standardNoise = patch_allT;
    for itrial = 1:nTrials
    %     [gabor, ~] = exp_createGabor_CorMag(stim, gabor_cst, loc, flagScale, 0);
        [patch_allT{itrial}, ~] = exp_CreateFilteredNoise(noise);
    end

    %% Generate filter
    [filter_sin, filter_cos] = SX_sim02_setFilters(stim, noise.filtersSF_all, filtersOri_all, 0);

    %% Compute source energy
    fprintf('Computing energy...\n')
    e2D_allT = nan(nTrials, nORI, nSF);
    phase2D_allT = e2D_allT;
    stim_mask = stim.mask;

    for iORI = 1:nORI
        parfor iSF = 1:nSF
            filter_sin_ = filter_sin{iORI,iSF};
            filter_cos_ = filter_cos{iORI,iSF};
            for itrial = 1:nTrials
                [a,b] = SX_sim04_computeEnergy(stim_mask, patch_allT{itrial}, filter_sin_, filter_cos_, 0);
                e2D_allT(itrial, iORI, iSF) = a;

                phase2D_allT(itrial, iORI, iSF) = b;
            end
%             fprintf('ORI: %d/%d, SF: %d/%d\n',iORI,nORI,iSF,nSF)
        end
        fprintf('ORI: %d/%d\n',iORI,nORI)
    end
    clc
    fprintf('Done computing energy\n')
    %% Normalize energy
    if flagNorm
        energy_norm = (e2D_allT(:, :, :) - mean(e2D_allT(:, :, :), 1))./ std(e2D_allT(:, :, :), [], 1);
    else
        energy_norm = e2D_allT;
    end
    
    %% Simulate Response
    fprintf('Simulating Responses...')
    energyDotSum = nan(1,nTrials);

    %determine internal variable for each trial
    for itrial = 1:nTrials
        sourceEnergy = squeeze(energy_norm(itrial, :, :));
        energyDotSum(itrial) = sum(dot(sourceEnergy(:),perceptual_template(:)));
    %     resp(itrial) =  energyDotSum(itrial) >= k;
    end

    %determine average internal variable and find threshold for set number of
    %responses
    k=mean(energyDotSum);
    steps = min(energyDotSum):(std(energyDotSum)*.001):max(energyDotSum);
    for i = 1:length(steps)
        k = steps(i);
        if sum(energyDotSum >= k)/nTrials <= .5, k = steps(i); break; end
    end
    resp = energyDotSum >= k;
    kThreshold_all(iSim) = k;

    fprintf('DONE\n')

    %% Probit regression
    fprintf('Regression...')
    [kernel2D, intercept2D, R2_2D, R2_Tjur_, pValues_, pCat_] = SX_sim07_RC(filtersSF_all, filtersOri_all, energy_norm(:,:,:), resp');
    fprintf('DONE\n')

    if flagPlot
        figure
        imagesc(kernel2D), colorbar()
        xticks([5, 10, 15, 20, 25]), xticklabels(round([2.^axis_tuning{2}(5), 2.^axis_tuning{2}(10), 2.^axis_tuning{2}(15), 2.^axis_tuning{2}(20), 2.^axis_tuning{2}(25)],2)), xlabel('SF')
        yticks([5, 10, 15, 20, 25]), yticklabels(round([axis_tuning{1}(5), axis_tuning{1}(10), axis_tuning{1}(15), axis_tuning{1}(20), axis_tuning{1}(25)],2)), ylabel('ORI')
        set(gca, 'FontSize', 18)

        savePath = sprintf('%s/Kernels', figureFolder_path);
        if ~exist(savePath, 'dir'), mkdir(savePath), end
        exportgraphics(gcf, sprintf('%s/Kernel_nTrials_%d.jpg', savePath, nTrials_all(iSim)))
    end

    %% Standard kernel fitting
    % for iline = 1:2
        % %% Fit Curves
        % if iline == 1, marg = mean(kernel2D,2)'; label_txt = 'ORI';
        % else, marg = mean(kernel2D,1); label_txt = 'SF';
        % end
        % fprintf('Fitting %s...', label_txt)
        % if iline == 1; [margPred, margParams, margR2_ORI, ~] = SX_sim08_fit(axis_tuning{iline}, marg, iline, ub_full_all{iline}, lb_full_all{iline}, 2); end

        % if iline == 2; [margPred, margParams, margR2, ~] = SX_sim08_fit(2.^axis_tuning{iline}, marg, iline, ub_full_all{iline}, lb_full_all{iline}, 2); end

        % %% Get TuningC
        % margParams2 = fxn_getTuningC(marg, iline, iline, margPred, margParams);
        
        % if iline == 1, margORI_all(iSim,:) = marg; margPredORI_all(iSim,:) = margPred; margParamsORI_all(iSim,:) = margParams; margParams2ORI_all(iSim,:) = margParams;
        % else, margSF_all(iSim,:) = marg; margPredSF_all(iSim,:) = margPred; margParamsSF_all(iSim,:) = margParams; margParams2SF_all(iSim,:) = margParams;
        % end

        % fprintf('DONE\n')
        % if flagPlot
            % %% plot tuning functions
            % figure('Position', [0 0 800 800]), hold on
            
            % plot(axis_tuning{iline}, marg, '.', 'MarkerSize', 8)
            % plot(axis_tuning{iline}, margPred, 'LineWidth', 2)
            % if iline==1, xline(axis_tuning{iline}(15), '--k')
            % elseif iline==2, xline(log2(params_all{2}(1)), '--k'), xticks(axis_tuning{2}([1 15 29])), xticklabels(round(2.^axis_tuning{2}([1 15 29]))), end
            % ylim([-0.02, 1])
            
            % title(sprintf('Marginals [%s]', label_txt))
            % xlabel(label_txt)
            % set(gca, 'FontSize', 18)
            
            % savePath = sprintf('%s/Marginals', figureFolder_path);
            % if ~exist(savePath, 'dir'), mkdir(savePath), end
            % exportgraphics(gcf, sprintf('%s/[%s]_SZ%.2f_Marginals_N%d.jpg', savePath, label_txt, scale, flagNorm))
            
            % %% plot estimated parameters
            % figure('Position', [0 0 800 800]), hold on
            % bar(margParams)
            % for ip = 1:length(margParams)
                % text(ip, margParams(ip)+.1, sprintf('%.2f', margParams(ip)), 'FontSize', 18, 'HorizontalAlignment', 'center')
            % end
            
            % if iline==1, xticks([1 2 3]), xticklabels({'Gain', 'Width', 'Bottom'})
            % else, xticks([1 2 3 4]), xticklabels({'Peak SF', 'Gain', 'Width', 'Bottom'})
            % end
            % set(gca, 'FontSize', 18)
            % savePath = sprintf('%s/estParams', figureFolder_path);
            % if ~exist(savePath, 'dir'), mkdir(savePath), end
            % exportgraphics(gcf, sprintf('%s/[%s]_SZ%.2f_estParams_N%d.jpg', savePath, label_txt, scale, flagNorm))
            % %% plot tuningC
            % figure('Position', [0 0 800 800]), hold on
            % if iline==1
                % bar(margParams2([1 2 3]))
                % for ip = 1:3
                    % text(ip, margParams2(ip)+.1, sprintf('%.2f', margParams2(ip)), 'FontSize', 18, 'HorizontalAlignment', 'center')
                % end
            % elseif iline==2
                % bar(margParams2([1 2 9 4]))
                % l = [1 2 9 4];
                % for ip = 1:4
                    % text(ip, margParams2(l(ip))+.1, sprintf('%.2f', margParams2(l(ip))), 'FontSize', 18, 'HorizontalAlignment', 'center')
                % end
            % end
            
            % if iline==1, xticks([1 2 3]), xticklabels({'Peak Amplitude', 'Bandwidth', 'Baseline'})
            % else, xticks([1 2 3 4]), xticklabels({'Peak SF', 'Peak Amplitude', 'Bandwidth', 'Baseline'})
            % end
            % set(gca, 'FontSize', 18)
            % savePath = sprintf('%s/tuningC', figureFolder_path);
            % if ~exist(savePath, 'dir'), mkdir(savePath), end
            % exportgraphics(gcf, sprintf('%s/[%s]_SZ%.2f_tuningC_N%d.jpg', savePath, label_txt, scale, flagNorm))
            
        % end
    % end
	%% Calculate seperability
	
	kernels2D_all(iSim,:,:) = kernel2D;
    fprintf('\nCalculating separability\n')
	seperability_all(iSim) = getSeparability(squeeze(kernel2D));
	fprintf('nTrials: %d -- Seperability: %.3f', nTrials_all(iSim), seperability_all(iSim))
    fprintf('DONE\n')
end%end of iSim

%% plot seperability
figure, hold on
plot(1:length(nTrials_all), seperability_all, '-k', 'LineWidth', 3)
set(gca, 'FontSize', 24)
exportgraphics(gcf, sprintf('%s/seperability_sim.jpg', savePath))

fprintf('Saving stats...')
clear('names*', 'lb_full_all', 'ub_full_all', "eyeD_all", 'filters*', 'i*')
save(sprintf('%s/stats.mat', figureFolder_path), '*_all')
fprintf('DONE\n')
datetime('now')
