
function [ub, lb, params0] = MC_getLimits(ind_tunParam, ub_full, lb_full, nBins, nLoc)
ub = [];
lb = [];
params0 = [];
sampParam0 = @(lb, ub, n) rand(1,n) .* (ub-lb) + lb;

nTunParams = length(ind_tunParam);

% organize ub, lb and param0 given a certain param combination
rng default % For reproducibility

for iParam = 1:nTunParams
    switch ind_tunParam(iParam)
        case 0, a = 1;
        case 1, a = nBins;
        case 2, a = nLoc;
        case 3,  a = nLoc*nBins;
    end
    ub = [ub, ones(1, a)*ub_full(iParam)];
    lb = [lb, ones(1,a)*lb_full(iParam)];
    params0 = [params0, sampParam0(lb_full(iParam), ub_full(iParam), a)]; % set param0
    
end

