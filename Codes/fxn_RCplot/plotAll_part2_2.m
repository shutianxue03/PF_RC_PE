

%%%%%%%%%%%%%%%% PART 2 %%%%%%%%%%%%%%%%
% focus on the correlation analysis

close all, clc

addpath(genpath('Data_compile/RC'))
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

iBin_lb = 1; iBin_ub = nBins; % compare the 1st and the last bin

%% plot performance
% clc, close all
%
% % iLocComb_all_all = {[1,8], [6,7], [5,3], [2,4]};
% fprintf('\n\nCompiling Behav data...\n')
% % fxn_compileBEHAV
% % fprintf('  DONE\n')
%
% nameFigFolder_BEHAV = sprintf('%s/BEHAV', nameFigFolder); if isempty(dir(nameFigFolder_BEHAV)), mkdir(nameFigFolder_BEHAV), end
% flag_plotIDVD = 1;
% flag_pairwiseComp = 1;
% flag_plotDiff = 0;
% %=========
% plotAll_Behav
% %=========
% close all

%% compile Fovea, HM, LVM and UVM
clc
paramMode=2;
% iLocComb_all_all = {[1,6,7], [1,6,5,3], [1,2,4,5,3]};
iLocComb_all_all = {[1,6,7], [1,6,5,3]};
iLocComb_all_all = {[1,6,5,3]};
nll = length(iLocComb_all_all);

PEtype_all = {'slope', 'perct'};
nPEtypes = length(PEtype_all);

