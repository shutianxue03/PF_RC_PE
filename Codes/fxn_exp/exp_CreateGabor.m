function [gabor, phase] = exp_CreateGabor(stim, cst, plotQ)
%  [gabor, phase] = exp_CreateGabor(stim, cst, plotQ)
% to generate Gabor with a circular window

limit0to1 = @(x) min(max(x, 1), 0);

[x1,y1] = meshgrid(1:stim.aper_psz, 1:stim.aper_psz); % size is the number of pixels
x2 = x1-mean(x1(:));
y2 = y1-mean(y1(:));
x3 = Scale(x2)*stim.aper_sz-stim.aper_sz/2; % Scale: perform an affine scaling to put data in range [0-1].
y3 = Scale(y2)*stim.aper_sz-stim.aper_sz/2;  

ori = stim.targetOri / 180 * pi; % all stim are always horizontally oriented
nx = x3*cos(ori) + y3*sin(ori);

if ~isfield(stim, 'phase'), phase =  rand * 2 *pi; else, phase = stim.phase; end

carrier = cos(nx .* stim.gaborSF * 2 * pi + phase);
modulator = exp(-((x3 / stim.gaborSD).^2)-((y3 / stim.gaborSD).^2)); 
gabor = carrier .* modulator * cst;

%% plot
if plotQ == 1
%     flatSpreadVisRadius = (stim.gabor_psz(1).*stim.flatSpread)/2;
    figure('position',[0 600 1000 200]), clf, hold on, 
    
    subplot(1,4,1)
    mesh(modulator)
    title('modulator')
    xlabel('X Pixel Loc')
    ylabel('Y Pixel Loc')
    zlabel('Contrast')

    subplot(1,4,2)
    mesh(carrier)
    title('carrier')
    xlabel('X Pixel Loc')
    ylabel('Y Pixel Loc')
    zlabel('Contrast')

    subplot(1,4,3)
    mesh(gabor)
    title('gabor')
    xlabel('X Pixel Loc')
    ylabel('Y Pixel Loc')
    zlabel('Brightness - ? Gray')
    hold off

    subplot(1,4,4)
    imshow(gabor)
    
%     sgtitle(sprintf('SF = %.1f spread DVA = %d', stim.gaborSF*32,flatSpreadVisRadius))
end

function output = Scale(input)
% output = Scale(input)
% Perform an affine scaling to put data in range [0-1].
minval = min(input(:));
maxval = max(input(:));
output = (input - minval) ./ (maxval-minval);
