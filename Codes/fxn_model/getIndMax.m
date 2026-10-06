function [maxIV, maxORI, maxSF_log] = getIndMax(IV2D_ORI_nonselected, ORI_bound, plotFlag)

% load('Data_OOD/params_RC')
SX_RC1_setting
IV2D = IV2D_ORI_nonselected(ORI_bound(1):ORI_bound(2), :);

maxIV = max(IV2D(:));

[imaxORI, imaxSF] = find(IV2D_ORI_nonselected == maxIV);
maxORI = axis_tuning{1}(imaxORI);
maxSF_log = axis_tuning{2}(imaxSF);

if plotFlag
    hold on
    imagesc(IV2D_ORI_nonselected), plot(imaxSF, imaxORI, 'r*')
    yline(ORI_bound(1), 'r-', 'linewidth', 2);
    yline(ORI_bound(2), 'r-', 'linewidth', 2);
    colorbar
end