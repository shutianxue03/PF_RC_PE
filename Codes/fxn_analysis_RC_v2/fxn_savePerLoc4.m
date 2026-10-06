% metrics
similarityAfterMirroring_4allSubj(isubj, iB_start:iB_end, :, iiLoc4, :) = similarityAfterMirroring_allB(:, :, iiLoc2, :);
sep_4allSubj(isubj, iB_start:iB_end, :, iiLoc4, :) = sep_allB(:, :, iiLoc2, :); assert(~any(isnan(sep_allB(:))))

% marg
margORI_4allSubj(isubj, iB_start:iB_end, :, iiLoc4, :, :) = margORI_allB(:, :, iiLoc2, :, :);
margSF_4allSubj(isubj, iB_start:iB_end, :, iiLoc4, :, :) = margSF_allB(:, :, iiLoc2, :, :);

% pred
margPredORI_4allSubj(isubj, iB_start:iB_end, :, iiLoc4, :, :) = margPredORI_allB(:, :, iiLoc2, :, :);
margPredSF_4allSubj(isubj, iB_start:iB_end, :, iiLoc4, :, :) = margPredSF_allB(:, :, iiLoc2, :, :);
margR2ORI_4allSubj(isubj, iB_start:iB_end, :, iiLoc4, :, :) = margR2ORI_allB(:, :, iiLoc2, :);
margR2SF_4allSubj(isubj, iB_start:iB_end, :, iiLoc4, :, :) = margR2SF_allB(:, :, iiLoc2, :);

% estimated params
margParamsORI_4allSubj(isubj, iB_start:iB_end, :, iiLoc4, :, :) = margParamsORI_allB(:, :, iiLoc2, :, :);
margParamsSF_4allSubj(isubj, iB_start:iB_end, :, iiLoc4, :, :) = margParamsSF_allB(:, :, iiLoc2, :, :);

% tuning characteristics
margTuningC_ORI_4allSubj(isubj, iB_start:iB_end, :, iiLoc4, :, :) = margTuningC_ORI_allB(:, :, iiLoc2, :, :);
margTuningC_SF_4allSubj(isubj, iB_start:iB_end, :, iiLoc4, :, :) = margTuningC_SF_allB(:, :, iiLoc2, :, :);

if flag_ABSprefORI, margTuningC_ORI_4allSubj(:, :, :, :, :, 1) = abs(margTuningC_ORI_4allSubj(:, :, :, :, :, 1)); end

