
% For each observer, this script loads their data (processed on OOD), plot
% idvd data and for all observers, plot group data.

clc, close all, clear all, warning off, format compact

% addpath(genpath('XueCarrasco')) % this takes a little while
addpath(genpath('fxn_MC'))
addpath(genpath('Data_OOD'))
addpath(genpath('Data_compile/RC'))
addpath(genpath('fxn_RCplot'))
addpath(genpath('fxn_analysis_RC_v2'))

%% basic settings
clc

global flag_cutMapping ifamily_perF
%---------------%
SX_RC1_setting
%---------------%
flag_ABSprefORI = 1;%input('     >>> take abs of pref ORI? (1=YES, 0=NO): '); % 1=take abs, meanig distance from the signal; 0=the sign (+ or -) indicates bias
flag_cutMapping = 0; % 1=load original data (ORI29 SF29) and cut the edge
flag_mirrorMapping = 1; % 1=mirror 2D mapping over 0 deg ori
nBins = 3;
nB_perBatch = 100;%1e2;
nBatches = 10;
nBoot = nB_perBatch * nBatches;
flag_PatchMode = 2; % energy derives from target; 2=noise patch
flag_standEnergy = 1; if flag_PatchMode==1, flag_standEnergy =1; end
namesEnergySource = {'TARGET', 'NOISE'};
namePatchMode = 'N';

%---------------%
SX_RC1_setting
%---------------%
fprintf('\n\nnORI=%d nSF=%d\n\n', nORI, nSF)

iLocComb_all_all = {[1,8], [6,7], [5,3], [2,4]};
iLocComb_all_all = {[1,8], [6,7], [5,3]};
nll = length(iLocComb_all_all);
% [1,8]: fovea vs. periphery
% [6,7]: HM vs. VM
% [5,3]: LVM vs. UVM
% [2,4]: LHM vs. RHM

ifamily_perF = [1,2]; %input('     >>> What is the model family for ORI and SF (e.g., [1,2]): '); % ORI: Gaussian with different mean; SF: double peak

nTuningC_ORI = length(namesTunC_unit_perF{ifamily_perF(1), 2}); % preferred ori, peak amp, bandwidth, bottom, // pred_half
nTuningC_SF = length(namesTunC_unit_perF{ifamily_perF(2), 2}); % peakSF, peak amp., bandwidth_full (octave), baseline // bandwidth_L, bandwidth_R, bottom, pred_half, full bandwidth (linear scale)

flag_binStrategy = input('     >>> Binning strategy (0=equal; 1=algorithm, 2=manual SX, 3=manual DT): ');
binStrategy = binStrategy_all{flag_binStrategy+1};

% subjList = {'YK', 'SP', 'SX', 'LS', 'RE', 'MD',       'HL', 'FH', 'HA',  'DT', 'CS', 'DU',      'SR'};
subjList = {'YK', 'SP', 'LS', 'RE', 'MD', 'HL', 'FH', 'HA',  'DT', 'CS', 'SR',    'SX', 'DU'}; % the last two are authors
if flag_binStrategy == 3
    subjList = {'YK', 'SP', 'SX', 'LS', 'RE', 'MD','AS', 'HL', 'FH', 'HA',  'DT'};
end
nsubj = length(subjList);

flag_basedOnMC = input('     >>> 0=all TunC Free To Vary; 1=based on MC: ');
if flag_basedOnMC, text_basedOnMC = 'basedOnMC'; else, text_basedOnMC = 'allTunCFreeToVary';end

flag_plotPart1 = input('     >>> plot figures? ');
indBins = input('     >>> Index of bins: [1,3] or 1:3: ');

% folder name
nameFolderCompile_RC = 'Data_compile/RC';
nameFolderCompile_BEHAV = sprintf('Data_compile/BEHAV/%s', binStrategy); if isempty(dir(nameFolderCompile_BEHAV)), mkdir(nameFolderCompile_BEHAV), end
nameFigFolder = sprintf('Fig/Fig_%s', binStrategy);
nameFigFolder_BEHAV = sprintf('%s/BEHAV', nameFigFolder); if isempty(dir(nameFigFolder_BEHAV)), mkdir(nameFigFolder_BEHAV), end
nameFigFolder_RC = sprintf('%s/RC_%s', nameFigFolder, text_basedOnMC); if isempty(dir(nameFigFolder_RC)), mkdir(nameFigFolder_RC), end

