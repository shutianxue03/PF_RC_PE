function dev = DT_ModelComparison(nparams, paramInd_all, nmodels, x, y, lb_full, ub_full, ifamily, fitmode, plotmode)

getBIC = @(nLL, nparamsAll, ndata) ndata * nLL + nparamsAll * log(ndata);
getAIC = @(err, nparamsAll, ndata) ndata * err+ 2*nparamsAll;
getAICc = @(err, nparamsAll, ndata) ndata * err+ 2*nparamsAll + 2*nparamsAll*(nparamsAll+1)/(ndata-nparamsAll-1);

nSimData = size(y,2);
nLL = nan(nSimData, nmodels);

parfor j = 1:nSimData
    y1 = y{1,j};
    y2 = y{2,j};
    y0 = [y1;y2];
    [~, nLL(j,:)] = fxn_fitToModel(x,y0,paramInd_all,lb_full,ub_full,nmodels,ifamily,fitmode);
end

dev = nan(nSimData, nmodels);
switch plotmode
    case 1
        dev = getBIC(nLL, nparams, nSimData*2);
        % dev = nLL;
    case 2
        dev = getAIC(nLL, nparams, nSimData*2);
    case 3
        dev = getAICc(nLL, nparams, nSimData*2);
end

end