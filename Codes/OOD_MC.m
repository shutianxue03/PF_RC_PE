function OOD_MC(isubj, iiLocComb, flag_cut, flag_mirror, ifeature, ifamily, MCmode)

% Purpose: run model comparison to decide which fxn captures the ORI/SF kernel better

% Inputs:
%       isubj
%       iiLocComb: which two loc to be fitted together
%       flag_cut: 1=cut extremes; 0=NOT
%       flag_mirror: 1=mirror 2D kernel matrix over ORI=0
%       ifeature: 1=ORI, 2=SF
%       ifamily: 1=Gaussian, 8=DoG // 2=log parabola, 3=truncated log parabola
%       MCmodel: see var 'titlesMCmode' defined below

close all
clc

addpath(genpath('Data_MC'))
addpath(genpath('Data_OOD'))
addpath(genpath('fxn_MC'))
addpath(genpath('fxn_analysis_RC_v2'))

time_start = datetime('now')

% 10-fold CV: 2.5 min per candidate model (for LS who has the most trials)
% LOOCV: ~22 sec
% IC: ~1 sec

%% general params
%--------------%
SX_RC1_setting
%--------------%

nORI = 29; nSF = 29;
nBins = 3;
itype = 2;% extract kernels derived from target-abs trials
flagPlot = 0;
namePatchMode = 'N';

iLoc_all_all = [1,8; 6,7; 5,3; 2,4];
iLoc_all = iLoc_all_all(iiLocComb, :); nLoc2 = length(iLoc_all);
switch MCmode, case 1, ncv = 10; case 2, ncv = 2; end % number of rounds of cross validation
nrep = 20; % number of reps to find the global minimum
k = 10; % k-fold cross validation

subjList =             {'YK', 'SP', 'SX', 'LS', 'RE', 'MD', 'AS', 'HL', 'FH', 'HA', 'CS', 'DT', 'DU','SR', 'RC'};
nblocks_allSubj = [200, 240, 210, 240, 220, 220, 215, 220, 205, 210, 205, 205, 205, 205, 195];
subjName = subjList{isubj};

% calculation of IC comes from Fernandez2022
getBIC = @(nLL, nparamsAll, ndata) ndata * log(nLL) + nparamsAll * log(ndata);
getAIC = @(err, nparamsAll, ndata) ndata * log(err)+ 2*nparamsAll;
getAICc = @(err, nparamsAll, ndata) ndata * log(err)+ 2*nparamsAll + 2*nparamsAll*(nparamsAll+1)/(ndata-nparamsAll-1);

options = optimoptions('fmincon','MaxIterations',5000,'Display','off');

titlesMCmode = {'10-fold cross validation (deviance is nLL)', ...
    'Leave-One-Out CV (deviance is nLL)', ...
    'Information criterion (deviance is nLL)'};
namesYLabel = {'Deviance', 'Deviance', 'IC'};

namesIC = {'AIC', 'AICc', 'BIC'};
nIC = length(namesIC);

fprintf('\n==========================\n')
fprintf('%s\n    >> %s vs. %s (%s)\n    >> cut = %d (1=cut the edge)\n    >> mirror=%d (1=mirror over ORI=0)\n    >> [%s] - Family%d - %s\n    >> %s\n', ...
    subjName, namesLocComb{iLoc_all(1)}, namesLocComb{iLoc_all(2)}, namePatchMode, ...
    flag_cut, flag_mirror, ...
    namesFeature{ifeature}, ifamily, namesFamily_all{ifamily}, ...
    titlesMCmode{MCmode})
fprintf('============================\n')

%% model setting
% extract ub and lb
ub_full = ub_full_all{ifamily};
lb_full = lb_full_all{ifamily};

% the tuning parameters of the current model family
namesParams = namesParams_all{ifamily};
nTunParams = length(namesParams);

% index of variation mode of each tuning parameter
if MCmode==3, indVarMode = 0:3; % fast, thus also include 0
else, indVarMode = 1:3; 
end
nVar = length(indVarMode);
ind_tunParam_all = fxn_getParamInd(nTunParams, indVarMode);
% 0=fixed between loc and across bins
% 1=fixed between loc, but can vary across bins
% 2=fixed between bins, but can vary across loc
% 3=can vary both between loc and across bins

% number of all candidate models
nCands = size(ind_tunParam_all, 1); assert(nCands == nVar^nTunParams)

