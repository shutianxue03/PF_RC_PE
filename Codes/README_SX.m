
% Created on Jul 27, 2024
% Research goal: to investigate 
% (1) whether contrast senstivity, featural representation, response consistency vary across sessions
% (2) whether the extent of eccentricity effect (EE), HVA and VMA vary across sessions, or, asked in another way, whether the extent of practice effect vary across locations
% (3) what can explain the practice effect in contrast sensitvity? by assessing whether the extent of practice effect in CS correlates with that of featural representation and resp consistency 

%% Location of analysis operation
% [Local]: codes are run on the local computer
%                  directory: /Volumes/purplab/EXPERIMENTS/1_Current_Experiments/Shutian_server/PF_RC_PE_SX
%                  also synced to David's and Shutian's GitHub
% [OOD]: computationally expensive processes will be run on HPC (high-performance computer) maintained

%% Abbreviations:
%     ORI: orientation
%     SF: spatial frequency
%     PRS: present (i.e., Gabor-present)
%     ABS: absent (i.e., Gabor-absent)
%     cst: contrast
% .   RT: response time 

%% Data [saved LOCAL]
% Data_OOD/subjName/
%        xx_behavMeas.mat: all the behavior data; and criterion + results for binning 
%        xx_energy_N_29_29.mat: energy profiles of all trials, nORI=29 ([5:5:50, 60:10:90]), nSF=29 (1-4 cpd in log steps)
%        [unfinished] xx_kernels_N_29_29.mat: kernels (2D mapping and marginalized ORI and SF) per single/combined location and per bin
%        [unfinished] xx_batchxx_B100_Lxx_N1_29_29_ORIxxSFxx.mat: for all bins, the boostrapped RC results per batch (1K bootstraps seperated into 10 batches)
% 
% Data_MC/subjName/Lxx/
%        [unfinished] Familyxx_modexx.mat
% 
% Data_compile:
% BinInfo_n15.mat: saved binning strategy and date info of each bin
% 
% Data_compile/BEHAV/

% Data_compile/RC/

%% Analysis pipeline
% 1. Extract time info of each session and decide binning strategy
%       Code: Shutian_server/PF_RC_2020/extractBinInfo.m
%           The last TWO sections (displaying&plotting info) is runnable here
%           However, others sections can only be run in ../Shutian_server/PF_RC_2020, where Data/ is located
%       Inputs/outputs: Data_compile/BinInfo_n15_nBins3_algorithm/manual.mat; also a copy of the real output in PF_RC_2020

% 2. Generate kernels per bin per location pair using non-bootstrapped data
% Code: SX_analysis2_Kernels.m
% Outputs: figures saved in Fig/Kernels/xx
%               ORI (top row) and SF (bottom row) tuning functions for paired locations (F vs. P, HM vs. VM, LVM vs. UVM)
%               there are nBins+1 figures for each binning strategy per
%               subj: the first three figures plot Bin #1 to the last bin separately, and the last figure plots tuning functions of all bins overlapping 

% 3. Model comparison (MC)
% Code: OOD_MC and SX_analysis3_MC
% Figures saved in MC/ should be the same for Fig_equal/algorithm and Fig_equal/algorithm_allTunCFreeToVary; 
% we saved figures in the latter


