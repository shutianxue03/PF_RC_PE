function output = kernelFit(params, x, y, model, fitMode)
% fitMode: SSE = 1, MLE = 2;

nfilters = size(y,2);
y_pred = predSFkernel(x, model, params, 0);

weight = ones(1,nfilters);
% weight = [linspace(1,20, round(nfilters/2)), linspace(20,1, nfilters - round(nfilters/2))];

switch fitMode 
    case 1, output = sum(weight .* (y - y_pred).^2); % SSE
    case 2, output = -sum(weight .* normpdf(y, y_pred, 1),'all'); % MLE
end