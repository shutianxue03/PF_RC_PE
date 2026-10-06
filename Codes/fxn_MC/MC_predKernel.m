

function y_pred = MC_predKernel(ind_tunParams, x, nBins, nLoc, nLines, nTunParams, fitParams_est, ifamily)

% can be only used for nLoc=2 and nBins=3

% ind_tunParams: a vector indicating whether the param is fixed (0), only free to vary across bins (1) or only between loc (2) or both (3)
% nBins = 3
% nLoc = 2
% nLines: number of lines in y; =nBins*nLoc
% nTunParams: number of tuning parameters, dependent on the family
% fitParams_est: the fitting parameters
% ifamily

nFilters = size(x, 2);
printFlag = 0;

%% reorganize params_est according to each condition
params_est_reo = fxn_organizeParams(printFlag, {}, nTunParams, nBins, nLoc, ind_tunParams, fitParams_est);

%% predict y
y_pred = nan(nLines, nFilters);

for iLine = 1:nLines
    params = nan(1, nTunParams);
    
    for iparam = 1:nTunParams
        params_est_re = params_est_reo{iparam};
        
        % assign the chosen parameters to each loc
        switch ind_tunParams(iparam)
            case 0, params(iparam) = params_est_re;
            case 1 % 3 bins;
                if iLine <= nLoc, params(iparam) = params_est_re(1); % iLine is an odd number
                elseif iLine <= nLoc*2, params(iparam) = params_est_re(2); % iLine is an even number
                else, params(iparam) = params_est_re(3);
                end
            case 2 % nLoc
                if mod(iLine, nLoc)==1, params(iparam) = params_est_re(1); % iLine is an even number
                else, params(iparam) = params_est_re(2);
                end
            case 3 % nBins x nLoc
                params(iparam) = params_est_re(iLine);
        end
    end
    
    % predict y of the current line
    if  size(x,1) == 1
        y_pred(iLine, :) = predSFkernel(x, ifamily, params, 0);
    else
        y_pred(iLine, :) = predSFkernel(x(iLine, :), ifamily, params, 0);
    end
    
end

