%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%
% quickplot metrics
close all
%% ORI by location
xlim_allM = oriBounds;
ngroups = nLoc2;
nbars = nBins;
errOffset = nan(nbars, ngroups);
figure('Position', get(0, 'ScreenSize'))
for itype = 3:ntypes
    for iparam  = 1:length(namesParams_all{1})
        subplot(1,3,iparam), hold on
        for iLoc = 1:nLoc2
            if iLoc == 1, plotColors = colorGradient(iLocComb_all(1),:); else, plotColors = colorGradient(iLocComb_all(2),:);end

            params = squeeze(margParamOri_Mean(:, iLoc, itype, iparam));
            barObj = bar(iLoc, params, 'EdgeColor', plotColors{1}, 'FaceColor', 'none', 'LineWidth', borderSize);
            for ii = 1:nBins
                barObj(ii).EdgeColor = plotColors{ii};
            end
        end
        for i = 1:nbars
            errOffset(i,:) = barObj(i).XEndPoints;
        end
        errOffset(:,1) = errOffset(:,1) - 1;
        mm = squeeze(margParamOri_Mean(:,:, itype, iparam));
        erB = errorbar(errOffset, mm, squeeze(margParamOri_SE(:,:,itype,iparam)), '.', 'CapSize', 0, 'LineWidth',1);
        erB(1).Color = colorGradient{iLocComb_all(1),nBins};
        erB(2).Color = colorGradient{iLocComb_all(2),nBins};

        for isubj = 1:nsubjs
            mm = squeeze(margParamsOri(isubj,:,:,itype,iparam));
            plot(errOffset(:,1)-.05, squeeze(mm(:,1)), sprintf('%s-', markers_allSubj{isubj}), 'Color', [colorGradient{iLocComb_all(1),nBins}, .2])
            plot(errOffset(:,2)-.05, squeeze(mm(:,2)), sprintf('%s-', markers_allSubj{isubj}), 'Color', [colorGradient{iLocComb_all(2),nBins}, .2])
        end

        txt = sprintf('%s [%s]', namesParams_all{1}{iparam}, namesType{itype});
        title(txt)
        xlabel('Location')
        ylim(xlim_allM(iparam, :))
        xticks([1 2])
        xticklabels({namesLocComb{iLocComb_all(1)}, namesLocComb{iLocComb_all(2)}})
        axis square
    end
end
sgtitle('Parameters across locations and conditions for all subjs ORI')
set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)

nameFileFigure = sprintf('figs/Perceptual Learning RC/%s/%s/Params/ORI.jpg', locName, folderName);
saveas(gcf,nameFileFigure)

%% SF by location
xlim_allM = sfBounds;
ngroups = nLoc2;
nbars = nBins;
errOffset = nan(nbars, ngroups);
figure('Position', get(0,'ScreenSize'))
for itype = 3:ntypes
    for iparam  = 1:length(namesParams_all{3})
        subplot(2,3,mod(iparam,3) + floor(iparam/3)*3), hold on
        for iLoc = 1:nLoc2
            if iLoc == 1, plotColors = colorGradient(iLocComb_all(1),:); else, plotColors = colorGradient(iLocComb_all(2),:);end

            params = squeeze(margParamSF_Mean(:, iLoc, itype, iparam));
%             if iparam == 5, params = 1 - params; end
            b = bar(iLoc, params, 'EdgeColor', plotColors{1}, 'FaceColor', 'none', 'LineWidth', borderSize);
            for ii = 1:nBins
                b(ii).EdgeColor = plotColors{ii};
            end
            % errorLoc = repmat(iLoc,nBins, 1);
            % errorbar(errorLoc, mm, squeeze(margMetrics_SE(:,iLoc,im))', '.k', 'CapSize', 0)
        end
        for i = 1:nbars
            errOffset(i,:) = b(i).XEndPoints;
        end
        errOffset(:,1) = errOffset(:,1) - 1;
        mm = squeeze(margParamSF_Mean(:,:, itype, iparam));
        erB = errorbar(errOffset, mm, squeeze(margParamSF_SE(:,:,itype,iparam)), '.', 'CapSize', 0, 'LineWidth',1);
        erB(1).Color = colorGradient{iLocComb_all(1),nBins};
        erB(2).Color = colorGradient{iLocComb_all(2),nBins};

        for isubj = 1:nsubjs
            mm = squeeze(margParamsSF(isubj,:,:,itype,iparam));
            plot(errOffset(:,1)-.05, squeeze(mm(:,1)), sprintf('%s-', markers_allSubj{isubj}), 'Color', [colorGradient{iLocComb_all(1),nBins}, .2])
            plot(errOffset(:,2)-.05, squeeze(mm(:,2)), sprintf('%s-', markers_allSubj{isubj}), 'Color', [colorGradient{iLocComb_all(2),nBins}, .2])
        end

        txt = sprintf('%s [%s]', namesParams_all{3}{iparam}, namesType{itype});
        title(txt)
        xlabel('Location')
        ylim(xlim_allM(iparam, :))
        xticks([1 2])
        xticklabels({namesLocComb{iLocComb_all(1)}, namesLocComb{iLocComb_all(2)}})
        axis square
    end
end
sgtitle('Parameters across locations and conditions for all subjs SF')
set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)

