%%%%%%%%%%%%%%%%%%
% DEPRECATED
%%%%%%%%%%%%%%%%%%

close all
%%
ylims1 = [-.3,.3; -.6, .6; 1, 5;];
yticks1 = [-.2 0 .2;
            -.4 0 .4;
            1:3];
ylims2 = [-.25,.25; -.5, .5; -.5, .5; -1, 1; -1, 1; -.5, .5;];
xticks_ = [0 .1 .2];
xlims = [-.03 .23];
saveDir = sprintf('%s/TuningCRatio/', dirName);
mkdir(sprintf('%s/TuningCRatio/ORI', dirName))
mkdir(sprintf('%s/TuningCRatio/SF', dirName))

marg__ = timeBiningTbl{1:11,3};
for ifeature = 2%1:2
    if ifeature == 1, marg_ = margTuningCharORIRatio; ifamily = 1; nparams = 3;
    else, marg_ = margTuningCharSFRatio; ifamily = 2; nparams = 4; end
        for iparam = 2%1:nparams
            figure('Units', 'pixels', 'Position', [0, 0, 1280, 1280]), hold on, box on
            data_x = [];
            data_y = [];
            locInd = [];
            for isubj = isubj2%1:nsubjs
%                 for iiLoc = [1 2 3 4 5]
% 					plot(squeeze(marg__(isubj)), squeeze(marg_(iiLoc, isubj,iparam)), ...
%                         'o', 'MarkerSize', 48, 'MarkerEdgeColor', 'w', 'MarkerFaceColor', [1 1 1],'LineWidth', 4)
                    plot(squeeze(marg__(isubj)), mean(squeeze(marg_(iiLoc, isubj,iparam))), ...
                        markers_allSubj{isubj}, 'MarkerSize', 36, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [0 0 0],'LineWidth', 4)
					
%                 errorbar(margCstMag(isubj,iiLoc), marg_(isubj,iiLoc,iparam), .1, '.k')
%                     if iiLoc < 6
                        data_x = [data_x; squeeze(marg__(isubj))];
                        data_y = [data_y; mean(squeeze(marg_(iiLoc, isubj, iparam)))];
                        locInd = [locInd; iiLoc];
%                     end
%                 end
            end
%             if ifeature == 1
%                 plot(xlim',ylims1(iparam,:)', '-k')
%             else
%                 plot(xlim,ylims2(iparam,:), '-k')
%             end

            mdl = fitlm(data_x, data_y);

%            p = plot([min(data_x), max(data_x)]-mean(data_x), mdl.Coefficients{2,1} .* ([min(data_x), max(data_x)]-mean(data_x)), '-k', 'LineWidth', 6);
            p = plot([min(data_x), max(data_x)], mdl.Coefficients{2,1} .* ([min(data_x), max(data_x)]) + mdl.Coefficients{1,1}, '-k', 'LineWidth', 6);

%             [r, p] = partialcorr([data_x, data_y], locInd);
            [r, p] = corr(data_x, data_y);
%             r = r(2,1); p = p(2,1);

            a= squeeze(marg_(:,:,iparam));
            b= squeeze(margCstRatio(:,:));
%             [r, p] = corr(b(:),a(:));
%             if ifeature == 2, pName = 3; ylim(ylims2(iparam,:)); else, pName = 1; ylim(ylims1(iparam,:));end
%             title(sprintf('%s \npartial corr: r=%.2f p=%.2f', namesTuningC_all{ifamily}{iparam}, r, p))
           fprintf('%s Pearson''s r=%.2f p=%.3f\n', namesTuningC_all{ifamily}{iparam}, r, p)
%            xlim(xlims)
%            xticks(xticks_)
%            if(ifeature ==1), ylim(ylims1(iparam,:)); yticks(yticks1(iparam,:)); end
           yline(0, '-', 'Color', [.5 .5 .5], 'LineWidth', 3)
           xline(0, '-', 'Color', [.5 .5 .5], 'LineWidth', 3)
%             xlabel('Change in contrast sensitivity')
%             ylabel(sprintf('Change in %s',namesTuningC_all{ifamily}{iparam}))
            axis square

            set(findall(gcf, '-property', 'FontSize'), 'FontSize',48)
            set(gca, 'LineWidth', 6)
            nameFileFigure = sprintf('%s/%s/Corr2_%s_all.jpg', saveDir, namesFeature{ifeature}, namesTuningC_all{ifamily}{iparam});
            exportgraphics(gcf,nameFileFigure, 'Resolution', 300)
        end %end of iparam
end %end of ifeature

%% correlations
% marg__ = margCstRatio - mean(margCstRatio,2);
% for ifeature = 1:2
%     if ifeature == 1, marg_ = margTuningCharORIRatio - mean(margTuningCharORIRatio,2);
%     else, marg_ = margTuningCharSFRatio - mean(margTuningCharSFRatio,2);end
%     fprintf('ifeature: %d\n', ifeature)
%         for iparam = 1:size(marg_,3)
%             fprintf('iparam: %d\n', iparam)
%             for iloc = 1:8
%                 [r, p] = corr(squeeze(marg__(iloc,:))', squeeze(marg_(iloc, :, iparam))');
%                 fprintf('iloc: %d, r=%.2f, p=%.2f\n', iloc, r, p)
%             end
%         end
% end