%% extract x (y is extracted for each subj)
if (ifeature == 2) && (~sum(ifamily == [4, 5, 9])) % fitting SF except (4) raised gaussian (5) double exponential (9) gaussian to SF
    axis_tuning_ln = 2.^axis_tuning{ifeature};
else, axis_tuning_ln = axis_tuning{ifeature};
end
nfilters = length(axis_tuning_ln);

%% name of the folder and files
if flag_mirror, nameM = '_m'; else, nameM = ''; end
if flag_cut, nameC = 'c'; else, nameC = ''; end

nameFolder_MC = sprintf('Data_MC/%d%d%s%s/%s/L%d%d', nORI, nSF, nameM, nameC, subjList{isubj}, iLoc_all);
dirFolder_MC = dir(nameFolder_MC); if isempty(dirFolder_MC), mkdir(nameFolder_MC), end
nameFile_MC = sprintf('%s/Family%d_mode%d.mat', nameFolder_MC, ifamily, MCmode);

if MCmode == 3, nIC_ = nIC; else, nIC_ = 1; end % number of information criterion

%% load kernels
nameKernel = sprintf('Data_OOD/%s/%s_kernel_%s_%d_%d_mirror%d.mat', ...
    subjName, subjName, namePatchMode, nORI, nSF, flag_mirror);
fprintf('  Loading kernels...'), tic
load(nameKernel, 'kernels2D_perComb_perBin')
dur = toc; fprintf('DONE (Dur %.1f min)\n', dur/60)

%% extract y (i.e., kernels)
nLines = nBins*nLoc2;
if ifeature==1, yData = nan(nLines, nORI); else, yData = nan(nLines , nSF); end
iLine = 1;
for iBin=1:nBins
    for iiLoc = 1:nLoc2
        kk= squeeze(kernels2D_perComb_perBin{iBin, iLoc_all(iiLoc)}(itype, :, :));
        
        % cut
        if flag_cut, kk = kk(cut_ORI, cut_SF); end
        if ifeature==1
            yData(iLine, :) = mean(kk, 2); % [two loc of the 1st bin; two loc of the 2nd bin; two loc of the 3rd bin]
        else
            yData(iLine, :) = mean(kk, 1);
        end
        iLine = iLine+1;
    end
end

%% empty folders
irank_allCand = nan(nIC_, nCands); % the sorted model index (best to worst model);
iBest_allCand = nan(nIC_, 1);
dev_allCand = nan(nCands, 3);
params_est_allCand = cell(1, nCands);

%% loop through each candidate model
% i=1;
for iCand = 1:nCands % loop thru model candiadates // cannot and no need to 'parfor', because fitting used parfor
    
    tic
    ind_tunParam = ind_tunParam_all(iCand, :); % extract the index of each parameter, indicating whether the tuning param is fixed/varied across conditions    fprintf('M#%d/%d [%s]...\n', iCand, nCands, num2str(ind_tunParam))
    % calculate the number of fitting parameters in a candidate model
    nFitParams = fxn_getNumFittingParams(ind_tunParam, nBins, nLoc2);
    
    % get limits and radnomly sample initial param for each tun param
    [ub, lb, params0] = MC_getLimits(ind_tunParam, ub_full, lb_full, nBins, nLoc2);
    assert(length(ub) == nFitParams)
    assert(length(lb) == nFitParams)
    assert(length(params0) == nFitParams)
    
    switch MCmode
        case 1 % 10-fold Cross validation
            [param_est_allK, dev_test_allK] = fxn_runCV(nBins, nLoc2, MCmode, k, ncv, nfilters, yData, ind_tunParam, ifamily, options, params0, lb, ub, nrep, axis_tuning_ln);
            dev_allCand(iCand, 1) = nanmedian(dev_test_allK);
            dev_allCand(iCand, 2) = nanstd(dev_test_allK);
            params_est_allCand{iCand} = nanmean(param_est_allK, 1);
            
            %         case 2 % leave-one-out CV
            %             [param_est_allK, dev_test_allK, y_pred_allK] = fxn_runCV(MCmode, nfilters, ncv, nfilters, yData, ind_tunParam, ifamily, options, params0, lb, ub, nrep, axis_tuning_ln);
            %             dev_allCand(iCand, 1) = nanmedian(dev_test_allK);
            %             dev_allCand(iCand, 2) = nanstd(dev_test_allK);
            %             params_est_allCand{iCand} = nanmean(param_est_allK, 1);
            %
        case 3 % IC (AIC, AICc and BIC, based on nLL)
            fitMode = 1; % 1: dev is RSS; 2: dev is nLL
            fxn_getDev = @(kernelParams) MC_getDev_CV(ind_tunParam, nBins, nLoc2, kernelParams, axis_tuning_ln, yData, ifamily, fitMode);
            problem = createOptimProblem('fmincon','objective', fxn_getDev,'x0',params0,'lb',lb,'ub',ub,'options',options);
            ms = MultiStart('StartPointsToRun', 'bounds', 'UseParallel', 0, 'Display', 'off');
            [params_est, dev] = run(ms, problem, nrep);
            params_est_allCand{iCand} = params_est;
            % predict
            y_data_pred = MC_predKernel(ind_tunParam,  axis_tuning_ln, nBins, nLoc2, nLines, nTunParams, params_est, ifamily);
            % compile
            nData = length(y_data_pred(:));
            dev_allCand(iCand, :) = [getAIC(dev, nFitParams, nData), getAICc(dev, nFitParams, nData), getBIC(dev, nFitParams, nData)];
    end % switch imodel
    
    % quick plot of data and prediction of each candidate model
    %         if imodel==7, MCplot_IDVDCandidate, end
