
% This function extract the threshold from staircase data

if ~exist('displayMode', 'var'), displayMode = 1;end

params = record.params;
design = params.design;
nLoc = design.nCuedLoc;
nblocks = sum(~isnan(record.correctness (:,1)));
correctness = record.correctness(1:nblocks, 1:design.nTrialsPerBlock);
nSess = size(correctness, 1) / nLoc;
if nSess < 1, nSess = 1; end
nStairs = design.nStairs;
nTrials =  design.nTrialsPerStairPerLoc;

% disp('loc tested in the last exp:')
% record.iCuedLoc((nSess-1)*nLoc+1 : nblocks, 1)
% 
% if isfloat(size(correctness, 1) / nLoc), missedLoc = input('missed locations (in a vector): '); end

y = nan(5, nSess, nStairs, nTrials); % 5 is hardcoded

for iLoc = design.loc_list
    for iSess = 1:nSess
%         if (iSess == nSess) && (sum(iLoc == missedLoc)),  break,  end
        for istair = 1:nStairs
            if isempty(record.stairs_all{iLoc,istair}.x), continue, end
            y(iLoc, iSess, istair, 1:nTrials) = record.stairs_all{iLoc,istair}.x(nTrials*(iSess-1)+1 : nTrials*iSess);
        end
    end
end

y_log = log10(y);
if nSess<2, iSess_start=1;else, iSess_start = 2;end
endpoints_log = squeeze(y_log(:,iSess_start:end,:,end)); % 5 loc x nSess x nStair
if ismatrix(endpoints_log), thresh_log = endpoints_log;
else, thresh_log = squeeze(nanmean(endpoints_log, nStairs)); % averaged over all endpoints, 5 loc x nStair
end

if (exp_mode == 0) && (nSess > 1)
    thresh_SEM = nanstd(reshape(endpoints_log, [nLoc, nStairs*(nSess-1)]), [], 2);
else, thresh_SEM = zeros(1,5);
end
thresh_log_mean = nanmean(thresh_log,2);

thresh_exp = 10.^(thresh_log_mean);

switch displayMode
    case 1, fprintf('             %.4f\n%.4f %.4f %.4f \n             %.4f\n\n', thresh_exp([3,2,1,4,5]))
    case 2,fprintf(' [ %.4f, %.4f, %.4f, %.4f, %.4f]\n', thresh_exp)
end