nameFileFigure = sprintf('figs/Perceptual Learning RC/%s/%s/Params/SF.jpg', locName, folderName);
saveas(gcf,nameFileFigure)

%% ORI by bin
xlim_allM = oriBounds;
xlim_allM2 = [.2; 30;.025];
ncats = nBins;
ngroups = nBins;
nbars = nLoc2;
errOffset = nan(nbars, ngroups);
figure('Position', get(0, 'ScreenSize'))

plotColors = colorGradient(iLocComb_all(1),:);
plotColors2 = colorGradient(iLocComb_all(2),:);
    
for itype = 3:ntypes
    for iparam  = 1:length(namesParams_all{1})
        subplot(1,3,iparam), hold on
        for iBin = 1:nBins
            params = squeeze(margParamOri_Mean(iBin, :, itype, iparam));
            barObj = bar(iBin, params, 'FaceColor', plotColors{iBin});
            barObj(2).FaceColor = plotColors2{iBin};
            errOffset(1, iBin) = barObj(1).XEndPoints;
            errOffset(2, iBin) = barObj(2).XEndPoints;
            % errorLoc = repmat(iLoc,nBins, 1);
            % errorbar(errorLoc, mm, squeeze(margMetrics_SE(:,iLoc,im))', '.k', 'CapSize', 0)
        end

        % Calculate within subj SEM
        withinSEM = nan(nsubjs, nBins);
        for iBin = 1:nBins
            for isubj = 1:nsubjs
                withinSEM(isubj,iBin) = margParamsOri(isubj,iBin,1,itypes,iparam) - margParamsOri(isubj,iBin,2,itypes,iparam);
            end
        end
        [~, ~, ~, ~, withinSEM] = getCI(withinSEM,2,1,1,ones(nsubjs));
        plot([errOffset(1,:)',errOffset(2,:)'],[xlim_allM2(iparam),xlim_allM2(iparam)], 'k')
        errorbar((1:nBins),xlim_allM2(iparam).*ones(1,nBins), withinSEM, '.k', 'CapSize',0, LineWidth=1)
        for iBin = 1:nBins
            t1 = squeeze(margParamsOri(:,iBin,1,3,iparam));
            t2 = squeeze(margParamsOri(:,iBin,2,3,iparam));

            [p, ~] = vartestn([t1;t2], 'Display','off');
            if p < .05, txt = 'unequal'; else, txt = 'equal'; end

            [h, p, ~, stats] = ttest2(t1, t2,'Alpha',.05/ncats, 'VarType', txt);

            if h == 0, txt = 'n.s.'; elseif p < .001/ncats, txt = '***'; elseif p < .01/ncats, txt = '**'; elseif p < .05/ncats, txt = '*'; else, txt = 'n.s.'; end
            text(iBin,xlim_allM2(iparam)*1.1, txt, 'HorizontalAlignment','center')
        end

        mm = squeeze(margParamOri_Mean(:,:, itype, iparam));
        erB = errorbar(errOffset(1,:), mm(:,1)', squeeze(margParamOri_SE(:,1,itype,iparam))', '.', 'color', plotColors{nBins}, 'CapSize', 0);
        erB = errorbar(errOffset(2,:), mm(:,2)', squeeze(margParamOri_SE(:,2,itype,iparam))', '.', 'color', plotColors2{nBins}, 'CapSize', 0);

%         for isubj = 1:nsubjs
%             mm = squeeze(margParamsOri(isubj,:,:,itype,iparam));
%             plot(errOffset(1,:), squeeze(mm(:,1)), '.-', 'Color', [1, ones(1,2)*RGB_gradient(6), .1])
%             plot(errOffset(2,:), squeeze(mm(:,2)), '.-', 'Color', [ones(1,2)*RGB_gradient(6), 1, .1])
%         end

%         l = legend(namesLocComb{iLocComb_all(1)}, namesLocComb{iLocComb_all(2)});
        txt = sprintf('%s', namesParams_all{1}{iparam});
        title(txt)
        xlabel('Bin Index')
        ylim(xlim_allM(iparam, :))
        xlim([.5 nBins+.5])
        xticks(1:nBins)
        axis square
    end
end
sgtitle('Parameters across locations and conditions for all subjs ORI')
set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)

