function [filter_sin, filter_cos] = SX_sim02_setFilters(stim, filtersSF_all, filtersOri, plotFlag)

cstOfFilter = 1; % the contrast of the filter, 100%

nfiltersSF = length(filtersSF_all);
nfiltersOri = length(filtersOri);

filter_sin = cell(nfiltersOri, nfiltersSF);
filter_cos = filter_sin;

if plotFlag, figure('Position', [0 0 500 400]), end

for oo = 1:nfiltersOri
    stim.targetOri = filtersOri(oo);
    for ff = 1:nfiltersSF
        stim.gaborSF = filtersSF_all(ff); % divided by ppd
        
        for n = 1:2 % sin and cos
            stim.phase = pi/2 * (n-1); % sin: 0, cos: pi/2
            % use SX's code
            patch = exp_CreateGabor(stim, cstOfFilter, 0);% .* stim.mask;
            
            if n==1, filter_sin{oo, ff} = patch; else, filter_cos{oo, ff} = patch; end
        end
        if plotFlag
            subplot(nfiltersSF, nfiltersOri, oo+(ff-1)*nfiltersOri)
            imshow(patch)
            title(sprintf('ori = %d, SF = %.2f', stim.targetOri, stim.gaborSF))
        end
    end
end


