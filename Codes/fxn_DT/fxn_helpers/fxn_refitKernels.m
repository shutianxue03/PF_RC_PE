function [kernels, nLL] = fxn_refitKernels(allKernels, ifeature, lb_full, ub_full, x)
%FXN_REFITKERNELS Summary of this function goes here
%   Detailed explanation goes here

% allKernels = squeeze(median(allKernels,1))';
allKernels = squeeze(allKernels);

if ifeature == 1
    lb = lb_full{1};
    ub = ub_full{1};
    imodel = 1;
else
    lb = lb_full{2};
    ub = ub_full{2};
    imodel = 2;
    x = 2.^x;
end
sampParam0 = @(lb, ub) rand(1,length(ub)) .* (ub-lb) + lb;
options = optimoptions('fmincon','MaxIterations', 5000,'Display','off');

params0 = sampParam0(lb, ub);
kernelFit_fxn = @(kernelParams) kernelFit(kernelParams, x, allKernels, imodel, 2);
[params_est, nLL] = fmincon(kernelFit_fxn, params0, [], [], [], [], lb, ub, [], options);
kernels = predSFkernel(x, imodel, params_est, 0);
end

