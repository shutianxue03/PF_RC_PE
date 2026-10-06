
function [energy, phaseValue] = SX_sim04_computeEnergy(mask, patch, filter_sin_raw, filter_cos_raw, plot4parts)
% FernandezLiCarrasco_2019
if isempty(patch), return, end
lumiBG = patch(1,1);

filter_sin_m = filter_sin_raw.*mask;
filter_cos_m = filter_cos_raw.*mask;
filter_sin = filter_sin_m/sum(filter_sin_m(:).^2);   % normalize the filter
filter_cos = filter_cos_m/sum(filter_cos_m(:).^2); % normalize the filter

patch =  patch - lumiBG;
stim_sin = patch(:)' * filter_sin(:);
stim_cos = patch(:)' * filter_cos(:);
energy = sqrt(stim_sin^2 + stim_cos^2);
phaseValue = atan2(stim_sin, stim_cos);

%%
if plot4parts
    figure('Position',[0 300 400 400])
    subplot(2,2,1), imshow(patch),title('stim')
    subplot(2,2,2), imshow(filter_sin),title('sin filter')
    subplot(2,2,3), imshow(filter_sin.^2),title('sin filter^2')
    subplot(2,2,4), imshow(filter_sin.*patch),title('filter x stim')
    suptitle(sprintf('energy = %.4f\n',energy))
    pause(.5)
end
