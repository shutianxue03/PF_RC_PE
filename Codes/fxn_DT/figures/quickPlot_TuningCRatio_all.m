close all

for ifeature = 1:2
    if ifeature == 1, iF = 1; nparams = nORI_TuningC; marg_ = margTuningCharORIRatio; ylims = oriRatioBounds;
    else, iF = 2; nparams = nSF_TuningC; marg_ = margTuningCharSFRatio; ylims = sfRatioBounds;
    end
%     errOffset = nan(nparams,8);
    
    if ifeature == 1, ylims = [-.05, .2; -.1, .2; -.1, .1];
    else, ylims = [-.2, .15; -.1, .2; -.125, .1; -.1, .2; -.2, .2; -.2, .1];
    end

    for iparam = 1:nparams
        figure('Units', 'pixels', 'Position', [0, 0, 1280, 1280]), hold on
        data = [];
        IVs = [];
        
        for i = 1:5
%             errOffset(iparam, i) = bObj(i).XEndPoints;
            plotColor = colorGradient{i,4};
            if i == 1, plotColor = colors_comb(1,:); end
            if i == 8, plotColor = colors_comb(8,:); end
            bar(i, mean(squeeze(marg_(i, :,iparam)),2),'FaceColor', plotColor, 'LineWidth',borderSize);
    
            errorbar(i, mean(squeeze(marg_(i, :,iparam)),2),...
                 std(squeeze(marg_(i, :,iparam)')/sqrt(nsubjs)), '.', 'Color', plotColor, ...
                 'LineWidth', errorBarSize, 'CapSize', 0)
            if i < 6
                data = [data, squeeze(marg_(i,:,iparam))];
                IVs = [IVs, ones(1,nsubjs).*i];
            end
        end %end of i
        for isubj = 1:nsubjs
%             plot(errOffset(iparam,1:5)-((nsubjs/2 - isubj) *.0075), squeeze(marg_(1:5,isubj,iparam)), ...
%                 sprintf('-%s',markers_allSubj{isubj}), ...
%                 'MarkerSize', markerFontSize_bar, 'Color', [.5, .5, .5], 'LineWidth', lineSize) 
        end %end of isubj

        txt = print_nANOVA({'Loc'}, data, {IVs});
        fprintf('%s - %s', namesTuningC_all{iF}{iparam}, txt)
    
%         str = sprintf('TuningC %s [%s]: %s\n%s', namesLocComb{iloc}, namesFeature{ifeature}, namesTuningC_all{ifamily}{iparam}, txt);
        str = sprintf('TuningC [%s]:\n%s%s', namesFeature{ifeature}, txt, namesTuningC_all{iF}{iparam});
%         title(str)
        ylim(ylims(iparam,:))
        yticks(linspace(ylims(iparam,1), ylims(iparam,2), 5))
        xticks([1 2 3 4 5])
        xticklabels({'Fovea', 'LHM', 'UVM', 'RHM', 'LVM'})
%         xlabel('Location')
        ylabel(sprintf('Changes in %s',namesTuningC_all{iF}{iparam}))
        set(findall(gcf, '-property', 'FontSize'), 'FontSize',36)
        set(gca, 'LineWidth', 2)
        
        nameFileFigure = sprintf('%s/Magnitudes_TuningC_%s_%s_all.jpg', dirName, namesFeature{ifeature}, namesTuningC_all{iF}{iparam});
        saveas(gcf,nameFileFigure)
    end %end of iparam
end %end of ifeature