%%
clc
for ill = 1:nll %input('     >>> Which location to compare (1=L18, 2=L67, 3=L53, 4=L24): ');
    iLocComb_all = iLocComb_all_all{ill};% delete
    
    ind_tunParams_perF{1} = [3 3 3];
    ind_tunParams_SF = {[3 3 3 3]	[3 3 1 3]	[3 1 3 3]	[3 3 2 3] % [0] equal
        [3 3 1 3]	[3 3 1 3]	[3 3 3 2]	[3 3 1 3]   % [1] algorithm
        [3 3 1 3 ]	[3 3 2 1]	[3 3 1 1]	[3 3 1 3]     % [2] manual_SX
        [3 3 2 3]	[3 3 1 3]	[3 3 1 3]	[3 3 2 3]}; % [3] manual_DT
    if flag_basedOnMC, ind_tunParams_perF{2} = ind_tunParams_SF{flag_binStrategy+1, ill};
    else, ind_tunParams_perF{2} = [3,3,3,3];
    end
    
    % ====== PRINT ======
    fprintf('\nnsubj = %d, nB = %d, %s\n\n%s vs. %s\nEnergy derived from %s patch (standardization=%d)\n\nORI: M%d %s [%s]\nSF: M%d %s [%s]\n', ...
        nsubj, nBoot, binStrategy, ...
        namesLocComb{iLocComb_all(1)}, namesLocComb{iLocComb_all(2)}, ...
        namesEnergySource{flag_PatchMode}, flag_standEnergy, ...
        ifamily_perF(1), namesFamily_all{ifamily_perF(1)}, num2str(ind_tunParams_perF{1}), ...
        ifamily_perF(2), namesFamily_all{ifamily_perF(2)}, num2str(ind_tunParams_perF{2}))
    
    % ====== group file name ======
    if flag_mirrorMapping, text_cut = '_m'; else, text_cut = ''; end
    
    nameFolderCompile_RC = sprintf('Data_compile/RC/%s_%s', binStrategy, text_basedOnMC);
    if isempty(dir(nameFolderCompile_RC)), mkdir(nameFolderCompile_RC), end
    nameFileBootGroup = sprintf('%s/n%d_B%d_L%d%d_%d_%d%s_ORI%dSF%d.mat', ...
        nameFolderCompile_RC, nsubj, nBoot, iLocComb_all, nORI, nSF, text_cut, ifamily_perF(1), ifamily_perF(2));
    
    dirBootGroup = dir(nameFileBootGroup);
    
    if isempty(dirBootGroup)
        
        % empty holders
%         similarityAfterMirroring_allSubj = nan(nsubj, nBoot, nBins, nLoc2, ntypes);
        kernels2D_allSubj = nan(nsubj, nBoot, nBins, nLoc2, ntypes, nORI, nSF);
        sep_allSubj = nan(nsubj, nBoot, nBins, nLoc2, ntypes);
        
        margORI_allSubj = nan(nsubj, nBoot, nBins, nLoc2, ntypes, nORI);
%         margORIraw_allSubj = nan(nsubj, nBoot, nBins, nLoc2, ntypes, nORI);
        margPredORI_allSubj = nan(nsubj, nBoot, nBins, nLoc2, ntypes, nORI);
%         margParams_ORI_allSubj = nan(nsubj, nBoot, nBins, nLoc2, ntypes, length(ind_tunParams_perF{1}));
        margTuningC_ORI_allSubj = nan(nsubj, nBoot, nBins, nLoc2, ntypes, nTuningC_ORI);
        margR2ORI_allSubj = nan(nsubj, nBoot, nBins, nLoc2, ntypes);
        
        margSF_allSubj = nan(nsubj, nBoot, nBins, nLoc2, ntypes, nSF);
        margPredSF_allSubj = nan(nsubj, nBoot, nBins, nLoc2, ntypes, nSF);
