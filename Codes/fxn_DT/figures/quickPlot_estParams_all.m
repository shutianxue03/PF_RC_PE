%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%

for ifeature = 1:2
    if ifeature ==1, xlim_allM = oriBounds; nparams = 3; ifamily = 1; marg_ = margParamOri_Mean;
    else, xlim_allM = sfBounds; nparams = 5; ifamily = 3; marg_ = margParamSF_Mean;
    end
    figure('Position', get(0, 'ScreenSize'))
    for itype = 3:ntypes
        for iparam  = 1:nparams
            subplot(2,3,iparam), hold on
            for iLoc = 1:5
                plotColors = colors_comb(iLoc,:);
    
                params = squeeze(marg_(iLoc, :, itype, iparam));
                plot(1:4, params, 'Color', plotColors, 'LineWidth', 1.5)
            end
%             mm = squeeze(margParamOri_Mean(:,:, itype, iparam));
    
%             for isubj = 1:nsubjs
%                 mm = squeeze(margParamsOri(isubj,:,:,itype,iparam));
%                 plot(errOffset(:,1)-.05, squeeze(mm(:,1)), sprintf('%s-', markers_allSubj{isubj}), 'Color', [colorGradient{iLocComb_all(1),nBins}, .2])
%                 plot(errOffset(:,2)-.05, squeeze(mm(:,2)), sprintf('%s-', markers_allSubj{isubj}), 'Color', [colorGradient{iLocComb_all(2),nBins}, .2])
%             end
    
            txt = sprintf('%s', namesParams_all{ifamily}{iparam});
            title(txt)
            xlabel('Bins')
            ylim(xlim_allM(iparam, :))
            xticks(1:nBins)
            axis square
        end
    end
    sgtitle('estParams over Bins')
    set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)
    
    mkdir(sprintf('%s/estParams', dirName))
    nameFileFigure = sprintf('%s/estParams/%s.jpg', dirName, namesFeature{ifeature});
    saveas(gcf,nameFileFigure)
end %end of ifeature