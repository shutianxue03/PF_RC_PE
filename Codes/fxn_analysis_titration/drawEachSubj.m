% function dataEachSubj = computeStair_nan

%%
% create 4 plots:
% 1. PDF
% 2. staircase of all sessions (joint)
% 3. staircase of all sessions (separate)
% 4. SDT data (accuracy, dprime, criterion, RT, SAT)

%% extract params
params = record.params;
stim = params.stim;
noise = params.noise;
stairParams = params.stairParams;
design = params.design;
nTrials = design.nTrialsPerStairPerLoc;

nblocks = sum(~isnan(record.correctness (:,1)));

colors = [1,0,0;0,0,1]; % 1st staircase is red, 2nd is blue
polar_ang = [0:90:270,0]/180*pi; % 0=RHM, 90=UVM, 180=LHM, 270=LVM

[nLoc, nStairs] = size(record.stairs_all);
minCST = stairParams.initThresh(2);
maxCST = stairParams.initThresh(1);

%% preprocessing
correctness = record.correctness(1:nblocks, :);
iCuedLoc = record.iCuedLoc(1:nblocks, 1);
RT = record.RT(1:nblocks, :);
tgtPrs = record.tgtPrs(1:nblocks, :);
nSess = size(correctness, 1) / 5; % nnumber of sessions finished, usually 2
nAllTrials = nSess*nTrials*nStairs;
displayMode = 2; % display thresholds in line form

extractThresh % could not be muted!!


if exist('thresh_final_allSubj', 'var')
    thresh_final_log = log10(thresh_final_allSubj(isubj, :));
else, 
    thresh_final_log = thresh_log_mean;
end

%% extract performance
ntrialsPerLoc_allSessions = nan(1,nSess); % # of trials completed in each session

% figure out the number of trials in one session
for iSess = 1:nSess
    ntrialsPerLoc_allSessions(iSess) = sum(~isnan(correctness((iSess-1)*5+1, :)));
end

ntrialsPerLoc = sum(ntrialsPerLoc_allSessions); % number of trials per loc for BOTH staircases
ntrialsSelected = round(ntrialsPerLoc* (1-ratioSelected)) + 1;
ntrialsSelected_perStair = round(ntrialsPerLoc/2* (1-ratioSelected));
ind_trials = ntrialsSelected : ntrialsPerLoc;
[dprime_theo, ~, ~, ~] = PAL_SDT_1AFC_PHFtoDP([stairParams.threshPerformance, 1-stairParams.threshPerformance]);
% dprime_theo = norminv(stairParams.threshPerformance) - norminv(1-stairParams.threshPerformance) ;

acc_prs = nan(1,nLoc);
acc_abs = nan(1,nLoc);
acc_all = nan(1,nLoc);
RT_prs = nan(1,nLoc);
RT_abs = nan(1,nLoc);
RT_all = nan(1,nLoc);
pHit = nan(1,nLoc);
pFA = nan(1,nLoc);
dprime = nan(1,nLoc);
criterion = nan(1,nLoc);

corr_allLoc = nan(nTrials * nSess *2, nLoc);
RT_allLoc = corr_allLoc;

for iiLoc = 1:nLoc
    iLoc = iCuedLoc(iiLoc);
    
    corr_loc = []; RT_loc = []; tgtPrs_loc = [];
    for iSess = 1:nSess
        ind = 5 * (iSess-1) + iLoc;
        corr_loc = [corr_loc, correctness(ind, 1:ntrialsPerLoc_allSessions(iSess))];
        RT_loc = [RT_loc, RT(ind, 1:ntrialsPerLoc_allSessions(iSess))];
        tgtPrs_loc = [tgtPrs_loc, tgtPrs(ind, 1:ntrialsPerLoc_allSessions(iSess))];
    end
    corr_allLoc(:, iLoc) = corr_loc;
    RT_allLoc(:, iLoc) = RT_loc;
    corr_loc_s = corr_loc(ind_trials); % selected trials to omit the first several trials, according to ratioSelected
    tgtPrs_loc_s = tgtPrs_loc(ind_trials);
    
    acc_prs(iLoc) = mean(corr_loc_s(boolean(tgtPrs_loc_s)));
    acc_abs(iLoc) = mean(corr_loc_s(boolean(1-tgtPrs_loc_s)));
    acc_all(iLoc) = mean(corr_loc_s);
    
    RT_prs(iLoc) = median(RT_loc(tgtPrs_loc == 1));
    RT_abs(iLoc) = median(RT_loc(tgtPrs_loc == 0));
    RT_all(iLoc) = median(RT_loc);
    
    [dP, C, ~, pC] = PAL_SDT_1AFC_PHFtoDP([acc_prs(iLoc), 1-acc_abs(iLoc)]);
    dprime(iLoc) = dP; %zHit - zFA;
    criterion(iLoc) = C; %-(zHit + zFA)/2;
    
end

%% PDF
plotFlag = 0; 
% if draw_mode, figure('Position',[0 200 800 800]), end

stairs_inUse = record.stairs_all;
x = stairs_inUse{1, 1}.priorAlphaRange; % assuming that the alpha space is set the same for all staircases and all Loc
nx = length(x);

lastPosterior_allLoc = nan(nLoc, nx);
thresh_SEM = zeros(1,5);
mean_allLoc = nan(nLoc, 1);
std_allLoc = nan(nLoc, 1);
flattenFactor = 1;

% plotFlag = draw_mode;
for iLoc = 1:nLoc
    ymax = .015;
    getPDF
    lastPosterior_allLoc(iLoc,:) = pdf_ave_flatten;
    mean_allLoc(iLoc) = mean_comb;
    std_allLoc(iLoc) = sd_flat;
end

if plotFlag
    set(findall(gcf, '-property', 'FontSize'), 'FontSize',15)
    sgtitle(sprintf('%s - titration (%d sessions)', subjName, nSess), 'fontsize', 20);
end
clear mean


%% plot
suptitle1 = sprintf('S%d %s (%d sessions)', isubj, subjName, nSess);
suptitle2 = sprintf('S%d %s (noise cst = %.2f, tgt SF = %d)', isubj, subjName, noise.noiseCST, stim.gaborSF);

if draw_mode
    % draw staircase by session
    plotBySess = 1; drawStairs
    
    % draw staircase NOT by session
    plotBySess = 0; drawStairs
    
    % draw SDT
    drawAlldata
    
    %  test speed-accuracy tradeoff
    subplot(3,5,15), hold on
%     RCplot_SAT(isubj, RT_allLoc, corr_allLoc, locNames)
    set(findall(gcf, '-property', 'FontSize'), 'FontSize',12)
    sgtitle(suptitle2, 'FontSize',25);
end


