
function [k, i, margORI, margSF, R2, R2_Tjur, p, pCat, sep] = SX_RC6_kernel_parfor(e3D, dataMatrix, filtersSF_all, filtersOri_all)

ntypes = 3; % 1=PRS, 2=ABS, 3=BOTH types
[ntrials, nORI, nSF] = size(e3D);

%% create empty containers
% way 1: combine locations by concatenating all trials
k = nan(ntypes, nORI, nSF); % 2D data
i = k;
R2 = k;
R2_Tjur = k;
margORI = nan(ntypes, nORI);
margSF = nan(ntypes, nSF);
p = nan(ntypes, nORI, nSF, 2); % 2: p-value of intercept and slope
pCat = k;
sep = nan(ntypes, 1); % p values of check separability

for itype = 1:ntypes % 1=PRS, 2=ABS, 3=BOTH
    
    switch itype
        case 1, indPRS = dataMatrix(:, 6) == 1;
        case 2, indPRS = dataMatrix(:, 6) == 0;
        case 3, indPRS = 1:ntrials;
    end
    % SX_sim07_RC runs parfor
    [kernels2D, intercepts2D, R2_2D, R2_Tjur_, pValues_, pCat_] = SX_sim07_RC(filtersSF_all, filtersOri_all, e3D(indPRS,:, :), dataMatrix(indPRS, 9));
    k(itype, :, :) = kernels2D;
    i(itype, :, :) = intercepts2D;
    R2(itype, :, :) = R2_2D;
    R2_Tjur(itype, :, :) = R2_Tjur_;
    p(itype, :, :, :) = pValues_;
    pCat(itype, :, :) = pCat_;
    
    % get separability
    sep(itype) = getSeparability(kernels2D);
    
    % get marginalization
    margORI(itype, :) = squeeze(mean(kernels2D, 2));
    margSF(itype, :) = squeeze(mean(kernels2D, 1));
end
