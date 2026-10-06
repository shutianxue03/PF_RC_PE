
function params_fit = fxn_organizeParams(printFlag, namesParams, nTunParams, nBins, nLoc, ind_tunParam, params_fit_)

% reorganize params_est according to each condition

params_fit = cell(1,nTunParams);
paramsLen = nan(nTunParams, 1);%nLocTrue .^ ind_tunParam; %

for iparam = 1:nTunParams
    switch ind_tunParam(iparam)
        case 0, paramsLen(iparam)=1;
        case 1, paramsLen(iparam)=nBins;
        case 2, paramsLen(iparam)=nLoc;
        case 3, paramsLen(iparam)=nBins*nLoc;
    end
end
if printFlag, fprintf('%s\n', num2str(ind_tunParam)), end

for iparam = 1:nTunParams
    % decide the start
    if iparam==1, iStart = 1;
    else, iStart = sum(paramsLen(1:iparam-1))+1;
    end
    
    % decide the end
    if iparam == nTunParams, iEnd =  sum(paramsLen);
    else, iEnd = sum(paramsLen) - sum(paramsLen(iparam+1:end));
    end
    
    params_fit{iparam} = params_fit_(iStart:iEnd);
    
    if printFlag
        fprintf('%s: %s\n', namesParams{iparam}, num2str(params_fit{iparam}))
    end
end

if printFlag, fprintf('\n'), end

