function [modelParams] = DT_setModelParams(nparams, paramInd_all, modelInd, trueParams)
%DT_SETMODELPARAMS Summary of this function goes here
%   Detailed explanation goes here

modelParams = nan(nparams, 2);
for j = 1:nparams
    if paramInd_all(modelInd,j) == 0
        modelParams(j,1) = mean([trueParams(j,1), trueParams(j,2)]);
        modelParams(j,2) = mean([trueParams(j,1), trueParams(j,2)]);
    else
        modelParams(j,1) = trueParams(j,1);
        modelParams(j,2) = trueParams(j,2);
    end
end

end

