function [trueParams, nmodels, modelInd_all, x] = DT_setupParams(namesParams_all, nLoc2, ifamily, channel, sliceSize)
% DT_SETUPPARAMS Summary of this function goes here
%   Detailed explanation goes here

%Guess starting parameters for locations
true_Gain  = [.145, .1];
true_Width = [16, 14];
true_Base = [-.01, -.001];

namesParams = namesParams_all{ifamily};     % Names of my parameters
nparams_full = length(namesParams);         % Number of parameters

switch channel
    case 1, x = linspace(-90,90,sliceSize);
    case 2, x = linspace(2,4,sliceSize);
end

% Organize parameters for model comparisons
% decide number of models & the param index (1 = specified, 0 = shared)
if sum(ifamily == [3, 7]) % the truncation term is always left free
    nmodels = 2^(nparams_full-1);
    paramInd_all_ = fxn_getParamInd(nparams_full-1);
    modelInd_all = [paramInd_all_, ones(nmodels,1)];
else
    nmodels = 2^nparams_full;
    modelInd_all = fxn_getParamInd(nparams_full);
end

% Create candiate models
trueParams = cell(nmodels, 1);
for i = 1:nmodels
    modelInd = modelInd_all(i, :);
    for iparam = 1:nparams_full
        if modelInd(iparam) == 1
            trueParams(i) = {[trueParams{i},...
                [params0(1, iparam);params0(2, iparam)]]};       % set free to vary parameters
        else
            trueParams(i) = {[trueParams{i},...
                [params0(1, iparam);params0(1, iparam)]]};        % set shared parameters
        end
    end

end

