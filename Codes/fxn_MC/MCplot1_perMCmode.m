

nameFigFolder_MC_rank = sprintf('%s/rank', nameFigFolder_MC); if isempty(dir(nameFigFolder_MC_rank)), mkdir(nameFigFolder_MC_rank), end

errorbar_down = 10; % default=1 (not reduce siz eof errorbar)
indCand = 1:nCands;
nCand_show = 6; % only show the first xx models in the rank
wd_border = 2; % default 5
sz_ticks = 20; % 30
sz_fig_rank = [400 400];
sz_fig_box = [400 nTunParams*30];

if MCmode==1
    y_ticks_all = {linspace(-1, 1, 5)/1e4, linspace(-6, 14, 5)/1e5};
elseif MCmode==3
    y_ticks_all = {linspace(0, 40, 5), linspace(0, 20, 5)};
end

for iIC = 1:nIC_
    
    % get the freq and ranked imodel (max freq to min)
    [freq, iBest_freq] = groupcounts(iBest_allSubj(:, iIC)); % sorted by iBest_best (from min to max), not by freq!!
    [freq, ii] = sort(freq, 'descend');
    iBest_freq = iBest_freq(ii); % because the output of groupcounts sort from min to max
    nChosen = length(freq);
    
    dev_groupAVE = squeeze(mean(dev_allSubj(:, :, iIC)));
    dev_groupSEM = squeeze(std(dev_allSubj(:, :, iIC)))/sqrt(nsubj);
    %     dev_groupSEM = withinSubjErr(dev_allSubj(:, :, iIC));
    [~, irank_groupAVE] = sort(dev_groupAVE); % sort based on averaged dev (for CV) for IC
    iBEST_groupAVE = irank_groupAVE(1);
    dev_delta = dev_groupAVE-min(dev_groupAVE);
    
    %% save the dev for comparing across MCmode and families
    if MCmode == 3
        dev_bestGroup_perModePerFamily{ifamily, MCmode, iIC} = dev_allSubj(:, iBEST_groupAVE, iIC);
        ibestGroup_perModePerFamily{ifamily, MCmode, iIC} = ind_tunParam_all(iBEST_groupAVE, :);
    else
        dev_bestGroup_perModePerFamily{ifamily, MCmode, 1} = dev_allSubj(:, iBEST_groupAVE, 1);
        ibestGroup_perModePerFamily{ifamily, MCmode, 1} = ind_tunParam_all(iBEST_groupAVE, :);
    end
    
    %%  dev AVE
    
    
    % ====== 1. Symbol legends ======
    figure('Position', [0 0 sz_fig_box]), hold on
    yrange = y_ticks_all{ifeature}(end) - y_ticks_all{ifeature}(1);
    buffer = yrange/12;
    ymax = y_ticks_all{ifeature}(end)-buffer/5;
    sz_marker = 18;
    
    for iModel = 1:nCand_show
        if iModel==1, color_edge = [0,0,0];
        else, color_edge = ones(1,3)/2;
        end
        x = iModel;
        for iParam = 1:size(ind_tunParam_all, 2)
            y = ymax - (iParam-1)*buffer;
            
            color_face='w';
            m=markers_allVar{ind_tunParam_all(irank_groupAVE(iModel), iParam)+1};
            
            plot(x, y, m, 'markerfacecolor', color_face, 'markeredgecolor', color_edge, 'markersize', sz_marker)
        end
    end
    
    axis off
    set(findall(gcf, '-property', 'LineWidth'), 'LineWidth',wd_border)
    
    % save legend figure
    if MCmode==3
        saveas(gcf, sprintf('%s/devBOX_n%d_M%d_%s.jpg', nameFigFolder_MC_rank, nsubj, ifamily, namesIC{iIC}))
    else
        saveas(gcf, sprintf('%s/devBOX_n%d_M%d_%s.jpg', nameFigFolder_MC_rank, nsubj, ifamily, namesMCmode{MCmode}))
    end
    
    % ====== 2. Deviance ======
    if MCmode == 3
        if ifamily==12,figure('Position', [0 0 800 2000])
        else, figure('Position', [0 0 sz_fig_rank])
        end
    else
        figure('Position', [0 0 sz_fig_rank])
    end
    
    hold on%, grid on % so taht adding boxes are convenient
    bar(indCand(1:nCand_show), dev_delta(irank_groupAVE(1:nCand_show)), 'BarWidth', .5, 'FaceColor', ones(1,3)*.5, 'Edgecolor', ones(1,3)*.5)
    if flag_devErrorbar
        errorbar(indCand(1:nCand_show), dev_delta(irank_groupAVE(1:nCand_show)), dev_groupSEM(1:nCand_show), '.k', 'CapSize', 0)
    end
    
    % plot the best candidate model of the baiquan model
    %     if ifeature==1, dev_baiquan = .0008843; SEM_baiquan = .0001894;
    %     else, dev_baiquan = 9.491e-5; SEM_baiquan = -2.355e-5;
    %     end
    %     bar(nCand_show+1, dev_baiquan, 'BarWidth', .5, 'Edgecolor', ones(1,3)*.5, 'FaceColor', 'w', 'linewidth', 2)
    %     errorbar(nCand_show+1, dev_baiquan, SEM_baiquan, '.', 'color', ones(1,3)*.5, 'CapSize', 0)
    
    % IDVD data
    if flag_devErrorbar
        dev = cell(nsubj,1);
        for isubj = 1:nsubj
            dev{isubj} = squeeze(dev_allSubj(isubj, irank_groupAVE(1:nCand_show), iIC)) - min(dev_groupAVE(1:nCand_show));
            plot(indCand(1:nCand_show), dev{isubj}, '.-', 'color', ones(1,3)*.8)
        end
        
        % indicate the subj of the line by showing the marker of the idvd best model
        % do NOT combine with the for loop above!! (to ensure marker is on top of lines)
        for isubj = 1:nsubj
            for im_idvd = 1:nCand
                if im_idvd == iBest_allSubj(isubj, iIC)
                    iii = find(im_idvd == irank_groupAVE(1:nCand_show));
                    if sum(iii)
                        plot(iii, dev{isubj}(iii), ['k', markers_allSubj{isubj}])
                    end
                end
            end
        end
    end
    
    %  (fancy) xlabel ticks (if needed)
    xTL_allC = {};
    for ichosen = 1:nCand_show
        xTL = sprintf('[%d]', irank_groupAVE(ichosen));
        for iif = 1:size(ind_tunParam_all, 2)
            xTL = sprintf('%s\\newline%d', xTL, ind_tunParam_all(irank_groupAVE(ichosen), iif));
        end
        xTL_allC{ichosen} = xTL;
    end
    
    xlim([0, nCand_show+1])
    xticks(indCand(1:nCand_show))
    if flag_fancyXticks, xticklabels(xTL_allC), end
    
    ylim(y_ticks_all{ifeature}([1,end]))
    yticks(y_ticks_all{ifeature})
    
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', sz_ticks)
    set(findall(gcf, '-property', 'LineWidth'), 'LineWidth', wd_border)
    
    if MCmode==3
        title(sprintf('%s\n Best model (DEV/IC): M%d [%s]\n Best model (freq): M%d [%s]\n', ...
            namesIC{iIC}, ...
            iBEST_groupAVE, num2str(ind_tunParam_all(iBEST_groupAVE, :)), ...
            iBest_freq(1), num2str(ind_tunParam_all(iBest_freq(1), :))), 'fontsize', sz_ticks/2)
    end
    
    % save deviance figure
    if MCmode==3
        saveas(gcf, sprintf('%s/dev_n%d_M%d_%s.jpg', nameFigFolder_MC_rank, nsubj, ifamily, namesIC{iIC}))
    else
        saveas(gcf, sprintf('%s/dev_n%d_M%d_%s.jpg', nameFigFolder_MC_rank, nsubj, ifamily, namesMCmode{MCmode}))
    end
    
    % ====== 3. FREQ (in the same order as the deviance fig) ======
    figure('Position', [0 0 sz_fig_rank])
    hold on
    xTL_allC = cell(nCand_show, 1);
    for ichosen = 1:nChosen
        xPos = find(iBest_freq(ichosen) == irank_groupAVE(1:nCand_show));
        bar(xPos, freq(ichosen), 'FaceColor', 'w', 'BarWidth', .5)
    end
    
    xticks([]) % consistent wth the dev plot
    xlim([.5, nCand_show+1.5])
    ylim([0, max(freq)+1])
    xlim([0, nCand_show+1])
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', sz_ticks)
    set(findall(gcf, '-property', 'LineWidth'), 'LineWidth',wd_border)
    
    % save FREQ figure
    if MCmode==3
        saveas(gcf, sprintf('%s/freq_n%d_M%d_%s.jpg', nameFigFolder_MC_rank, nsubj, ifamily, namesIC{iIC}))
    else
        saveas(gcf, sprintf('%s/freq_n%d_M%d_%s.jpg', nameFigFolder_MC_rank, nsubj, ifamily, namesMCmode{MCmode}))
    end
    
end % iIC
