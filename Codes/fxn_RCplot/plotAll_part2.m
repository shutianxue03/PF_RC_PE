

%%%%%%%%%%%%%%%% PART 2 %%%%%%%%%%%%%%%%
% focus on the correlation analysis

close all, clc

% addpath(genpath('Data_compile/RC'))
% addpath(genpath('fxn_analysis_RC_v2'))

%%
%--------------%
SX_RC1_setting
% %--------------%
fileName_NOM = 'ORI29SF29';
fprintf('\nnsubj=%d, %s\n', nsubj, fileName_NOM)

% settings
flag_standEnergy = 1;
flag_mirrorMapping = 1;
itype = 2; % 1=PRS, 2=ABS, 3=BOTH

% setting of tuning functions
clc
nORI = 29; nSF = 29; fileName = '2929_m';
name_numFilters_Fitting = sprintf('%d_%d_ORI%d_SF%d', nORI, nSF, ifamily_perF);
if flag_mirrorMapping == 1, name_numFilters_Fitting = sprintf('%d_%d_m_ORI%d_SF%d', nORI, nSF, ifamily_perF); end

nTuningC_ORI = length(namesTunC_unit_perF{ifamily_perF(1), 2}); % preferred ori, peak amp, bandwidth, bottom, // pred_half
nTuningC_SF = length(namesTunC_unit_perF{ifamily_perF(2), 2}); % peakSF, peak amp., bandwidth_full (octave), baseline // bandwidth_L, bandwidth_R, bottom, pred_half, full bandwidth (linear scale)
ind_tunParams_perF{1} = nTuningC_ORI;
ind_tunParams_perF{2} = nTuningC_SF;

%% compile performance (L18, L67, L53)
clc
nameFolderCompile_BEHAV = sprintf('Data_compile/BEHAV/%s', binStrategy); if isempty(dir(nameFolderCompile_BEHAV)), mkdir(nameFolderCompile_BEHAV), end
iLocComb_all_all = {[1,8], [6,7], [5,3], [2,4]};
fxn_compileBEHAV

%% plot performance
close all
nameFigFolder_BEHAV = sprintf('%s/BEHAV', nameFigFolder); if isempty(dir(nameFigFolder_BEHAV)), mkdir(nameFigFolder_BEHAV), end
flag_plotIDVD = 1;
flag_pairwiseComp = 1;
flag_plotDiff = 0;
%=========
plotAll_Behav
%=========
close all

%% compile Fovea, HM, LVM and UVM
clc
iLocComb_all_all = {[1,6,7], [1,6,5,3], [1,2,4,5,3]};
% iLocComb_all = [1,6,7];
% iLocComb_all = [1,6,5,3];
% iLocComb_all = [1,2,4,5,3];