%         margParams_SF_allSubj = nan(nsubj, nBoot, nBins, nLoc2, ntypes, length(ind_tunParams_perF{2}));
        margTuningC_SF_allSubj = nan(nsubj, nBoot, nBins, nLoc2, ntypes, nTuningC_SF);
        margR2SF_allSubj = nan(nsubj, nBoot, nBins, nLoc2, ntypes);
        
        for isubj = 1:nsubj
            
            subjName = subjList{isubj};
            fprintf('\n\n%s (%d/%d)...\n', subjName, isubj, nsubj)
            
            % load boot data files
            if flag_cutMapping, nORI_load = nan; nSF_load = nan;
            else, nORI_load = nORI; nSF_load = nSF;
            end
            
            fprintf('Loading and compiling BOOTs...')
            
            for ibatch = 1:nBatches
                iB_start = (ibatch-1)*nB_perBatch+1;
                iB_end = ibatch*nB_perBatch;
                nameFileBoot_perBatch = sprintf('Data_OOD/%s/%s_batch%d_B%d_L%d%d_N%d_%d_%d%s_ORI%d_SF%d.mat', ...
                    subjName, subjName, ibatch, nB_perBatch, iLocComb_all, flag_standEnergy, nORI, nSF, text_cut, ifamily_perF);
                
                fprintf(' #%d ', ibatch)
                load(nameFileBoot_perBatch)
                
                % compile all subj
%                 similarityAfterMirroring_allSubj(isubj, iB_start:iB_end, :, :, :) = similarityAfterMirroring_allB;
                kernels2D_allSubj(isubj, iB_start:iB_end, :, :, :, :, :) = kernels2D_allB;
                sep_allSubj(isubj, iB_start:iB_end, :, :, :) = sep_allB;
                
                margORI_allSubj(isubj, iB_start:iB_end, :, :, :, :) = margORI_allB;
                margPredORI_allSubj(isubj, iB_start:iB_end, :, :, :, :) = margPredORI_allB;
%                 margParams_ORI_allSubj(isubj, iB_start:iB_end, :, :, :, :) = margParamsORI_allB;
                margTuningC_ORI_allSubj(isubj, iB_start:iB_end, :, :, :, :) = margTuningC_ORI_allB; % params2: tuning characteristics (tuningC)
                margR2ORI_allSubj(isubj, iB_start:iB_end, :, :, :) = margR2ORI_allB;
                
                margSF_allSubj(isubj, iB_start:iB_end, :, :, :, :) = margSF_allB;
                margPredSF_allSubj(isubj, iB_start:iB_end, :, :, :, :) = margPredSF_allB;
%                 margParams_SF_allSubj(isubj, iB_start:iB_end, :, :, :, :) = margParamsSF_allB;
                margTuningC_SF_allSubj(isubj, iB_start:iB_end, :, :, :, :) = margTuningC_SF_allB(:, :, :, :, 1:nTuningC_SF); % params2: tuning characteristics (tuningC)
                margR2SF_allSubj(isubj, iB_start:iB_end, :, :, :) = margR2SF_allB;
                
                if flag_ABSprefORI
                    margTuningC_ORI_allSubj(:, :, :, :, :, 1) = abs(margTuningC_ORI_allSubj(:, :, :, :, :, 1));
                end
                
                fprintf('.')
            end % ibatch
        end % end of isubj
        
        % save GROUP data
        fprintf('\n\nSaving...')
        clear markers_allSubj itype
        save(nameFileBootGroup, '*_allSubj')
        fprintf('DONE\n')
    else
        fprintf('Loading...')
        load(nameFileBootGroup)
        fprintf('DONE\n')
    end
    
    if flag_plotPart1
        %=========
        plotAll_part1
        %=========
    end
    
    fprintf('\n\n=================== DONE =================== \n')
    
end % ill

%%
% plotAll_part2
flag_zeroMean = 1;
type_tail = 'both'; % both// left: assume slope <0
plotAll_part2_2

fprintf('===DONE===\n')

