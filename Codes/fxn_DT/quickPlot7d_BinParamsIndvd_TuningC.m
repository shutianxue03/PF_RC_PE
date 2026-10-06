%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%
close all
%% Individual together

for ifeature= 1:2
    if ifeature == 1, marg_ = margTuningCharOri; else, marg_ = margTuningCharSF; end
    if ifeature == 1, xlim_allM = oriBoundsTuning; else, xlim_allM = sfBoundsTuning; end
    nparams = size(marg_,5);
    figure('Position', get(0, 'ScreenSize'))
    for iLoc = 1:2
        if iLoc == 1, plotColors = colorGradient(iLocComb_all(1),:); else, plotColors = colorGradient(iLocComb_all(2),:);end

        for iparam = 1:nparams
            subplot(2,nparams, (iLoc-1)*nparams+iparam), hold on
            for iiSubj = 1:12
                paramMtx = squeeze(marg_(iiSubj,:,iLoc,3,iparam));
                plotObj = plot(paramMtx', sprintf('%s-', markers_allSubj{iiSubj}), 'Color', [plotColors{nBins}, .2]);
            end
            xlabel("Bin Index")
            if ifeature == 1, title(namesTuningC_all{1}{iparam})
            else, title(namesTuningC_all{3}{iparam}); end
            ylim(xlim_allM(iparam,:))
            xlim([.5 nBins+.5])
            xticks(1:nBins);
            axis square
        end
    end
    set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)
    nameFileFigure = sprintf('figs/Perceptual Learning RC/%s/%s/TuningChar/%s_Indvd.jpg', locName, folderName, namesFeature{ifeature});
    saveas(gcf,nameFileFigure)
end

%% Individual Separate

for ifeature= 1:2
    if ifeature == 1, marg_ = margTuningCharOri; else, marg_ = margTuningCharSF; end
    if ifeature == 1, xlim_allM = oriBoundsTuning; else, xlim_allM = sfBoundsTuning; end
    nparams = size(marg_,5);
    for iLoc = 1:2
        if iLoc == 1, plotColors = colorGradient(iLocComb_all(1),:); else, plotColors = colorGradient(iLocComb_all(2),:);end
        
        for iparam = 1:nparams
            figure('Position', get(0, 'ScreenSize'))
            for isubj = 1:12
                subplot(3,4, isubj), hold on
                paramMtx = squeeze(marg_(isubj,:,iLoc,3,iparam));
                plotObj = plot(paramMtx', sprintf('%s-', markers_allSubj{isubj}), 'Color', [plotColors{nBins}, .5]);
                xlabel("Bin Index")
                if ifeature == 1, txt = namesTuningC_all{1}{iparam};
                else, txt = namesTuningC_all{3}{iparam}; end
                title(sprintf('%s [%s]',txt,subjList{isubj}))
                ylim(xlim_allM(iparam,:))
                xlim([.5 nBins+.5])
                xticks(1:nBins);
                axis square
            end
            set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)
            nameFileFigure = sprintf('figs/Perceptual Learning RC/%s/%s/TuningChar/Indvd/%s_%s_%s_Indvd.jpg', ...
                locName, folderName, namesFeature{ifeature}, namesLocComb{iLocComb_all(iLoc)}, txt);
            saveas(gcf,nameFileFigure)
        end
    end
end