for ill = 1:3
    iLocComb_all = iLocComb_all_all{ill};
    
    nLoc = length(iLocComb_all);
    str_loc=[]; for iLoc = 1:nLoc, str_loc=[str_loc, num2str(iLocComb_all(iLoc))]; end
    nameFileLoc = sprintf('%s/n%d_B%d_L%s_%d_%d%s_ORI%dSF%d.mat', ...
        nameFolderCompile_RC, nsubj, nBoot, str_loc, nORI, nSF, text_cut, ifamily_perF);
    
    clc, fprintf('\n\nCompiling RC data of %d loc (abs pref ori=%d)...\n', nLoc, flag_ABSprefORI)
    
    if isempty(dir(nameFileLoc))
        % empty folders
        similarityAfterMirroring_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes);
        sep_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes);
        
        margORI_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes, nORI);
        margPredORI_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes, nORI);
        margR2ORI_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes);
        margParams_ORI_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes, length(ind_tunParams_perF{1}));
        margTuningC_ORI_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes, nTuningC_ORI);
        
        margSF_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes, nSF);
        margPredSF_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes, nSF);
        margR2SF_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes);
        margParams_SF_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes, length(ind_tunParams_perF{2}));
        margTuningC_SF_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes, nTuningC_SF);
        
        %%%%%%%%%
        for isubj = 1:nsubj
            subjName = subjList{isubj}; fprintf('  %s (%d/%d)...', subjName, isubj, nsubj)
            
            for ibatch = 1:nBatches
                iB_start = (ibatch-1)*nB_perBatch+1;
                iB_end = ibatch*nB_perBatch;
                
                % Get data on fovea (L1)
                load(sprintf('Data_OOD/%s/%s_batch%d_B%d_L18_N%d_%d_%d%s_ORI%d_SF%d.mat', ...
                    subjName, subjName, ibatch, nB_perBatch, flag_standEnergy, nORI, nSF, text_cut, ifamily_perF));
                iiLoc4 = 1; iiLoc2 = 1; fxn_savePerLoc4
                
                switch nLoc
                    %%%%%%%%%
                    %  L167
                    %%%%%%%%%
                    case 3
                        % Get data on HM (L6)
                        load(sprintf('Data_OOD/%s/%s_batch%d_B%d_L67_N%d_%d_%d%s_ORI%d_SF%d.mat', ...
                            subjName, subjName, ibatch, nB_perBatch, flag_standEnergy, nORI, nSF, text_cut, ifamily_perF));
                        iiLoc4 = 2; iiLoc2 = 1; fxn_savePerLoc4
                        iiLoc4 = 3; iiLoc2 = 2; fxn_savePerLoc4
                        
                        %%%%%%%%%
                        %  L1653
                        %%%%%%%%%
                    case 4
                        % Get data on HM (L6)
                        load(sprintf('Data_OOD/%s/%s_batch%d_B%d_L67_N%d_%d_%d%s_ORI%d_SF%d.mat', ...
                            subjName, subjName, ibatch, nB_perBatch, flag_standEnergy, nORI, nSF, text_cut, ifamily_perF));
                        iiLoc4 = 2; iiLoc2 = 1; fxn_savePerLoc4
                        % Get data on LVM and UVM (L5 and L3)
                        load(sprintf('Data_OOD/%s/%s_batch%d_B%d_L53_N%d_%d_%d%s_ORI%d_SF%d.mat', ...
                            subjName, subjName, ibatch, nB_perBatch, flag_standEnergy, nORI, nSF, text_cut, ifamily_perF));
                        iiLoc4 = 3; iiLoc2 = 1; fxn_savePerLoc4
                        iiLoc4 = 4; iiLoc2 = 2; fxn_savePerLoc4
                        
                        %%%%%%%%%
                        %  L12345
                        %%%%%%%%%
                    case 5
                        % Get data on HM (L2 and L4)
                        load(sprintf('Data_OOD/%s/%s_batch%d_B%d_L24_N%d_%d_%d%s_ORI%d_SF%d.mat', ...
                            subjName, subjName, ibatch, nB_perBatch, flag_standEnergy, nORI, nSF, text_cut, ifamily_perF));
                        iiLoc4 = 2; iiLoc2 = 1; fxn_savePerLoc4
                        iiLoc4 = 3; iiLoc2 = 2; fxn_savePerLoc4
                        % Get data on LVM and UVM (L5 and L3)
                        load(sprintf('Data_OOD/%s/%s_batch%d_B%d_L53_N%d_%d_%d%s_ORI%d_SF%d.mat', ...
                            subjName, subjName, ibatch, nB_perBatch, flag_standEnergy, nORI, nSF, text_cut, ifamily_perF));
                        iiLoc4 = 4; iiLoc2 = 1; fxn_savePerLoc4
                        iiLoc4 = 5; iiLoc2 = 2; fxn_savePerLoc4
                        
                end
                
            end
            fprintf('DONE\n')
        end % isubj
        % clear metrics_4allSubj
        
        fprintf('\nSaving...'), tic
        save(nameFileLoc, '*_4allSubj')
    else
        fprintf('\nLoading...'), tic
        load(nameFileLoc, '*_4allSubj')
    end
    dur = toc; fprintf('  DONE (Dur %.1f min)\n', dur/60)
    close all
    
    %% similarity and separability
    flag_plotIDVD = 1;
    flag_plotDiff = 0;
    flag_pairwiseComp = 0;
    sz_fig = [600 400];
    
    nameFigFolder_RC_sep = sprintf('%s/sep', nameFigFolder_RC); if isempty(dir(nameFigFolder_RC_sep)), mkdir(nameFigFolder_RC_sep), end
    data_med = getCI(sep_4allSubj(:, :, :, :, itype), 1, 2);
    colors = colors_perBinPerComb(:, iLocComb_all);
    text_title = sprintf('n%d L%s %s', nsubj, str_loc, binStrategy);
    
    basicFxn_drawBars2(data_med, [], colors, '', linspace(.4, 1, 5), linspace(.4, 1, 5), flag_plotIDVD, flag_plotDiff, text_title, flag_pairwiseComp, sz_fig);
    saveas(gcf, sprintf('%s/n%d_L%s_nBins%d.jpg', nameFigFolder_RC_sep, nsubj, str_loc, nBins))
    
    close all
    
    %% corr between PE in CS and tunC
    clc, close all
    flag_zeroMean = 0;
    type_corr = 'kendall';
    type_tail = 'both'; % both// left: assume slope <0
    iBin_lb = 1; iBin_ub = nBins; % compare the 1st and the last bin
    x_ticks = linspace(-10, 22, 5);
    
    nameFigFolder_corr = sprintf('%s/corrPE/L%s', nameFigFolder_RC, str_loc); if isempty(dir(nameFigFolder_corr)), mkdir(nameFigFolder_corr), end
    
    cs_allSubj_Loc4 = nan(nsubj, nBoot, nBins, nLoc);
    load(sprintf('%s/n%d_B%d_perf_L18.mat', nameFolderCompile_BEHAV, nsubj, nBoot));
    iLoc4=1; iLoc2=1; cs_allSubj_Loc4(:, :, :, iLoc4) = cs_allSubj(:, :, :, iLoc2);
    switch nLoc
        case 3
            load(sprintf('%s/n%d_B%d_perf_L67.mat', nameFolderCompile_BEHAV, nsubj, nBoot));
            iLoc4=2; iLoc2=1; cs_allSubj_Loc4(:, :, :, iLoc4) = cs_allSubj(:, :, :, iLoc2);
            iLoc4=3; iLoc2=2; cs_allSubj_Loc4(:, :, :, iLoc4) = cs_allSubj(:, :, :, iLoc2);
        case 4
            load(sprintf('%s/n%d_B%d_perf_L67.mat', nameFolderCompile_BEHAV, nsubj, nBoot));
            iLoc4=2; iLoc2=1; cs_allSubj_Loc4(:, :, :, iLoc4) = cs_allSubj(:, :, :, iLoc2);
            load(sprintf('%s/n%d_B%d_perf_L53.mat', nameFolderCompile_BEHAV, nsubj, nBoot));
            iLoc4=3; iLoc2=1; cs_allSubj_Loc4(:, :, :, iLoc4) = cs_allSubj(:, :, :, iLoc2);
            iLoc4=4; iLoc2=2; cs_allSubj_Loc4(:, :, :, iLoc4) = cs_allSubj(:, :, :, iLoc2);
        case 5
            load(sprintf('%s/n%d_B%d_perf_L24.mat', nameFolderCompile_BEHAV, nsubj, nBoot));
            iLoc4=2; iLoc2=1; cs_allSubj_Loc4(:, :, :, iLoc4) = cs_allSubj(:, :, :, iLoc2);
            iLoc4=3; iLoc2=2; cs_allSubj_Loc4(:, :, :, iLoc4) = cs_allSubj(:, :, :, iLoc2);
            load(sprintf('%s/n%d_B%d_perf_L53.mat', nameFolderCompile_BEHAV, nsubj, nBoot));
            iLoc4=4; iLoc2=1; cs_allSubj_Loc4(:, :, :, iLoc4) = cs_allSubj(:, :, :, iLoc2);
            iLoc4=5; iLoc2=2; cs_allSubj_Loc4(:, :, :, iLoc4) = cs_allSubj(:, :, :, iLoc2);
    end
    
    paramMode=2;
    
    CS_lb = getCI(cs_allSubj_Loc4(:, :, iBin_lb, :), 1, 2);
    CS_ub = getCI(cs_allSubj_Loc4(:, :, iBin_ub, :), 1, 2);
    PE_CS = (CS_ub-CS_lb)./(CS_lb+CS_ub) *100;
    
    for ifeature=1:2
        ifamily = ifamily_perF(ifeature);
        namesTunC = namesTunC_unit_perF{ifamily, paramMode};
        nTunC_full = length(namesTunC);
        
        if ifeature==1, margTuningC_4allSubj = margTuningC_ORI_4allSubj;
        else, margTuningC_4allSubj = margTuningC_SF_4allSubj;
        end
        
        for iTunC = 1:nTunC_full
            switch ifamily
                case 1, y_ticks = {linspace(-120,120, 5), linspace(-80,80, 5), linspace(-80,80, 5), linspace(-300,300, 5)};
                case 2, y_ticks = {linspace(-60,60, 5), linspace(-80,80, 5), linspace(-80,80, 5), linspace(-300,300, 5)};
            end
            
            tunC_lb = getCI(margTuningC_4allSubj(:, :, iBin_lb, :, itype, iTunC), 1, 2);
            tunC_ub = getCI(margTuningC_4allSubj(:, :, iBin_ub, :, itype, iTunC), 1, 2);
            PE_tunC = (tunC_ub-tunC_lb)./(tunC_lb+tunC_ub)*100;
            
            text_title = sprintf('%s %s %s \nzeroMean=%d, %s %s', ...
                namesFeature{ifeature}, namesTunC{iTunC}, binStrategy, flag_zeroMean, type_corr, type_tail);
            
            basicFxn_drawCorrPE(PE_CS, PE_tunC, colors_perBinPerComb(iBin_ub, iLocComb_all), ...
                x_ticks, y_ticks{iTunC}, x_ticks, y_ticks{iTunC}, flag_zeroMean, type_corr, type_tail, text_title, markers_allSubj);
            if flag_zeroMean==0, xline(0, 'color', [.5, .5, .5], 'linewidth', 2); yline(0, 'color', [.5, .5, .5], 'linewidth', 2); end
            saveas(gcf, sprintf('%s/n%d_%s%d.jpg', nameFigFolder_corr, nsubj, namesFeature{ifeature}, iTunC))
        end
    end
    close all
    
end