for iPEtype = [2,1]
    for ill = 1:nll
        
        iLocComb_all = iLocComb_all_all{ill};
        nLoc = length(iLocComb_all);
        
        str_loc=[]; for iLoc = 1:nLoc, str_loc=[str_loc, num2str(iLocComb_all(iLoc))]; end
        
        % folder name
        nameFileLoc = sprintf('%s/n%d_B%d_L%s_%d_%d%s_ORI%dSF%d.mat', nameFolderCompile_RC, nsubj, nBoot, str_loc, nORI, nSF, text_cut, ifamily_perF);
        nameFigFolder_corr = sprintf('%s/corrPE/by_%s/L%s', nameFigFolder_RC, PEtype_all{iPEtype}, str_loc); if isempty(dir(nameFigFolder_corr)), mkdir(nameFigFolder_corr), end
        
        clc, fprintf('\n\nCompiling RC data of %d loc (abs pref ori=%d)...\n', nLoc, flag_ABSprefORI)
        
        %%%% compile CS and pA %%%%
        cs_allSubj_Loc4 = nan(nsubj, nBoot, nBins, nLoc);
        pA_allSubj_Loc4 = cs_allSubj_Loc4;
        
        load(sprintf('%s/n%d_B%d_perf_L18.mat', nameFolderCompile_BEHAV, nsubj, nBoot));
        cs_allSubj_Loc4(:, :, :, 1) = cs_allSubj(:, :, :, 1);
        pA_allSubj_Loc4(:, :, :, 1) = pA_allSubj(:, :, :, 1);
        
        switch nLoc
            case 3 % L167
                load(sprintf('%s/n%d_B%d_perf_L67.mat', nameFolderCompile_BEHAV, nsubj, nBoot));
                cs_allSubj_Loc4(:, :, :, [2,3]) = cs_allSubj;
                pA_allSubj_Loc4(:, :, :, [2,3]) = pA_allSubj;
                
            case 4 % L1653
                load(sprintf('%s/n%d_B%d_perf_L67.mat', nameFolderCompile_BEHAV, nsubj, nBoot));
                cs_allSubj_Loc4(:, :, :, 2) = cs_allSubj(:, :, :, 1);
                pA_allSubj_Loc4(:, :, :, 2) = pA_allSubj(:, :, :, 1);
                
                load(sprintf('%s/n%d_B%d_perf_L53.mat', nameFolderCompile_BEHAV, nsubj, nBoot));
                cs_allSubj_Loc4(:, :, :, [3,4]) = cs_allSubj;
                pA_allSubj_Loc4(:, :, :, [3,4]) = pA_allSubj;
                
            case 5 % L12453
                %                 load(sprintf('%s/n%d_B%d_perf_L24.mat', nameFolderCompile_BEHAV, nsubj, nBoot));
                %                 cs_allSubj_Loc4(:, :, :, [2,3]) = cs_allSubj;
                %                 cs_allSubj_Loc4(:, :, :, [2,3]) = cs_allSubj;
                %                 load(sprintf('%s/n%d_B%d_perf_L53.mat', nameFolderCompile_BEHAV, nsubj, nBoot));
                %                 cs_allSubj_Loc4(:, :, :, [4,5]) = cs_allSubj;
                %                 cs_allSubj_Loc4(:, :, :, [4,5]) = cs_allSubj;
        end
        
        %%%% compile RC %%%%
        %             similarityAfterMirroring_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes);
        %             sep_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes);
        
        %             margORI_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes, nORI);
        %             margPredORI_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes, nORI);
        %             margR2ORI_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes);
        %             margParams_ORI_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes, length(ind_tunParams_perF{1}));
        margTuningC_ORI_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes, nTuningC_ORI);
        
        %             margSF_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes, nSF);
        %             margPredSF_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes, nSF);
        %             margR2SF_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes);
        %             margParams_SF_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes, length(ind_tunParams_perF{2}));
        margTuningC_SF_4allSubj = nan(nsubj, nBoot, nBins, nLoc, ntypes, nTuningC_SF);
        
        load(sprintf('%s/n%d_B%d_L18_%d_%d%s_ORI%dSF%d.mat', nameFolderCompile_RC, nsubj, nBoot, nORI, nSF, text_cut, ifamily_perF));
        iiLoc4 = 1; iiLoc2 = 1; fxn_savePerLoc
        switch nLoc
            case 3 %  L167
                load(sprintf('%s/n%d_B%d_L67_%d_%d%s_ORI%dSF%d.mat', nameFolderCompile_RC, nsubj, nBoot, nORI, nSF, text_cut, ifamily_perF));
                iiLoc4 = 2; iiLoc2 = 1; fxn_savePerLoc
                iiLoc4 = 3; iiLoc2 = 2; fxn_savePerLoc
                
            case 4 %  L1653
                % Get data on HM (L6)
                load(sprintf('%s/n%d_B%d_L67_%d_%d%s_ORI%dSF%d.mat', nameFolderCompile_RC, nsubj, nBoot, nORI, nSF, text_cut, ifamily_perF));
                iiLoc4 = 2; iiLoc2 = 1; fxn_savePerLoc
                % Get data on LVM and UVM (L5 and L3)
                load(sprintf('%s/n%d_B%d_L53_%d_%d%s_ORI%dSF%d.mat', nameFolderCompile_RC, nsubj, nBoot, nORI, nSF, text_cut, ifamily_perF));
                iiLoc4 = 3; iiLoc2 = 1; fxn_savePerLoc
                iiLoc4 = 4; iiLoc2 = 2; fxn_savePerLoc
                
            case 5 %  L12453
                %                 % Get data on HM (L2 and L4)
                %                 load(sprintf('%s/n%d_B%d_L24_%d_%d%s_ORI%dSF%d.mat', nameFolderCompile_RC, nsubj, nBoot, nORI, nSF, text_cut, ifamily_perF));
                %                 iiLoc4 = 2; iiLoc2 = 1; fxn_savePerLoc
                %                 iiLoc4 = 3; iiLoc2 = 2; fxn_savePerLoc
                %                 % Get data on LVM and UVM (L5 and L3)
                %                 load(sprintf('%s/n%d_B%d_L53_%d_%d%s_ORI%dSF%d.mat', nameFolderCompile_RC, nsubj, nBoot, nORI, nSF, text_cut, ifamily_perF));
                %                 iiLoc4 = 4; iiLoc2 = 1; fxn_savePerLoc
                %                 iiLoc4 = 5; iiLoc2 = 2; fxn_savePerLoc
                
        end % switch iLoc
        
        fprintf('  DONE\n')
        
        %% corr between PE in CS and tunC
        clc, close all
        switch flag_zeroMean
            case 0
                switch iPEtype
                    case 1, x_ticks = round(linspace(-.2, .5, 5),2); %type_corr = 'kendall';% slope
                    case 2, x_ticks = round(linspace(-10, 20, 5),1); %type_corr = 'kendall';% a-b/(a+b)
                end
            case 1
                switch iPEtype
                    case 1, x_ticks = round(linspace(-.5, .5, 5),2); %type_corr = 'kendall';% slope
                    case 2, x_ticks = round(linspace(-16, 16, 5),1); %type_corr = 'kendall';% a-b/(a+b)
                end
        end
        
        % Calculate PE for CS and pA
        switch iPEtype
            case 1 % slope
                PE_CS = nan(nsubj, nBoot, nLoc);
                PE_pA = PE_CS;
                for isubj=1:nsubj
                    for iBoot=1:nBoot
                        for iLoc=1:nLoc
                            lm_CS = polyfit(1:nBins, squeeze(cs_allSubj_Loc4(isubj, iBoot, :, iLoc))', 1);
                            PE_CS(isubj, iBoot, iLoc) = lm_CS(1);
                            lm_pA = polyfit(1:nBins, squeeze(pA_allSubj_Loc4(isubj, iBoot, :, iLoc))', 1);
                            PE_pA(isubj, iBoot, iLoc) = lm_pA(1);
                        end
                    end
                end
                
            case 2 % (a-b)/(a+b)
                PE_CS = (cs_allSubj_Loc4(:, :, iBin_ub, :)-cs_allSubj_Loc4(:, :, iBin_lb, :))./(cs_allSubj_Loc4(:, :, iBin_ub, :)+cs_allSubj_Loc4(:, :, iBin_lb, :)) *100;
                PE_pA = (pA_allSubj_Loc4(:, :, iBin_ub, :)-pA_allSubj_Loc4(:, :, iBin_lb, :))./(pA_allSubj_Loc4(:, :, iBin_ub, :)+pA_allSubj_Loc4(:, :, iBin_lb, :)) *100;
        end
        PE_CS = getCI(PE_CS, 1, 2);
        PE_pA = getCI(PE_pA, 1, 2);
        
        % CS vs. tunC
        for ifeature=1:2
            ifamily = ifamily_perF(ifeature);
            namesTunC = namesTunC_unit_perF{ifamily, paramMode};
            nTunC_full = length(namesTunC);
            
            if ifeature==1, margTuningC_4allSubj = margTuningC_ORI_4allSubj;
            else, margTuningC_4allSubj = margTuningC_SF_4allSubj;
            end
            
            for iTunC = 1:nTunC_full
                switch iPEtype
                    case 1
                        switch ifamily
                            case 1, y_ticks = {linspace(-40,40, 5), linspace(-.06,.06, 5), linspace(-40,40, 5), linspace(-.04,.04, 5)};
                            case 2, y_ticks = {linspace(-1,1, 5), linspace(-.03,.05, 5), linspace(-.4,.4, 5), linspace(-.04,.04, 5)};
                        end
                    case 2
                        switch ifamily
                            case 1, y_ticks = {linspace(-140,140, 5), linspace(-90,90, 5), linspace(-50,50, 5), linspace(-300,300, 5)};
                            case 2, y_ticks = {linspace(-60,60, 5), linspace(-90,90, 5), linspace(-90,90, 5), linspace(-300,300, 5)};
                        end
                end
                y_ticks = y_ticks{iTunC};
                
                % Calculate PE for tunC
                margTuningC_ = squeeze(margTuningC_4allSubj(:, :, :, :, itype, iTunC));
                switch iPEtype
                    case 1 % slope
                        PE_tunC = nan(nsubj, nBoot, nLoc);
                        for isubj=1:nsubj
                            for iBoot=1:nBoot
                                for iLoc=1:nLoc
                                    lm = polyfit(1:nBins, squeeze(margTuningC_(isubj, iBoot, :, iLoc))', 1);
                                    PE_tunC(isubj, iBoot, iLoc) = lm(1);
                                end
                            end
                        end
                        
                    case 2 % (a-b)/(a+b)
                        PE_tunC = (margTuningC_(:, :, iBin_ub, :)-margTuningC_(:, :, iBin_lb, :))./(margTuningC_(:, :, iBin_ub, :)+margTuningC_(:, :, iBin_lb, :))*100;
                end
                PE_tunC = getCI(PE_tunC, 1, 2);
                
                text_title = sprintf('%s, by %s [%s %s] zeroMean=%d %s', binStrategy, PEtype_all{iPEtype}, namesFeature{ifeature}, namesTunC{iTunC}, flag_zeroMean, type_tail);
                basicFxn_drawCorrPE(PE_CS, PE_tunC, colors_perBinPerComb(iBin_ub, iLocComb_all), ...
                    x_ticks, y_ticks, x_ticks, y_ticks, flag_zeroMean, type_tail, text_title, markers_allSubj);
                if flag_zeroMean==0, xline(0, 'color', [.5, .5, .5], 'linewidth', 2); yline(0, 'color', [.5, .5, .5], 'linewidth', 2); end
                
                saveas(gcf, sprintf('%s/n%d_%s%d.jpg', nameFigFolder_corr, nsubj, namesFeature{ifeature}, iTunC))
            end % iTunC
        end % ifeature
        
        % ==== CS vs. pA ====
        switch flag_zeroMean
            case 0
                switch iPEtype
                    case 1, y_ticks = linspace(-.06, .08, 5);
                    case 2, y_ticks = linspace(-10, 10, 5);
                end
            case 1
                switch iPEtype
                    case 1, y_ticks = linspace(-.1, .1, 5);
                    case 2, y_ticks = linspace(-12, 12, 5);
                end
        end
        text_title = sprintf('%s, by %s [pA] zeroMean=%d %s', binStrategy, PEtype_all{iPEtype}, flag_zeroMean, type_tail);
        %----------------------------------------%
        basicFxn_drawCorrPE(PE_CS, PE_pA, colors_perBinPerComb(iBin_ub, iLocComb_all), ...
            x_ticks, y_ticks, x_ticks, y_ticks, flag_zeroMean, type_tail, text_title, markers_allSubj);
        %----------------------------------------%
        if flag_zeroMean==0, xline(0, 'color', [.5, .5, .5], 'linewidth', 2); yline(0, 'color', [.5, .5, .5], 'linewidth', 2); end
        saveas(gcf, sprintf('%s/n%d_pA.jpg', nameFigFolder_corr, nsubj))
        
        close all
    end % ill=1:nll
end % iPEtype
