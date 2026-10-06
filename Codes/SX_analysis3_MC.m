
%%%%%%%%%
%  Inputs
%%%%%%%%%
% ifeature: 1=ORI, 2=SF
% ifamily_all: ORI: 1 (Gaussian) or 8 (DoG); SF: 2 (log parabola), 3 (truncated log parabola)
% MCmode: 1=10 fold CV, 2=LOOCV, 3=Info criterion
% nIC: when MCmode = 3, 1=AIC, 2=AICc, 3=BIC

%%%%%%%%%
% Outputs
%%%%%%%%%
% For each ifeature, ifamily and MCmode:
% Fig 1: [top] dev of each model averaged across subj
%           [bottom] freq of the model to be chosen as the best model
% Fig 2: data + pred for each observer (two fitting lines: the best idvd model and second, the best group model)

% For each ifeature and MCmode:
% Fig 3: bar plots of dev of each ifamily for each MCmode

clear all, close all, clc
addpath(genpath('Data_MC'))
addpath(genpath('fxn_analysis_RC_v2'))
addpath(genpath('fxn_MC'))
addpath(genpath('fxn_RCplot'))

datetime('now')

%%
clc
%-------------%
SX_RC1_setting
%-------------%

MCmode = 3;%input('       >>> What model comparison mode (1=CV, 2=LOOCV, 3=iC): ');
% flag_binStrategy = input('       >>> Binning strategy: 0=equal; 1=algorithm, 2=manual_SX, 3=manual_DT: ');
flag_devErrorbar = 0;%input('       >>> Plot errorbars in dev plots? (1=YES, 0=NO): ');
flag_plotIDVD = 1;%input('       >>> Plot idvd data in family comparison plots? (1=YES, 0=NO): ');
flag_plotPred= 1;%input('       >>> Plot prediction? (1=YES, 0=NO): ');

% ifamily_all_perF = {1,2}; % models to compare
ifamily_all_perF = {[1,8], [2,3]}; % models to compare
% iLoc_all_all = [1,8; 6,7; 5,3; 2,4]; % location pairs
iLoc_all_all = [1,8; 6,7; 5,3]; % location pairs

nLocPairs = size(iLoc_all_all, 1);
nBins = 3;
flag_cutMapping = 0;
flag_mirrorMapping = 1;
flag_fancyXticks = 0; %1=plot candidate index (1=free to vary; 0= shared)
itype = 2;
% subjList =            {'YK', 'SP', 'SX', 'LS', 'RE', 'MD',         'HL', 'FH', 'HA',  'DT', 'CS', 'DU',        'SR'}; % no AS or RC, n=13
subjList = {'YK', 'SP', 'LS', 'RE', 'MD', 'HL', 'FH', 'HA',  'DT', 'CS', 'SR',    'SX', 'DU'}; % the last two are authors
nsubj = length(subjList);

nORI = 29; nSF = 29;
if MCmode==3, indVarMode = 0:3; else, indVarMode = 1:3; end
nVar = length(indVarMode);
namePatchMode = 'N';
% flag_PatchMode = 2; % energy derives from target; 2=noise patch
% if flag_PatchMode == 1, namePatchMode = 'T'; else, namePatchMode = 'N'; end

for flag_binStrategy=[0,1]
    binStrategy = binStrategy_all{flag_binStrategy+1};
    nameFolderMC = sprintf('Data_compile/MC/%s', binStrategy);
    for iiLoc_all_all = 1:nLocPairs

        iLocComb_all = iLoc_all_all(iiLoc_all_all, :);
        dev_bestGroup_perModePerFamily = cell(8, 3, nIC); % 8 = number of families, 3 = number of MCmodes, 3=nIC
        if flag_mirrorMapping, nameM = '_m'; else, nameM = ''; end
        if flag_cutMapping, nameC = 'c'; else, nameC = ''; end

        for ifeature = 1:2

            ifamily_all = ifamily_all_perF{ifeature};

            % Fig folder
            nameFigFolder_MC = sprintf('Fig/Fig_%s/MC/L%d%d/%s' , binStrategy, iLocComb_all, namesFeature{ifeature});
            dirFolder_fig = dir(nameFigFolder_MC); if isempty(dirFolder_fig), mkdir(nameFigFolder_MC), end

            ibestGroup_perModePerFamily = cell(1,length(ifamily_all));

            for ifamily = ifamily_all
                clc
                % compile idvd file
                if isempty(dir(nameFolderMC)), mkdir(nameFolderMC), end
                nameFileMC_allSubj = sprintf('%s/n%d_L%d%d_Family%d_mode%d.mat', nameFolderMC, nsubj, iLocComb_all, ifamily, MCmode);
                
                % model setting
                namesParams = namesParams_all{ifamily};
                nTunParams = length(namesParams);
                nCands = nVar^nTunParams;
                ind_tunParam_all = fxn_getParamInd(nTunParams, indVarMode);

                if MCmode == 3, nIC_ = nIC; else, nIC_ = 1; end

                if isempty(dir(nameFileMC_allSubj))
                    % empty folders
                    irank_allSubj = nan(nsubj, nIC_, nCands); % the sorted model index (best to worst model);
                    iBest_allSubj = nan(nsubj, nIC_);
                    dev_allSubj = nan(nsubj, nCands, 3);
                    params_est_allSubj = cell(nsubj, nCands);

                    for isubj = 1:nsubj
                        fprintf('%s (%d/%d)', subjList{isubj}, isubj, nsubj)

                        % Data folder
                        nameFolder_MC = sprintf('Data_MC/%s/%s/L%d%d/', binStrategy, subjList{isubj}, iLocComb_all);
                        nameFile_MC = sprintf('%sFamily%d_mode%d.mat', nameFolder_MC, ifamily, MCmode);

                        % load the MC file
                        if isempty(dir(nameFile_MC)), fprintf('... NOT EXIST: %s\n', nameFile_MC), break;
                        else, load(nameFile_MC), fprintf('... Loaded\n')
                        end

                        for iIC = 1:nIC
                            irank_allSubj(isubj, :, :) = irank_allCand; % the sorted model index (best to worst model);
                            iBest_allSubj(isubj, :) = iBest_allCand;
                        end
                        dev_allSubj(isubj, :, :) = dev_allCand;
                        params_est_allSubj{isubj} = params_est_allCand;

                    end % isubj

                    save(nameFileMC_allSubj, 'ifeature', 'ifamily',  'MCmode', 'ind_tunParam_all', '*_allSubj')
                else, load(nameFileMC_allSubj), fprintf('Loaded\n')
                end

                %% Fig 1-2
                %-------------------%
                MCplot0_allMode
                %-------------------%
                close all
                ibestGroup_perModePerFamily{ifamily} = num2str(ind_tunParam_all(iBest_group, :));

            end % ifamily

            % Fig 3. compare across families
            if length(ifamily_all)>1
                %-------------------%
                MCplot3_compFamily
                %-------------------%
            end
        end % ifeature

    end % iLoc_all_all

    close all
end
