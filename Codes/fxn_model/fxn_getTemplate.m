
function [template] = fxn_getTemplate(kernels2D, templateType)

%% get templates
template_raw = kernels2D;
t_min = min(template_raw(:));
template_pos = template_raw - t_min + eps; % shift to make all values positive
template_recon = mean(template_pos,1) .* mean(template_pos,2);
% ampFactor = (max(template_raw(:)) - min(template_raw(:)))/( max(template_recon(:)) - min(template_recon(:)));
% shiftFactor = mean(template_raw(:)) - mean(template_recon(:));
% template_back= (template_recon + t_min + shiftFactor)*ampFactor ;

%% set template type
switch templateType
        % (1) the 2D kernel (raw)
    case 1, template = template_raw;
        % (2) the 2D kernel, all positive
    case 2, template = template_pos;
        % (3) the reconstructed 2D kernel
    case 3, template = template_recon;
        % (4) the energy profile of the gabor (only when nLoc=5)
    case 4, template = energy2D_gabor;
end

