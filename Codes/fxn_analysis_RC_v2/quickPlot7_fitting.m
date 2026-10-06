
close all
nLines = 2;

figure('Position', [2000 500 2000 800])
for ifeature = 1:2
    switch ifeature
        case 1, marg = margORI; margPred = margPred_ORI; params = margParams_ORI;
        case 2, marg = margSF; margPred = margPred_SF; params = margParams_SF;
    end
    
    for itype = 1:ntypes
        subplot(2, ntypes, (ifeature-1)*ntypes+itype), hold on
        
        if ifeature==1, ylim([-.05, .2]), xlim([-90, 90]), xticks(-90:45:90), title(namesType{itype}), xline(0, 'color', ones(1,3)*.5);
        else, ylim([-.05, .1]), xlim([0,2]), xline(1, 'color', ones(1,3)*.5); xticks(0:.5:2), xticklabels(round(2.^(0:.5:2), 2)),
        end
        yline(0, 'color', ones(1,3)*.5);
        
        for iBin = 1:nBins
            for iLoc=1:nLoc2
                color = colors_comb(iLocComb_all(iLoc), :);
                % plot the data
                plot(axis_tuning{ifeature}, squeeze(marg(iBin, iLoc, itype, :)), 'o', 'color', color)
                % plot the pred
                plot(axis_tuning{ifeature}, squeeze(margPred(iBin, iLoc, itype, :)), '-', 'color', color)
                
                % get & plot the tuning characteristics
%                 tuningC = fxn_getTuningC(axis_tuning{ifeature}, ifeature, squeeze(margPred(iBin, iLoc, itype,:)), squeeze(params(iBin, iLoc, itype,:)));
%                 if ifeature==2, plot(axis_tuning{ifeature}, predSFkernel(2.^axis_tuning{ifeature}, 2, squeeze(params(iBin, iLoc, itype, 1:4)), 0), '-', 'color', color), end                
%                 if ifeature==1
%                     plot([axis_tuning{ifeature}(1), 0], [tuningC(1), tuningC(1)], '-', 'color', color, 'linewidth', 2); % peak
%                     plot([0, tuningC(2)], [tuningC(4), tuningC(4)], '-', 'color', color, 'linewidth', 2) % width
%                     yline(tuningC(3), '-', 'color', color, 'linewidth', 2); % bottom
%                 else
%                     xline(tuningC(1), '-', 'color', color, 'linewidth', 2); % peakSF
%                     plot([axis_tuning{ifeature}(1), tuningC(1)], [tuningC(2), tuningC(2)], '-', 'color', color, 'linewidth', 2); % peak
%                     plot([tuningC(1)-tuningC(6), tuningC(1)+tuningC(7)], [tuningC(9), tuningC(9)], '-', 'color', color, 'linewidth', 2) % width
%                     yline(tuningC(4), '-', 'color', color, 'linewidth', 2); % bottom
%                 end
            end % iLoc
        end % iBin
        
    end % itype
    set(findall(gcf, '-property', 'FontSize'), 'FontSize',15)
end % ifeature
sgtitle(sprintf('%s iB=%d', subjName, iB))

% saveas(gcf, sprintf('VSS2023/fig/idvd/%s_L%d%d_%d.jpg', subjName, iLocComb_all, iB))

