function [mask] = exp_CreateCircularAperture(imgsize,aperturePeakProportion)
%
% Creates a circular aperture that is smoothed by half of a cosine wave,
% such that the filter reachs 0 just at the radius
%
% imgsize: size of image (in pixels; assumes square pixels)
% aperturePeakProportion: proportion of image at peak of aperture
%
% ian donovan 09/14/16

aperturePeakSpread = (imgsize*aperturePeakProportion)/2;
centerCoord = imgsize/2;
cosWaveLength = (imgsize/2-aperturePeakSpread)*2;%(imgsize/2-aperturePeakSpread)*2;

mask = zeros(imgsize);
range = 1:imgsize;

mtxLabels(:,:,1) = repmat(range',[1,imgsize]);
mtxLabels(:,:,2) = repmat(range,[imgsize,1]);

coordMTX = mtxLabels-centerCoord;
distFromCenterMTX = sqrt(coordMTX(:,:,1).^2+coordMTX(:,:,2).^2);
distFromApertureMTX = distFromCenterMTX-aperturePeakSpread;

cosRangeLocs = distFromCenterMTX > aperturePeakSpread & distFromApertureMTX < (cosWaveLength/2);%(cosWaveLength/2);
flatRangeLocs = distFromCenterMTX <= aperturePeakSpread;

mask(cosRangeLocs==1) = (cos(distFromApertureMTX((cosRangeLocs==1)).*((2*pi)/(cosWaveLength)))+1)./2;

% mask(cosRangeLocs==1) = (cos(distFromApertureMTX((cosRangeLocs==1)).*((2*pi)/(cosWaveLength)))-.5).*2;

mask(flatRangeLocs==1) = 1;

mask(mask<0) = 0;
