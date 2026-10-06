close all

flag_plotIDVD = 1;
flag_pairwiseComp = 1;
flag_plotDiff = 0;

ipA = 1; % obtain pA from 1=all trials; 2=PRS; 3=ABS
ipC = 1;

%% compile
nameFileLoc='L';

for il=1:length(iLocComb_all)
    nameFileLoc = [nameFileLoc, num2str(iLocComb_all(il))];
end
% fprintf('   %s...', nameFileLoc)

nameFilePerf = sprintf('%s/n%d_B%d_perf_%s.mat', nameFolderCompile_BEHAV, nsubj, nBoot, nameFileLoc);
dirPerf_selected = dir(nameFilePerf);

for iperf = 1:6 % 1=CS, 2=pA, 3=dprime, 4=criterion, 5=RT, 6=pC
    perf_ave_allSubj = nan(nsubj, nBoot, nBins, length(iLocComb_all));
    
    for isubj = 1:nsubj
        subjName = subjList{isubj};
        %             nSess = nblocks_allSubj(isubj)/5;
        load(sprintf('Data_OOD/%s/%s_behavMeas', subjName, subjName), '*perSess_perLoc')
        %             assert(nSess == size(cst_perSess_perLoc, 1));
        
        % load binning strategy
        load(sprintf('Data_compile/BinStrategy/BinInfo_n%d_nBins%d_%s.mat', nsubj, nBins, binStrategy), 'iSess_start_perBin_allSubj', 'iSess_end_perBin_allSubj', 'nSess_perBin_allSubj')
        iSess_start_perBin = iSess_start_perBin_allSubj{isubj};
        iSess_end_perBin = iSess_end_perBin_allSubj{isubj};
        nSess_perBin = nSess_perBin_allSubj{isubj};
        
        for iBin=1:nBins
            % select sessions
            indSess = iSess_start_perBin(iBin): iSess_end_perBin(iBin);
            
            switch iperf
                case 1, perf_perLoc = 1./cst_perSess_perLoc(indSess, :);
                case 2, perf_perLoc = squeeze(pA3_perSess_perLoc(indSess,:, ipA));
                case 3, perf_perLoc = squeeze(dprime_perSess_perLoc(indSess, :));
                case 4, perf_perLoc = squeeze(criterion_perSess_perLoc(indSess, :));
                case 5, perf_perLoc = squeeze(RT_perSess_perLoc(indSess, :));
                case 6, perf_perLoc = squeeze(pC3_perSess_perLoc(indSess, :, ipC));
            end
            
            switch length(iLocComb_all)
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                case 2
                    switch iLocComb_all(1)
                        case 1 % 1 vs. 8
                            perf_ave1 = mean(perf_perLoc(:, 1));
                            perf_ave2 = perf_perLoc(:, 2:5); perf_ave2 = mean(perf_ave2(:));
                        case 5 % 5 vs. 3
                            perf_ave1 = mean(perf_perLoc(:, 5));
                            perf_ave2 = mean(perf_perLoc(:, 3));
                        case 6 % 6 vs. 7
                            perf_ave1 = perf_perLoc(:, [2,4]); perf_ave1 = mean(perf_ave1(:));
                            perf_ave2 = perf_perLoc(:, [5,3]); perf_ave2 = mean(perf_ave2(:));
                        case 2 % 2 vs. 4
                            perf_ave1 = mean(perf_perLoc(:, 2));
                            perf_ave2 = mean(perf_perLoc(:, 4));
                        case 4 % 4 vs. 7
                            perf_ave1 = mean(perf_perLoc(:, 4));
                            perf_ave2 = perf_perLoc(:, [5,3]); perf_ave2 = mean(perf_ave2(:));
                    end
                    perf_ave_allSubj(isubj, :, iBin, :) = repmat([perf_ave1, perf_ave2], nBoot, 1);
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                case 3
                    perf_ave6 = perf_perLoc(:, [2,4]); perf_ave6 = mean(perf_ave6(:));
                    perf_ave5 = mean(perf_perLoc(:, 5));
                    perf_ave3 = mean(perf_perLoc(:, 3));
                    perf_ave_allSubj(isubj, :, iBin, :) = repmat([perf_ave6, perf_ave5, perf_ave3], nBoot, 1);
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                case 4
                    perf_ave2 = mean(perf_perLoc(:, 2));
                    perf_ave3 = mean(perf_perLoc(:, 3));
                    perf_ave4 = mean(perf_perLoc(:, 4));
                    perf_ave5 = mean(perf_perLoc(:, 5));
                    perf_ave_allSubj(isubj, :, iBin, :) = repmat([perf_ave2, perf_ave4, perf_ave5, perf_ave3], nBoot, 1);
            end
        end
    end % isubj
    
    %%%%%%%%%%%%%
    switch iperf
        case 1, cs_allSubj = perf_ave_allSubj;
        case 2, pA_allSubj = perf_ave_allSubj;
        case 3, dprime_allSubj = perf_ave_allSubj;
        case 4, criterion_allSubj = perf_ave_allSubj;
        case 5, RT_allSubj = perf_ave_allSubj;
        case 6, pC_allSubj = perf_ave_allSubj;
    end
