%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%
ylims1 = [-.15,.15; -15, 15; -.05,.05;];
ylims2 = [-.5,.5; -.1, .1; -2,2; -.1, .1; -.05, .05];
xlims = [0 1];
for ifeature = 1:2
    figure('Position', get(0, 'ScreenSize'))
    if ifeature == 1, marg_ = margTuningCharORIMag; else, marg_ = margTuningCharSFMag; end
%     for iiLoc = 1:2
        for iparam = 1:size(marg_,3)
            if ifeature == 1
                subplot(1,size(marg_,3), iparam), hold on
            else
                subplot(2,3, iparam), hold on
            end
            for isubj = 1:12
                for iiLoc = 1:2
                    plot(squeeze(margCstMag(isubj,iiLoc)), squeeze(marg_(isubj,iiLoc,iparam)), markers_allSubj{isubj}, 'Color', colorGradient{iLocComb_all(iiLoc),nBins})
%                 errorbar(margCstMag(isubj,iiLoc), marg_(isubj,iiLoc,iparam), .1, '.k')
                end
            end
%             if ifeature == 1
%                 plot(xlim',ylims1(iparam,:)', '-k')
%             else
%                 plot(xlim,ylims2(iparam,:), '-k')
%             end
            a= squeeze(marg_(:,:,iparam));
            b= squeeze(margCstMag(:,:));
            [r, p] = corr(b(:),a(:));
            if ifeature == 2, pName = 3; ylim(ylims2(iparam,:)); else, pName = 1; ylim(ylims1(iparam,:));end
            title(sprintf('%s \np=%.2f r=%.2f', namesTuningC_all{pName}{iparam}, p, r))
            xlim(xlims)
            xlabel('Cst Magnitude')
            ylabel(sprintf('%s Magnitude',namesTuningC_all{pName}{iparam}))
            axis square
        end
        set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)
        nameFileFigure = sprintf('figs/Perceptual Learning RC/%s/%s/Magnitudes/CorrPerformanceTunningC_%s.jpg', locName, folderName, namesFeature{ifeature});
        saveas(gcf,nameFileFigure)
%     end
end

%% Equidate magnitude of changes
for ifeature = 1:2
    data = [];
    IVs = [];
    figure('Position', get(0, 'ScreenSize')), hold on
    if ifeature == 1, marg_ = margTuningCharORIRatio; pName = 3; else, marg_ = margTuningCharSFRatio; pName = 5; end
    errOffset = nan(2, pName);
    for iparam = 1:pName
        bObj = bar(iparam, mean(squeeze(marg_(:,:,iparam)),1), 'FaceColor', 'none');
        bObj(1).EdgeColor = colorGradient{iLocComb_all(1),4};
        bObj(2).EdgeColor = colorGradient{iLocComb_all(2),4};
        errOffset(1,:) = bObj(1).XEndPoints;
        errOffset(2,:) = bObj(2).XEndPoints;
        errorbar(errOffset(1,iparam), mean(squeeze(marg_(:,1,iparam))), std(squeeze(marg_(:,1,iparam)))/sqrt(nsubjs), '.', 'Color', colorGradient{iLocComb_all(1),4}, 'LineWidth', 1.5, 'CapSize', 0)
        errorbar(errOffset(2,iparam), mean(squeeze(marg_(:,2,iparam))), std(squeeze(marg_(:,2,iparam)))/sqrt(nsubjs), '.', 'Color', colorGradient{iLocComb_all(2),4}, 'LineWidth', 1.5, 'CapSize', 0)
        for isubj = 1:nsubjs
            plot(errOffset(:,iparam)', marg_(isubj,:,iparam), sprintf('-%s',markers_allSubj{isubj}), 'Color', [.1 .1 .1])
        end

        data = [data, marg_(:,1,iparam)', marg_(:,2,iparam)'];
        IVs = [IVs, ones(1,nsubjs), ones(1,nsubjs)+1];
    end
    varNames = cell(1,length(IVs));
    for i = 1:length(IVs)
        varNames(1,i) = {namesLocComb{iLocComb_all(IVs(i))}};
    end
    txt = print_nANOVA({'Loc'}, data, {IVs});
    title(txt);
    xticks([1:size(marg_,3)])
    if ifeature == 1, xticklabels(namesTuningC_all{1}); else, xticklabels(namesTuningC_all{3}); end
    ylabel('Magnitude of Change')
    set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)

    nameFileFigure = sprintf('figs/Perceptual Learning RC/%s/%s/Magnitudes/Magnitudes_%s.jpg', locName, folderName, namesFeature{ifeature});
    saveas(gcf,nameFileFigure)
end

figure('Position', get(0, 'ScreenSize')), hold on
bar(1, mean(squeeze(margCstRatio(:,1))), 'FaceColor', 'none', 'EdgeColor', colorGradient{iLocComb_all(1),4})
bar(2, mean(squeeze(margCstRatio(:,2))), 'FaceColor', 'none', 'EdgeColor', colorGradient{iLocComb_all(2),4})

errorbar(1, mean(squeeze(margCstRatio(:,1))), std(squeeze(margCstRatio(:,1))/sqrt(nsubjs)), '.', 'Color', colorGradient{iLocComb_all(1),4}, 'LineWidth', 1.5, 'CapSize', 0)
errorbar(2, mean(squeeze(margCstRatio(:,2))), std(squeeze(margCstRatio(:,2))/sqrt(nsubjs)), '.', 'Color', colorGradient{iLocComb_all(2),4}, 'LineWidth', 1.5, 'CapSize', 0)
for isubj = 1:nsubjs
    plot([1 2], squeeze(margCstRatio(isubj,:)), sprintf('-%s',markers_allSubj{isubj}), 'Color', [.1 .1 .1])
end

xticks([1 2])
xticklabels({namesLocComb{iLocComb_all(1)}, namesLocComb{iLocComb_all(2)}})
ylabel('Magnitude of Change')
set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)

nameFileFigure = sprintf('figs/Perceptual Learning RC/%s/%s/Magnitudes/Magnitudes_CSTs.jpg', locName, folderName);
saveas(gcf,nameFileFigure)