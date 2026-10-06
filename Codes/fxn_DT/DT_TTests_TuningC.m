%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%
%% T-Test groups for ORI
% Set up init
close all
bins_all = {1, nBins};
ncats = 1;
mkdir(sprintf('figs/Perceptual Learning RC/%s/%s/T Tests/TuningC', ...
    locName, folderName))

% Organize groups
for iLoc = 1:2
    if iLoc == 1, plotColors = colorGradient(iLocComb_all(1),:); else, plotColors = colorGradient(iLocComb_all(2),:);end
    if iLocComb_all(iLoc) == 1, plotColors = colorGradient(9,:); elseif iLocComb_all(iLoc) == 8, plotColors = colorGradient(10,:); end

    for ifeature = 1:2
        if ifeature == 1
            marg_ = margTuningCharOri; 
            xlim_allM = oriBoundsTuning;
            xlim_allM2 = [.2; 30;.01];
            iF = 1;
        else
            marg_ = margTuningCharSF;
            xlim_allM = sfBoundsTuning;
            xlim_allM2 = [3*.8;.1;2;.07;.05*.8];
            iF = 3;
        end
        for itypes = 3:ntypes
            bins1 = [];
            bins2 = [];
            for i = 1:length(bins_all(1))
                bins1 = [bins1; squeeze(marg_(:,bins_all{1}(i),iLoc,itypes,:))];
                bins2 = [bins2; squeeze(marg_(:,bins_all{2}(i),iLoc,itypes,:))];
            end
            [ave1, ~, ~, ~, bins1_SE] = getCI(bins1,2,1,1,ones(nsubjs));
            [ave2, ~, ~, ~, bins2_SE] = getCI(bins2,2,1,1,ones(nsubjs));
        
            for iparam = 1:size(bins1,2)
                figure('Units', 'pixels', 'Position', [0 0 1280 1280]), hold on
                
                [h,p,~,stats] = ttest(squeeze(bins1(:,iparam)), squeeze(bins2(:,iparam)), 'Alpha', .05/ncats);
                if h == 1, txt1 = '*'; else, txt1 = ''; end
                
                barObj = bar(1, ave1(iparam), 'EdgeColor', plotColors{bins_all{1}}, 'FaceColor', 'none', 'LineWidth', borderSize_indvd, 'BarWidth', .5);
                errorbar(1, ave1(iparam), bins1_SE(iparam), '.', 'CapSize', 0, 'color', plotColors{nBins},'LineWidth',1)
                
                barObj = bar(2, ave2(iparam), 'EdgeColor', plotColors{bins_all{2}}, 'FaceColor', 'none', 'LineWidth', borderSize_indvd, 'BarWidth', .5);
                errorbar(2, ave2(iparam), bins2_SE(iparam), '.', 'CapSize', 0, 'color', plotColors{nBins},'LineWidth',1)

                % Plot individuals
                for isubj = 1:nsubjs
                    mm = squeeze(marg_(isubj,[bins_all{1},bins_all{2}],iLoc,itypes,iparam));
                    plot([1.2 1.8], mm, sprintf('%s-', markers_allSubj{isubj}), ...
                        'Color', [plotColors{nBins}, .2], 'LineWidth', lineSize, 'MarkerSize', markerFontSize)
                end

                % Calculate within subj SEM
                withinSEM = nan(nsubjs,1);
                for isubj = 1:nsubjs
                    withinSEM(isubj) = marg_(isubj,bins_all{1},iLoc,itypes,iparam) - marg_(isubj,bins_all{2},iLoc,itypes,iparam);
                end
                
                [~, ~, ~, ~, withinSEM] = getCI(withinSEM,2,1,1,ones(nsubjs));
                plot([1,2],[xlim_allM2(iparam),xlim_allM2(iparam)], 'k')
                errorbar(1.5,xlim_allM2(iparam), withinSEM, 'k', 'CapSize',0, LineWidth=1)

                ylim(xlim_allM(iparam, :))
                xticks([1,2])
                xticklabels({sprintf('Bin%d',bins_all{1}), sprintf('Bin%d',bins_all{2})})
                axis square

                txt = sprintf(['%s[%s]' ...
                               '\nt(%d) = %01.4f, p = %01.4f%s\n'],...
                               namesTuningC_all{iF}{iparam}, namesType{itypes}, stats.df, stats.tstat, p,txt1);
                title(txt)

                set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)

            nameFileFigure = sprintf('figs/Perceptual Learning RC/%s/%s/T Tests/TuningC/TuningC_%s_%s_%s.jpg', ...
                locName, folderName, namesLocComb{iLocComb_all(iLoc)}, namesFeature{ifeature}, namesTuningC_all{iF}{iparam});
            saveas(gcf,nameFileFigure)
            end %end of iparam
        end %end of itype
    end %end of ifeature
