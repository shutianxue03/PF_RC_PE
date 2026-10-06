%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%
close all
bin_list = [];
data_list = [];
data_CI = [];
data_median = [];
tuning_list = [];
itype = 3; % Check both PRS and ABS trials

ifeature = input('\nEnter feature to inspec (1=ORI 2=SF) ');

inspecLoc = input('\nEnter Loc to inspect (1=FOVEA 2=LHM 3=UVM 4=RHM 5=LVM 6=HM 7=VM 8=PERIFOVEA): ');
loc_list = inspecLoc;

bin_list = input('\nEnter in bin to inspec (e.g. [1 2 3 4]): ');

flagCheckData = input('\nDo you wish to check bootstrap data (1=YES 0=NO)? ');
if flagCheckData
    switch ifeature
        case 1
            data_list = margOri(loc_list, :, bin_list, itype, :);
            data_list_CI = margOri_CI(loc_list, :, bin_list, itype, :);
        case 2
            data_list = margSF(loc_list, :, bin_list, itype, :);
            data_list_CI = margSF_CI(loc_list, :, bin_list, itype, :);
    end
end

flagCheckTuning = input('\nDo you wish to check tuning functions (1=YES 0=NO)? ');
if flagCheckTuning
    switch ifeature
        case 1
            tuning_list = margPredOri(loc_list, :, bin_list, itype, :);
        case 2
            tuning_list = margPredSF(loc_list, :, bin_list, itype, :);
    end
    tuning_list = squeeze(tuning_list);
end

% Begin plotting
for iBin = bin_list
    % Create figure
    figure('Units','normalized', 'Position', [0 0 .6 .75]), hold on
    txt = sprintf('%s %s - %s', namesLocComb{loc_list}, namesFeature{ifeature}, namesType{itype});
    title(txt)

    % Set plot colors
    plotColors = colorGradient(loc_list,:);
    if loc_list == 1, plotColors = colorGradient(9,:);
    elseif loc_list == 8, plotColors = colorGradient(10,:);
    end
    
    % Draw indvidual plots
    for isubj = 1:nsubjs
        subplot(3,4,isubj), hold on
        title(subjList{isubj})
        % Draw guidelines
        if ifeature==1
            ylim([-.05, .2])
%             yline(margPred(loc_list,1,itype,15),'--')
            xline(0, '--')
            yline(0, '-k')
        else
            ylim([-.05, .1])
            xticks(0:.5:2)
            xticklabels(round(2.^(0:.5:2), 2))
%             yline(max(margPred(loc_list,1,itype,:)),'--')
            xline(1, '--')
            yline(0,'-k')
        end

        % Extract plot data
        data_median = squeeze(data_list(:,isubj,:,:,:));
        data_CI_neg = data_list_CI{1}';
        data_CI_pos = data_list_CI{2}';

        margPlot = data_median';
        margPlotSE_pos = data_CI_pos;
        margPlotSE_neg = data_CI_neg;
        margPredPlot = squeeze(tuning_list(isubj,:));
    %         margPredPlotSE = squeeze(margPredSE(loc_list(iLoc), iBin, itype, :, :));
        plot(axis_tuning{ifeature}, margPlot, '.', 'color', plotColors{iBin}, 'MarkerSize', 14);
        errorbar(axis_tuning{ifeature}, margPlot, margPlotSE_pos, margPlotSE_neg, 'LineStyle', 'none', 'color', plotColors{iBin}, 'CapSize', 0)
        plot(axis_tuning{ifeature}, margPredPlot, '-', 'color', plotColors{iBin}, 'LineWidth', 2)
    %         x = [axis_tuning{feature_list(ifeature)}, flip(axis_tuning{feature_list(ifeature)})];
    %         y = [margPredPlot' + margPredPlotSE(3,:), flip(margPredPlot' - margPredPlotSE(3,:))];
    %         patch(x, y, plotColors{iBin}(1:3), 'FaceAlpha', .3, 'linestyle', 'none');
        if ifeature==1
            ylim([-.05, .2])
            xlim([-90, 90]);
    %             mkdir(sprintf('%s/Animation/ORI/%s',dirName, namesLocComb{loc_list(iLoc)}))
    %             nameFileFigure = sprintf('%s/Animation/ORI/%s/T%d_ORI.jpg',dirName, namesLocComb{loc_list(iLoc)}, iBin);
    %             saveas(gcf,nameFileFigure)
        else
    %             mkdir(sprintf('%s/Animation/SF/%s',dirName, namesLocComb{loc_list(iLoc)}))
    %             nameFileFigure = sprintf('%s/Animation/SF/%s/T%d_SF.jpg',dirName, namesLocComb{loc_list(iLoc)}, iBin);
    %             saveas(gcf,nameFileFigure)
            ylim([-.05, .1])
        end
%         axis square
    end %end of isubj
end %end of iBin

set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)