end % iperf

save(nameFilePerf, 'cs_allSubj', 'pA_allSubj', 'dprime_allSubj', 'criterion_allSubj', 'RT_allSubj', 'pC_allSubj')
clear *perSess_perLoc
fprintf(' SAVED\n')

%% plot
% nLocPairs = length(iLocComb_all_all);
nBars = length(iLocComb_all);

sz_wd_perBar = 200;
sz_h = 400; % height of the figure
sz_fig = [nBars*sz_wd_perBar sz_h];

nameFileBehav = sprintf('L%d%d', iLocComb_all);

% load group behav data
load(sprintf('%s/n%d_B%d_perf_%s.mat', nameFolderCompile_BEHAV, nsubj, nBoot, nameFileBehav))

for iPerf = 1:6
    switch iPerf
        case 1
            perf_allSubj = cs_allSubj;
            namePerf = 'CS';
            ticks_scatter = linspace(1.5, 3.9, 5);
            yline_ = nan;
        case 2
            perf_allSubj = pA_allSubj*1e2;
            namePerf = 'pA';
            ticks_scatter = linspace(50, 90, 5);
            yline_ = nan;
        case 3
            perf_allSubj = dprime_allSubj;
            namePerf = 'dprime';
            ticks_scatter = linspace(0, 2, 5);
            yline_ = dprime_theo;
        case 4
            perf_allSubj = criterion_allSubj;
            namePerf = 'criterion';
            ticks_scatter = linspace(-1, 1, 5);
            yline_ = 0;
        case 5
            perf_allSubj = RT_allSubj*1e3+500;% convert to ms
            namePerf = 'RT';
            ticks_scatter = linspace(0, 300, 5)+500;
            yline_ = 0;
        case 6
            perf_allSubj = pC_allSubj*1e2;% convert to %
            namePerf = 'pC';
            ticks_scatter = linspace(50, 90, 5);
            yline_ = 70;
    end
    
    colors = colors_perBinPerComb(:, iLocComb_all);
    title_ = sprintf('%s [%s vs. %s] - %s', namePerf, namesLocComb{iLocComb_all}, binStrategy);
    
    % 1. raw values
    basicFxn_drawBars2(getCI(perf_allSubj(:, :, indBins, :), 1, 2), yline_, colors, ticks_scatter, round(ticks_scatter, 2), flag_plotIDVD, title_, sz_fig, markers_allSubj)
    saveas(gcf, sprintf('%s/n%d_%s_%s_nBins%d.jpg', nameFigFolder_BEHAV, nsubj, namePerf, nameFileBehav, length(indBins)))
    
    % posthoc
    %     for iBin
    
    % 2. 1st vs. last bin
    %     PE = (perf_allSubj(:, :, iBin_ub, :)-perf_allSubj(:, :, iBin_lb, :))./(perf_allSubj(:, :, iBin_ub, :)+perf_allSubj(:, :, iBin_lb, :))*100;
    %     basicFxn_drawBars(getCI(PE, 1, 2), nan, colors(iBin_ub,:), {'', ''}, linspace(-100, 100, 5), linspace(-100, 100, 5), flag_plotIDVD, flag_plotDiff, '', flag_pairwiseComp, [200 400])
end % iperf

