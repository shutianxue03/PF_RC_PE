
function [e2D_allT, phase2D_allT] = SX_RC4_Energy_parfor(mask, patch_allT, filter_sin, filter_cos)

[nORI, nSF] = size(filter_sin);
plot4parts = 0;     % 1 = plot the stim and two filters
nAllTrials = length(patch_allT);

% empty containers
e2D_allT = nan(nAllTrials, nORI, nSF);
phase2D_allT = e2D_allT;

% loop to calculate energy of each channel
for iORI = 1:nORI
    for iSF = 1:nSF
        filter_sin_ = filter_sin{iORI, iSF};
        filter_cos_ = filter_cos{iORI, iSF};
        parfor itrial = 1:nAllTrials
            [a,b] = SX_sim04_computeEnergy(mask, patch_allT{itrial}, filter_sin_, filter_cos_, plot4parts);
            e2D_allT(itrial, iORI, iSF) = a;
            phase2D_allT(itrial, iORI, iSF) = b;
        end
        fprintf('ORI #%d/%d SF #%d/%d DONE.\n', iORI, nORI, iSF, nSF)
    end % iSF
end % iORI

fprintf('DONE\n')


