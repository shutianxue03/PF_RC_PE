

mm = 1:nmodels;

for iIC = 1:nn
    iBest_unik = unique(iBest_allSubj(:, iIC));
    [freq, iBest_best] = groupcounts(iBest_allSubj(:, iIC));
    nChosen = length(freq);
    
    dev_groupAVE = squeeze(mean(dev_allSubj(:, :, iIC)));
    dev_groupSEM = squeeze(std(dev_allSubj(:, :, iIC)))/sqrt(nsubj);
    [~, irank_groupAVE] = sort(dev_groupAVE); % sort based on averaged dev (for CV) for IC
    iBEST_groupAVE = irank_groupAVE(1);
    dd_ = dev_groupAVE-min(dev_groupAVE);
    
    %% save the dev for comparing across MCmode and families
    if MCmode == 3
        dev_bestGroup_perModePerFamily{ifamily, MCmode, iIC} = dev_allSubj(:, iBEST_groupAVE, iIC);
        ibestGroup_perModePerFamily{ifamily, MCmode, iIC} = paramInd_all(iBEST_groupAVE, :);
    else
        dev_bestGroup_perModePerFamily{ifamily, MCmode, 1} = dev_allSubj(:, iBEST_groupAVE, 1);
        ibestGroup_perModePerFamily{ifamily, MCmode, 1} = paramInd_all(iBEST_groupAVE, :);
    end
    
    %% DEV
    figure('Position', [0,800,nn*800, 300]), hold on
%     if MCmode == 3
%         subplot(1, nIC, iIC),
%         title(sprintf('%s\n Model w/ lowest DEV/IC: M#%d [%s]\nDEV/IC = %.5f\n Model w/ highest freq: M#%d [%s]\nDEV/IC = %.5f', ...
%             namesIC{iIC}, ...
%             iBEST_groupAVE, num2str(paramInd_all(iBEST_groupAVE, :)), mean(dev_allSubj(:, iBEST_groupAVE, iIC)), ...
%             iBest_best(end), num2str(paramInd_all(iBest_best(end), :)), mean(dev_allSubj(:, iBest_best(end), iIC))))
%     else, title(namesYLabel{MCmode})
%     end
    hold on
    
    nmodels_show=8; % only show the 8 best models
    bar(mm(1:nmodels_show), dd_(irank_groupAVE(1:nmodels_show)), 'BarWidth', .5)
    errorbar(mm(1:nmodels_show), dd_(irank_groupAVE(1:nmodels_show)), dev_groupSEM(1:nmodels_show), '.k', 'CapSize', 0)
    for isubj = 1:nsubj
        plot(mm(1:nmodels_show), ...
            squeeze(dev_allSubj(isubj, irank_groupAVE(1:nmodels_show), iIC)) -min(dev_groupAVE(1:nmodels_show)) , ...
            '.-', 'color', ones(1,3)*.9)
    end
    xticks(mm(1:nmodels_show))
    xticklabels(mm(irank_groupAVE(1:nmodels_show)))
    xlim([.5, nmodels_show+.5])
    if ifeature == 1, ylim([-2, 12]*1e-4), else, ylim([-.5, 1.2]*1e-4), end
    ylabel(namesYLabel{MCmode})
    set(findall(gcf, '-property', 'FontSize'), 'FontSize',18)
    set(findall(gcf, '-property', 'LineWidth'), 'LineWidth',2)
    saveas(gcf, sprintf('talk2022/fig/MC/rank_dev_n%d_%s_M%d_%s.jpg', nsubj, namesFeature{ifeature}, ifamily, namesMCmode{MCmode}))
    
    %% FREQ (in the same order as the last fig)
    figure('Position', [0,500,nn*800, 150]), hold on
    if MCmode == 3, subplot(1, nIC, iIC + nIC), end
    hold on
    xTL_allC = cell(nChosen, 1);
    for ichosen = 1:nChosen
        xPos = find(iBest_best(ichosen) == irank_groupAVE(1:nmodels_show));
        bar(xPos, freq(ichosen), 'FaceColor', 'w', 'BarWidth', .5)
        
        xTL = [];  for iif = 1:size(paramInd_all, 2), xTL = [sprintf('%s\\newline%d', xTL, paramInd_all(iBest_best(ichosen), iif))];end
        xTL_allC{ichosen} = xTL;
    end

    xticks([])
    xticklabels(flip(xTL_allC))%, xtickangle(-50)
    xlim([.5, nmodels_show+.5])
    ylim([0, nsubj/2])
%     xlabel('Candidate model #')
%     if iIC == 1, ylabel('Freq of being the best'), end
    
end % iIC
set(findall(gcf, '-property', 'FontSize'), 'FontSize',18)
set(findall(gcf, '-property', 'LineWidth'), 'LineWidth',2)
saveas(gcf, sprintf('talk2022/fig/MC/rank_freq_n%d_%s_M%d_%s.jpg', nsubj, namesFeature{ifeature}, ifamily, namesMCmode{MCmode}))

% if MCmode == 3
%     sgtitle(sprintf('n = %d\n%s - Family #%d %s\n%s', ...
%         nsubj, namesFeature{ifeature}, ifamily, namesFamily_all{ifamily}, namesMCmode{MCmode}))
% else
%     sgtitle(sprintf('n = %d - %s\n[%s - Family #%d %s]\n Model w/ lowest DEV/IC: M#%d [%s]\nDEV/IC = %.5f\n Model w/ highest freq: M#%d [%s]\nDEV/IC = %.5f', ...
%         nsubj, namesMCmode{MCmode}, namesFeature{ifeature}, ifamily, namesFamily_all{ifamily}, ...
%         iBEST_groupAVE, num2str(paramInd_all(iBEST_groupAVE, :)), mean(dev_allSubj(:, iBEST_groupAVE, 1)), ...
%         iBest_best(end), num2str(paramInd_all(iBest_best(end), :)), mean(dev_allSubj(:, iBest_best(end), 1))))
% end


