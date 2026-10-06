function paramInd_all = fxn_getParamInd(nParams, indVar)

% Generate grids for each parameter
switch nParams
    case 3
        [a, b, c] = ndgrid(indVar, indVar, indVar);
        a=a(:); b=b(:); c=c(:);
        paramInd_all = [a, b, c];
    case 4
        [a, b, c,d] = ndgrid(indVar, indVar, indVar, indVar);
        a=a(:); b=b(:); c=c(:);d=d(:);
        paramInd_all = [a, b, c,d];
    case 5
        [a, b, c,d,e] = ndgrid(indVar, indVar, indVar, indVar, indVar);
        a=a(:); b=b(:); c=c(:);d=d(:);e=e(:);
        paramInd_all = [a, b, c,d,e];
end