end % end of imodel

%% compile outputs
iCand_toShow = 1:10; % only show the first 10 best candidate models

if flagPlot, figure('Position', [0 0 400 * nIC_, 300]), hold on, end

for iIC = 1:nIC_
    [~, irank] = sort(squeeze(dev_allCand(:, iIC))); % sort based on averaged dev (for CV) for IC
    indBEST = irank(1);
    irank_allCand(iIC, :) = irank;
    iBest_allCand(iIC) = irank(1);
    
    if flagPlot
        % plot the dev/IC of each model ina ranked way of the current subj
        subplot(1,nIC_, iIC), hold on
        dev_ = squeeze(dev_allCand(irank, iIC));
        dev_delta = dev_-min(dev_);
        bar(iCand_toShow, dev_delta(iCand_toShow))
        xticks(iCand_toShow)
        %         xticklabels(indCands(irank))
        xlabel('Candidate model #')
        if MCmode == 3, title(sprintf('%s-%s\n The best model is #%d [%s]', subjName, namesIC{iIC}, indBEST, num2str(ind_tunParam_all(indBEST, :))))
        else, title(sprintf('%s\n The best model is #%d [%s]', subjName, indBEST, num2str(ind_tunParam_all(indBEST, :))))
        end
    end % if flagPlot
end % iIC

if flagPlot
    saveas(gcf, sprintf('Data_MC/%s_L%d%d_MC.jpg', subjName, iLoc_all))
end

%% plot the best fitting function
ii = indBEST;
i = ind_tunParam_all(ii, :);
params_est = params_est_allCand{ii};

% predict
y_data_pred = MC_predKernel(i, axis_tuning_ln, nBins, nLoc2, nLines, nTunParams, params_est, ifamily);

if flagPlot
    figure, hold on
    for iBin=1:nBins
        c = 255-ones(1,3)*iBin/nBins*100;
        c = c/255;
        for iLoc = 1:nLoc2
            if iLoc==1, color_face = c; line_style='-';
            else, color_face = 'w'; line_style='--';
            end
            ind = iLoc + (iBin-1)*nLoc2;
            plot(axis_tuning_ln, yData(ind, :), 'o--', 'color', c, 'MarkerFaceColor', color_face, 'MarkerEdgeColor', c, 'MarkerSize', 10)
            plot(axis_tuning_ln, y_data_pred(ind, :), line_style, 'color', c)
        end
    end
    set(findall(gcf, '-property', 'LineWidth'), 'LineWidth',1.5)
    title(sprintf('%s\n The best model is #%d [%s]', subjName, ii, num2str(ind_tunParam_all(ii, :))))
    saveas(gcf, sprintf('Data_MC/%s_L%d%d_fitting.jpg', subjName, iLoc_all))
end

%% save
save(nameFile_MC, 'ifeature', 'ifamily',  'MCmode', 'ind_tunParam', '*_allCand')

%%
time_end = datetime('now')

time_end - time_start
