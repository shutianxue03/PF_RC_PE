%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%
%% T-Test groups for ORI
% Set up init
close all
ncats = 15;
alpha = 0.05/ncats;

% Organize groups
for itypes = 1:ntypes
    for iiLoc = 1:2
        for ifeature = 1:2
            if ifeature == 1
                marg_ = margParamsOri; 
                xlim_allM = [0, .5; 0, 40; -.025, .025];
                nparams = 3;
            else
                marg_ = margParamsSF;
                xlim_allM = [1, 3; 0, .25; 0, .7; -.04, .04; -.05, .05];
                nparams = 5;
            end
            close all
            figure('Position', get(0, 'Screensize'))
            subCounter = 1;
            for iparam = 1:nparams
                for iBins = 1:(nBins-1)
                    for iiBins = (iBins+1):nBins
                        if iBins == iiBins, continue; end
                        bins1 = squeeze(marg_(:,iBins,iiLoc,itypes,:));
                        bins2 = squeeze(marg_(:,iiBins,iiLoc,itypes,:));
                        [ave1, ~, ~, ~, bins1_SE] = getCI(bins1,2,1,1,ones(nsubjs));
                        [ave2, ~, ~, ~, bins2_SE] = getCI(bins2,2,1,1,ones(nsubjs));
                                    
                        % if iparam == 5, ave1 = 1 - ave1; ave2 = 1 - ave2; end
                        subplot(nparams , ncats, subCounter), hold on
                        subCounter = subCounter + 1;
%                         if subCounter > nparams * ncats, fprintf('\nitypes:%d, iiLoc:%d, ifeature:%d, iparam:%d, iBins:%d, iiBins:%d, subCounter:%d\n', itypes, iiLoc, ifeature, iparam, iBins, iiBins, subCounter); end
                        [~,p,~,stats] = ttest(squeeze(bins1(:,iparam)), squeeze(bins2(:,iparam)), 'Alpha', alpha);
                        barObj = bar([1,2],[ave1(iparam); ave2(iparam)], 'FaceColor', colors_comb(iLocComb_all(iiLoc),:));
                        errorbar(barObj.XEndPoints(1), ave1(iparam), bins1_SE(iparam), '.', 'CapSize', 0, 'color', colors_comb(iLocComb_all(iiLoc),:))
                        errorbar(barObj.XEndPoints(2), ave2(iparam), bins2_SE(iparam), '.', 'CapSize', 0, 'color', colors_comb(iLocComb_all(iiLoc),:))
                        ylim(xlim_allM(iparam, :))
                        xticks([1,2])
                        xticklabels({sprintf('Bin %d',iBins), sprintf('Bin %d',iiBins)})
                        xlabel('Bin Location')
                        if ifeature == 1, iifeature=1; else, iifeature = 3; end
                        txt = sprintf(['%s[%s]' ...
                                       '\nt(%d) = %01.4f, p = %01.4f\n'],...
                                       namesParams_all{iifeature}{iparam}, namesType{itypes}, stats.df, stats.tstat, p);
                        title(txt)
                    end
                end
                sgtitle(sprintf('Parameters across trial types for all subjs at specified bins %s [%s]', namesLocComb{iLocComb_all(iiLoc)}, namesFeature{ifeature}))
                set(findall(gcf, '-property', 'FontSize'), 'FontSize',8)
            end
            locationName = namesLocComb{iLocComb_all(iiLoc)};
            featureName = namesFeature{ifeature};
            nameFileFigure = sprintf('figs/Perceptual Learning RC/Fovea&Periphery(5)/PostHoc Tests/%s/Params_%s_%s_%s.jpg', ...
                                    locationName,locationName,featureName,namesType{itypes});
            saveas(gcf,nameFileFigure)
        end
    end
end