function [tau, p] = partial_corr_kendall(X, Y, ind, type_tail)

% Step 1: Compute residuals of X after regressing on Z
bX = regress(X, [ones(size(ind)), ind]); % Fit linear model
X_residual = X - [ones(size(ind)), ind] * bX; % Compute residuals

% Step 2: Compute residuals of Y after regressing on Z
bY = regress(Y, [ones(size(ind)), ind]); % Fit linear model
Y_residual = Y - [ones(size(ind)), ind] * bY; % Compute residuals

% Step 3: Calculate Kendall's rank correlation between residuals
[tau, p] = corr(X_residual, Y_residual, 'type', 'kendall', 'tail', type_tail);

