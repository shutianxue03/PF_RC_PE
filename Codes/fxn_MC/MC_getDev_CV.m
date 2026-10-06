

function deviance = MC_getDev_CV(ind_tunParam, nBins, nLoc, params_est, x, y, ifamily, fitMode)

% SX_normPDF = @(x,mu,sigma) exp(-(x-mu).^2/(2*sigma^2));

%%
[nLines, nFilters] = size(y);
nTunParams = length(ind_tunParam);
ndata = nLines * nFilters; % after reorganizing the matrix (y) to a vector

%% empty container
deviance = nan(1, nLines);

%% predict
y_pred = MC_predKernel(ind_tunParam, x, nBins, nLoc, nLines, nTunParams, params_est, ifamily);

% calculate the deviance for each line
for iLine = 1:nLines
    switch fitMode
        case 1 % LS method
            deviance(iLine) = sum((y(iLine, :) - y_pred(iLine, :)).^2);
        case 2 % ML method
            deviance(iLine) = -sum(log(normpdf(y(iLine, :), y_pred(iLine, :), 1)));
    end
end

% simple & quick plot
% figure('Position',[0 0 1e3 4e2]), hold on
% for iLine=1:nLines
%     plot(x, y(iLine, :), 'o--')
%     plot(x, y_pred(iLine, :), 'k-', 'LineWidth', 2)
% end
% title(sprintf('Family=%d [%s]', ifamily, num2str(ind_tunParam)))

%% get the combined deviance
if fitMode == 1
    deviance = sum(deviance(:))/ndata;
else
    deviance = sum(deviance(:));
end


