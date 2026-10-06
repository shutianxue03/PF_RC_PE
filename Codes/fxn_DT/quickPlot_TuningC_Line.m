%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%
itype = itypes;

% for iloc = 1:5%1:nLoc8
    for ifeature = 1:2
        if ifeature == 1
            tuningC = margTuningCharORI;
            tuningC_mean = margTuningCharOri_Mean;
            tuningC_SE = margTuningCharOri_SE;
            nparams = nORI_TuningC;
            ifamily = 1;
            ybounds = oriBoundsTuning;
        else
            tuningC = margTuningCharSF;
            tuningC_mean = margTuningCharSF_Mean;
            tuningC_SE = margTuningCharSF_SE;
            nparams = nSF_TuningC;
            ifamily = 3;
            ybounds = sfBoundsTuning;
        end

        for iparam = 1:nparams
            data = [];
            IVs = [];
            close all
            figure('Units', 'pixels', 'Position', [0, 0, 1280, 1280]), hold on, box on
            for iloc = 1:5
                plotColor = colorGradient(iloc,:);
                if iloc == 1, plotColor = colorGradient(9,:);
                elseif iloc == 8, plotColor = colorGradient(10,:);
                end
                plot(1:nBins, squeeze(tuningC_mean(iloc, :, itype, iparam)), 'Color', plotColor{nBins}, 'LineWidth', 2);
                %TODO: Shaded area or errorbars
%                 errorbar(1:nBins, squeeze(tuningC_mean(iloc, :, itype, iparam)), squeeze(tuningC_SE(iloc,:,itype,iparam)),...
%                      '.', 'Color', plotColor{nBins}, 'LineWidth', 1.5, 'CapSize', 0)
            end%end of iloc

            str = sprintf('TuningC over time [%s]: %s', namesFeature{ifeature}, namesTuningC_all{ifamily}{iparam});
            title(str)
            ylim(ybounds(iparam,:))
%             if ifeature==2 && iparam==1, ylabel('SF (cpd)')
%             else, ylabel('A.U.')
%             end
            xticks(1:nBins)
            xticklabels({'Bin 1', 'Bin 2', 'Bin 3', 'Bin 4'})
            

            set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)
            set(findall(gcf, '-property', 'LineWidth'), 'LineWidth',lineSize)
            nameFileFigure = sprintf('%s/TuningC/Line_%s_%s.jpg', dirName, namesFeature{ifeature}, namesTuningC_all{ifamily}{iparam});
            if ~exist(sprintf('%s/TuningC', dirName), 'dir'), mkdir(sprintf('%s/TuningC', dirName)), end
            exportgraphics(gcf,nameFileFigure, 'Resolution', 300)
        end %end of iparam
    end %end of ifeature
% end %end of iloc
