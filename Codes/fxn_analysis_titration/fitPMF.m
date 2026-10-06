function [param, PMF] = fitPMF(x, data)

% assume mode is cumulative normal (according to the parameter)

fxn_CN = @(x, thresh, slope) normcdf(x, thresh, 1/slope);

MLE = @(params) -sum(log(normpdf(fxn_CN(x, params(1), params(2)), data)));

param0 = [.5, 1];

% options = optimoptions(@fmincon, 'MaxIterations', 1e5, 'Display', 'off');

param = fminsearch(MLE, param0);%, [], [], [], [], [], [], [], options);

PMF = fxn_CN(x, param(1), param(2));