end %end of iLoc

%% Scatter Plot Params
mkdir(sprintf('figs/Perceptual Learning RC/%s/%s/T Tests/TuningC', ...
    locName, folderName))
for ifeature = 1:2
    close all
    if ifeature == 1
        marg_ = margTuningCharOri; 
        xlim_allM = [-.2,.2; -30, 30; -.1, .1];
        ci = margParamsOri_CI;
        iF = 1;
%         xlim_allM2 = [.2; 30;.025];
    else
        marg_ = margTuningCharSF;
        xlim_allM = [-1,1; -.1,.1; -2.5,2.5; -.1, .1; -.1, .1];
        ci = margParamsSF_CI;
        iF = 3;
%         xlim_allM2 = [3*.8;.1;2;.04;.05*.8];
    end
    for iLoc = 1:2
        if iLoc == 1, plotColors = colorGradient(iLocComb_all(1),:); else, plotColors = colorGradient(iLocComb_all(2),:);end
        if iLocComb_all(1) == 1, plotColors = colorGradient(9,:); elseif iLocComb_all(2) == 8, plotColors = colorGradient(10,:);end
        for iparam = 1:size(marg_,5)
            figure ('Units', 'pixels', 'Position', [0, 0, 1280, 1280]), hold on, box on
            bins1 = squeeze(marg_(:,bins_all{1}(1),iLoc,3,iparam));
            bins2 = squeeze(marg_(:,bins_all{2}(1),iLoc,3,iparam));
            center = mean(marg_(:,[1,nBins],iLoc,3,iparam),'all');
        
            for isubj = 1:nsubjs
                errorbar(bins1(isubj) - center, bins2(isubj) - center,...
                    ci(isubj,4,iLoc,itypes,iparam,1), ci(isubj,4,iLoc,itypes,iparam,2), ...
                    ci(isubj,1,iLoc,itypes,iparam,1), ci(isubj,1,iLoc,itypes,iparam,2), ...
                    'CapSize', 0, 'Color', plotColors{nBins}, 'LineWidth', lineSize)
            end

            for isubj = 1:nsubjs
                plot(bins1(isubj) - center, bins2(isubj) - center, sprintf('%s', markers_allSubj{isubj}), ...
                    'MarkerSize', markerFontSize, 'MarkerFaceColor', 'w', ...
                    'Color', plotColors{nBins});
            end

            plot((-50):.05:50, (-50):.05:50, '-k')
            
            if ifeature == 1, iifeature = 1; else, iifeature = 3; end
            title(sprintf('%s', namesTuningC_all{iifeature}{iparam}))
            ylim(xlim_allM(iparam, :))
            xlim(xlim_allM(iparam, :))
            xlabel('Bin 1')
            ylabel('Bin 4')

            axis square

            set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)
            nameFileFigure = sprintf('figs/Perceptual Learning RC/%s/%s/T Tests/TuningC/TuningC2_%s_%s_%s_scatterPlot.jpg', ...
                locName, folderName, namesLocComb{iLocComb_all(iLoc)}, namesFeature{ifeature}, namesParams_all{iF}{iparam});
            saveas(gcf,nameFileFigure)
        end %end of iparam
    end %end of iLoc
end %end of ifeature