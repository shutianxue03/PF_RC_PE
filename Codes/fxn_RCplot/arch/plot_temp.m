% 
% 
% 
% data_toPlot = [y_perSubj(:); yPred_SSE_allModels(:)];
% ymin_ = min(data_toPlot);
% ymax_ = max(data_toPlot);
% 
% for imodel_s = 1:nmodels_s
%     subplot(nsubj, nmodels_s, (isubj-1)*nmodels_s+imodel_s), hold on
%     for n=1:2
%         yData_toPlot = squeeze(yData_allSubj(isubj, n, :));
%         yPred_toPlot = squeeze(yPred_SSE_allModels(iIC_sort(imodel_s), n, :));
%         plot(xaxis, yData_toPlot, 'o', 'MarkerSize', 3, 'color', colors_comb(combInd(icomb, n), :))
%         plot(xaxis, yPred_toPlot, '-', 'color', colors_comb(combInd(icomb, n), :))
%         % R2
%         R2 = getR2(yData_toPlot, yPred_toPlot);
%         text(xaxis(2), ymax_ - buffer*n, sprintf('%d%%', round(R2*100)), 'color', colors_comb(combInd(icomb, n), :))
%     end
%     ylim([ymin_, ymax_])
%     yline(0, 'k--');
%     if imodel_s == 1, ylabel(subjList{isubj}), end
%     
%     title(sprintf('%s (%d)', num2str(paramInd_all(iIC_sort(imodel_s), :)), round(IC_sort(imodel_s))))
%     
%     yline(0, 'k--');
%     if ifeature == 1
%         xline(0,'k');
%         xticks([-80,0,80])
%         xaxis = xaxis_itp;
%     else
%         xline(1,'k');
%         xticks([0,1,2]), xticklabels([1,2,4])
%         xaxis = log2(xaxis_itp);
%     end
%     
%     % xticks and yticks
%     if imodel_s > 1
%         xticks([])
%         yticks([])
%     end
% end
% 
% 
% 
