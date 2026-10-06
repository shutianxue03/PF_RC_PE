
% tuning characteristics
margTuningC_ORI_4allSubj(:, :, :, iiLoc4, :, :) = margTuningC_ORI_allSubj(:, :, :, iiLoc2, :, :);
margTuningC_SF_4allSubj(:, :, :, iiLoc4, :, :) = margTuningC_SF_allSubj(:, :, :, iiLoc2, :, :);

if flag_ABSprefORI, margTuningC_ORI_4allSubj(:, :, :, :, :, 1) = abs(margTuningC_ORI_4allSubj(:, :, :, :, :, 1)); end

% % metrics
% similarityAfterMirroring_4allSubj(:, :, :, iiLoc4, :) = similarityAfterMirroring_allSubj(:, :, :, iiLoc2, :);
% sep_4allSubj(:, :, :, iiLoc4, :) = sep_allSubj(:, :, :, iiLoc2, :); assert(~any(isnan(sep_allSubj(:))))
% 
% % marg
% margORI_4allSubj(:, :, :, iiLoc4, :, :) = margORI_allSubj(:, :, :, iiLoc2, :, :);
% margSF_4allSubj(:, :, :, iiLoc4, :, :) = margSF_allSubj(:, :, :, iiLoc2, :, :);
% 
% % pred
% margPredORI_4allSubj(:, :, :, iiLoc4, :, :) = margPredORI_allSubj(:, :, :, iiLoc2, :, :);
% margPredSF_4allSubj(:, :, :, iiLoc4, :, :) = margPredSF_allSubj(:, :, :, iiLoc2, :, :);
% margR2ORI_4allSubj(:, :, :, iiLoc4, :, :) = margR2ORI_allSubj(:, :, :, iiLoc2, :);
% margR2SF_4allSubj(:, :, :, iiLoc4, :, :) = margR2SF_allSubj(:, :, :, iiLoc2, :);
% 
% % estimated params
% margParamsORI_4allSubj(:, :, :, iiLoc4, :, :) = margParams_ORI_allSubj(:, :, :, iiLoc2, :, :);
% margParamsSF_4allSubj(:, :, :, iiLoc4, :, :) = margParams_SF_allSubj(:, :, :, iiLoc2, :, :);


