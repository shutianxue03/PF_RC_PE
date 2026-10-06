function [estParams, nLL] = fxn_fitToModel(x,y,modelparams, lb_full, ub_full, nmodels, ifamily, fitmode)
%FXN_FITTOMODEL Summary of this function goes here
%   nLL = array of nLL for each model given one pair of datasets
% estParams = matrix of fitted parameters for each model given one pair of datasets

% options = optimoptions('fmincon','Algorithm','interior-point','MaxIter',5000,'Display','off');
options = optimoptions('fmincon','MaxIterations', 5000,'Display','off');

% Compare models
nLL = nan(1,size(modelparams,1));
estParams = cell(nmodels, 1);
for i = 1:nmodels
    [ub, lb, params0] = MC_getLimits(modelparams(i,:), ub_full, lb_full, size(y,1));

    kernelFit_fxn = @(kernelParams) MC_getDev_CV(modelparams(i,:), kernelParams, x, y, ifamily, fitmode);
    [estParams_, nLL_] = fmincon(kernelFit_fxn, params0, [], [], [], [], lb, ub, [], options);
    estParams(i) = {estParams_};
    nLL(i) = nLL_;
end

end

