function [estParams, rho, p] = DT_optParams(x, yData, lb_full, ub_full, imodel, fitmode)
nData = length(yData);

% at each each time of fitting, param0 should be sample randomly from [lb, ub]
sampParam0 = @(lb, ub) rand(1,length(ub)) .* (ub-lb) + lb;

% options = optimoptions('fmincon','Algorithm','interior-point','MaxIter',5000,'Display','off');
options = optimoptions('fmincon','MaxIterations', 5000,'Display','off');
estParams = nan(nData,3);
nLL_ = nan(1,nData);
% true_Gain  = [.25, .4];
% true_Width = [16, 25];
% true_Base = [-.1, .15];
% trueParams = [true_Gain(1); true_Width(1); true_Base(1)];
% nLL_true = kernelFit(trueParams, x, yData{1}, imodel, fitmode);

% Loop through all dataset of one location and find optimal parameters
parfor i = 1:nData

    params0 = sampParam0(lb_full, ub_full); % set param0
    y = yData{i};
    kernelFit_fxn = @(kernelParams) kernelFit(kernelParams, x, y, imodel, fitmode);
    [params_est, nLL] = fmincon(kernelFit_fxn, params0, [], [], [], [], lb_full, ub_full, [], options);
    estParams(i,:) = params_est;
    % nLL_(i) = nLL;
    if mod(i,100)==0, fprintf('='); end
end

% Corr analysis
rho = nan(1,3);
p = nan(1,3);

p1 = estParams(:,1);
p2 = estParams(:,3);
[rho(1), p(1)] = corr(p1, p2);

p1 = estParams(:,1);
p2 = estParams(:,2);
[rho(2), p(2)] = corr(p1, p2);

p1 = estParams(:,2);
p2 = estParams(:,3);
[rho(3), p(3)] = corr(p1, p2);