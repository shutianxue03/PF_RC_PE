
subplot_locs = [5,4,2,6,8]; % 5=center, 4=LHM, 2=UVM, 6=RHM, 8=LVM
linestyles = {'.', '--', '-'};

%% draw staircase
figure('Position',[0 200 800 800])
for iLoc = record.params.design.loc_list
    i_subplot_locs = subplot_locs(iLoc);
    subplot(3,3,i_subplot_locs), hold on, grid on
    
    if plotBySess
        for istair = 1:nStairs
            for iSess = 1:nSess
                if iSess == 1
                    plot(1:nTrials, squeeze(y_log(iLoc, iSess, istair, 1:nTrials)), 'Color', [.5,.5,.5])
                else
                    plot(1:nTrials, squeeze(y_log(iLoc, iSess, istair, 1:nTrials)), 'Color', [colors(istair, :), iSess/nSess])
                end
            end
        end
        
        errorbar(nTrials + 3, mean(thresh_log(iLoc, :)), thresh_SEM(iLoc), 'ok')
        if i_subplot_locs == 4, xlabel('# trials per session '),ylabel('log target cst'), end
        x_end = length(y)+5;
        xlim([1,x_end])
        title(sprintf('%s (%.4f\\pm%.2f)', locNames{iLoc}, round(10.^(mean(thresh_log(iLoc,:))),4), thresh_SEM(iLoc)))
    
    else % NOT plot by session
        for istair = 1:nStairs
            a = (squeeze(y_log(iLoc,:,istair,:)))';
            plot(1:nTrials*nSess, a(:), 'Color', colors(istair, :))
        end
        x_end = nTrials*nSess+5;
        if size(endpoints_log,2) == 0, error('ALERT: at least two sessions should be done!!!'),end
        end2_log = mean(squeeze(endpoints_log(iLoc, end, :)));
        title(sprintf('%s (%.4f)', locNames{iLoc}, 10^(end2_log)))
    end
    
    % plot the final manually decided threshold
    plot(x_end, thresh_final_log(iLoc), '+r')
    ylim([log10(minCST), log10(maxCST)])
    yticks(log10(minCST:.1:maxCST)), yticklabels(minCST:.1:maxCST)
    box on
    
    if iLoc == 2, ylabel('log contrast'), end
    
end

set(findall(gcf, '-property', 'FontSize'), 'FontSize',15)
set(findall(gcf, '-property', 'LineWidth'), 'LineWidth', 1.2)
sgtitle(suptitle1, 'FontSize', 25);

