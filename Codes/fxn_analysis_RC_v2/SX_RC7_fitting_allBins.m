
function [marg2, margPred2, margParams, margR2] = SX_RC7_fitting_allBins(ifeature, marg, ub_full, lb_full, ifamily_perF, ind_tunParams_perF, flag_standEnergy)
% load('params_RC.mat') % load some common parameters

global flag_cutMapping flag_interpolate
SX_RC1_setting

fitMode = 2; % 1=LS method
[nBins , nLoc, ntypes, nFilters] = size(marg);
nLines = nBins * nLoc;

options = optimoptions('fmincon','MaxIterations',5000,'Display','off');
nrep = 20; % number of reps to find the global minimum

ifamily = ifamily_perF(ifeature);
ind_tunParams = ind_tunParams_perF{ifeature};
nameModelParams = namesParams_all{ifamily};
nTunParams = length(nameModelParams);

% organize ub, lb and param0 given a certain param combination
[ub, lb, params0] = MC_getLimits(ind_tunParams, ub_full, lb_full, nBins, nLoc);

% get x
if ifeature==1
    axis_ln = axis_tuning{ifeature};
else
    axis_ln = 2.^axis_tuning{ifeature};
end

% empty containers
marg2 = nan(nBins, nLoc2, ntypes, nFilters);
margPred2 = nan(nBins, nLoc2, ntypes, nFilters);
margParams = nan(nBins, nLoc2, ntypes, nTunParams);
margR2 = nan(nBins, nLoc2, ntypes);

for itype = 1:ntypes
    
    % compile all lines into a matrix
    marg_allLines = nan(nLines, nFilters);
    iLine = 1;
    for iBin=1:nBins
        for iLoc=1:nLoc
            marg_allLines(iLine, :) = squeeze(marg(iBin, iLoc, itype, :));
            iLine = iLine+1;
        end
    end
    
    fxn_minimizeDev_ML = @(fitParams_est) MC_getDev_CV(ind_tunParams, nBins, nLoc, fitParams_est, axis_ln, marg_allLines, ifamily, fitMode);
    problem_ML = createOptimProblem('fmincon','objective', fxn_minimizeDev_ML,'x0',params0,'lb',lb,'ub',ub,'options',options);
    ms_ML = MultiStart('StartPointsToRun', 'bounds','UseParallel', 1, 'Display', 'off');
    fitParams_est = run(ms_ML, problem_ML, nrep);
    
    % predict
    margPred_allLines = MC_predKernel(ind_tunParams, axis_ln, nBins, nLoc, nLines, nTunParams, fitParams_est, ifamily);
    
    % Rsquared
    margR2_allLines = nan(nLines, 1);
    for iLine = 1:nLines
        margR2_allLines(iLine) = getR2(marg_allLines(iLine, :), margPred_allLines(iLine, :));
    end
    
    %% compile
    fitParams_est_reo_ = fxn_organizeParams(0, {}, nTunParams, nBins, nLoc, ind_tunParams, fitParams_est);
    
    marg_allLines_reo = nan(nBins, nLoc2, nFilters);
    margPred_allLines_reo=nan(nBins, nLoc2, nFilters);
    margR2_allLines_reo= nan(nBins, nLoc2);
    fitParams_est_reo = nan(nBins, nLoc2, nTunParams);
    
    for iBin=1:nBins
        for iLoc=1:nLoc2
            ind = iLoc + (iBin-1)*nLoc2;
            marg_allLines_reo(iBin, iLoc, :) = marg_allLines(ind, :);
            margPred_allLines_reo(iBin, iLoc, :) = margPred_allLines(ind, :);
            margR2_allLines_reo(iBin, iLoc) = margR2_allLines(ind);
            
            for iP = 1:nTunParams
                switch ind_tunParams(iP)
                    case 0, ind = 1;
                    case 1, ind = iBin;
                    case 2,ind = iLoc;
                    case 3, ind = ind;
                end
                fitParams_est_reo(iBin, iLoc, iP) = fitParams_est_reo_{iP}(ind); 
            end
            
        end
    end
    
    marg2(:, :, itype, :) = marg_allLines_reo;
    margParams(:, :, itype, :) = fitParams_est_reo;
    margR2(:, :, itype) = margR2_allLines_reo;
    margPred2(:, :, itype, :) = margPred_allLines_reo;
    
end % end of itype