nameFileFigure = sprintf('figs/Perceptual Learning RC/%s/%s/Params/ORI_v2.jpg', locName, folderName);
saveas(gcf,nameFileFigure)

%% SF by bin
xlim_allM = sfBounds;
xlim_allM2 = [3*.8;.12;.4;.03;.05];
ncats = nBins;
ngroups = nBins;
nbars = nLoc2;
errOffset = nan(nbars, ngroups);

plotColors = colorGradient(iLocComb_all(1),:);
plotColors2 = colorGradient(iLocComb_all(2),:);
    
figure('Position', get(0, 'ScreenSize'))
for itype = 3:ntypes
    for iparam  = 1:length(namesParams_all{3})
        subplot(2,3,mod(iparam,3) + floor(iparam/3)*3), hold on
        for iBin = 1:nBins
            params = squeeze(margParamSF_Mean(iBin, :, itype, iparam));
%             if iparam == 5, params = 1 - params; end
            barObj = bar(iBin, params, 'FaceColor', plotColors{iBin});
            barObj(2).FaceColor = plotColors2{iBin};
            errOffset(1, iBin) = barObj(1).XEndPoints;
            errOffset(2, iBin) = barObj(2).XEndPoints;
        end

         % Calculate within subj SEM
        withinSEM = nan(nsubjs, nBins);
        for iBin = 1:nBins
            for isubj = 1:nsubjs
                withinSEM(isubj,iBin) = margParamsSF(isubj,iBin,1,itypes,iparam) - margParamsSF(isubj,iBin,2,itypes,iparam);
            end
        end
        [~, ~, ~, ~, withinSEM] = getCI(withinSEM,2,1,1,ones(nsubjs));
        plot([errOffset(1,:)',errOffset(2,:)'],[xlim_allM2(iparam),xlim_allM2(iparam)], 'k')
        errorbar((1:nBins),xlim_allM2(iparam).*ones(1,nBins), withinSEM, '.k', 'CapSize',0, LineWidth=1)
        for iBin = 1:nBins
            t1 = squeeze(margParamsSF(:,iBin,1,3,iparam));
            t2 = squeeze(margParamsSF(:,iBin,2,3,iparam));

            [p, ~] = vartestn([t1;t2], 'Display','off');
            if p < .05, txt = 'unequal'; else, txt = 'equal'; end

            [h, p, ~, stats] = ttest2(t1, t2, 'Alpha',.05/ncats, 'Vartype', txt);

            if h == 0, txt = 'n.s.'; elseif p < .001/ncats, txt = '***'; elseif p < .01/ncats, txt = '**'; elseif p < .05/ncats, txt = '*'; else, txt = 'n.s.'; end
            text(iBin,xlim_allM2(iparam)*1.1, txt, 'HorizontalAlignment','center')
        end


        mm = squeeze(margParamSF_Mean(:,:, itype, iparam));
        erB = errorbar(errOffset(1,:), mm(:,1)', squeeze(margParamSF_SE(:,1,itype,iparam))', '.', 'color', plotColors{nBins}, 'CapSize', 0);
        erB = errorbar(errOffset(2,:), mm(:,2)', squeeze(margParamSF_SE(:,2,itype,iparam))', '.', 'color', plotColors2{nBins}, 'CapSize', 0);

%         for isubj = 1:nsubjs
%             mm = squeeze(margParamsSF(isubj,:,:,itype,iparam));
%             plot(errOffset(1,:), squeeze(mm(:,1)), '.-', 'Color', [1, ones(1,2)*RGB_gradient(6), .1])
%             plot(errOffset(2,:), squeeze(mm(:,2)), '.-', 'Color', [ones(1,2)*RGB_gradient(6), 1, .1])
%         end

%         legend(namesLocComb{iLocComb_all(1)}, namesLocComb{iLocComb_all(2)})
        txt = sprintf('%s [%s]', namesParams_all{3}{iparam}, namesType{itype});
%         l = legend(namesLocComb{iLocComb_all(1)}, namesLocComb{iLocComb_all(2)});
%         if(iparam == 5), l.Location = 'southeast'; end
        txt = sprintf('%s [%s]', namesParams_all{3}{iparam}, namesType{itype});
        title(txt)
        xlabel('Bin Index')
        ylim(xlim_allM(iparam, :))
        xlim([.5 nBins+.5])
        xticks(1:nBins)
        axis square
    end
end
sgtitle('Parameters across locations and conditions for all subjs SF')
set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)

nameFileFigure = sprintf('figs/Perceptual Learning RC/%s/%s/Params/SF_v2.jpg', locName, folderName);
saveas(gcf,nameFileFigure)