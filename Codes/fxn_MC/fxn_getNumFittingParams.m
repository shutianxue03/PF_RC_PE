
function nFitParams = fxn_getNumFittingParams(ind_tunParam, nBins, nLoc)

nTunParams = length(ind_tunParam);

nFitParams = 0; 

for itunParam = 1:nTunParams
    switch ind_tunParam(itunParam)
        case 0, nFitParams_ = 1;
        case 1, nFitParams_ = nBins;
        case 2, nFitParams_ = nLoc;
        case 3, nFitParams_ = nBins * nLoc;
    end
    nFitParams = nFitParams + nFitParams_;
end