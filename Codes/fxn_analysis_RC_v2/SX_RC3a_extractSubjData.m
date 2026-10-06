

% this function organize important data
% outputs:
%       - data_eachSubj: nAllTrials x nLoc x 4 measures (itgtPrs, answer, correctness, RTs), location in order
%       - patch_eachSubj: nAllTrials x nLoc cell, each cell contains a patch; location in order
%       - data_both: rows reordered so that prs-trials are before abs-trials
%       - patch_both: rows reordered so that prs-trials are before abs-trials % itgtPrs, answer, correctness, RT

%% load params
nTrialsPerBlock = 100;
nSess = nblocks/nLoc5; % per loc
nAllTrials = nSess * nTrialsPerBlock; % per loc
ntrials = nAllTrials/2; % per loc
noise.ratio_base = .5;
limit0to1 = @(x) min(max(x,0),1);

ipair_all = 1:nTrialsPerBlock/2; % need to fix if not DOUBLE-pass!!
npairs = length(ipair_all);

%% empty containers
patch_tgt_perBlk = cell(nblocks, nTrialsPerBlock); % presented patches
patchSD_perBlk = nan(nblocks, nTrialsPerBlock);
noise_tgt_perBlk = patch_tgt_perBlk; % unmodified noise patches
noiseMasked_tgt_perBlk = patch_tgt_perBlk; % modified noise patches

cst_perBlk = nan(nblocks, 1);
RT_aveT_perBlk = cst_perBlk;
dprime_perBlk = cst_perBlk;
criterion_perBlk = cst_perBlk;
pC3_perBlk = nan(ntypes, nblocks); % row 1: Hit rate; row 2: FA rate; row 3: pC
pA3_perBlk = nan(ntypes, nblocks); % row 1: PRS trials; row 2: ABS; row 3: All
respC_perBlk = nan(nblocks, ntypes, npairs);

%% LOOP each block (blk)
iblk_cut = ib_start:ib_end;
parfor iblk_rec = 1:nblocks
    iblk = iblk_cut(iblk_rec);
    [iCuedLoc, thresh_exp, correctness, iPRS, ipair, resp, run_allTrials, RT] = extractRecord(dirExpFile(iblk)); % created in the paren script
    iLoc_blk = iCuedLoc(iblk,1);       % the iLoc of this block
    
    %%%%%%%%%
    %     contrast     %
    %%%%%%%%%
    cst_perBlk(iblk_rec) = thresh_exp(iLoc_blk);
    
    %%%%%%%%%
    %   median RT  %
    %%%%%%%%%
    RT_aveT_perBlk(iblk_rec) = nanmedian(RT(iblk, :));
    
    %%%%%%%%%%%%%%
    %   dprime/criterion/pC3  %
    %%%%%%%%%%%%%%
    iPRS_blk = iPRS(iblk, :); assert(mean(iPRS_blk) == .5) % whether the Gabor is present
    resp_blk = resp(iblk, :);
    pHit = mean(resp_blk & iPRS_blk)*2;
    pFA = mean(resp_blk & (1-iPRS_blk))*2;
    pC = (pHit+1-pFA)/2;
    pC3_perBlk(:, iblk_rec) = [pC, pHit, pFA];    
    
    [d,c] = SX_sim06_SDT(pHit, pFA);
    dprime_perBlk(iblk_rec) = d;
    criterion_perBlk(iblk_rec) = c;

    %%%%%%%
    %      pA     %
    %%%%%%%
    ipair_iblk = ipair(iblk, :);
    respC = nan(3, npairs);
    for ipair = ipair_all % repInd_all is the number of pairs
        itrial_pair = ipair_iblk == ipair; % the pair of repeated trial
        resp_pair = resp_blk(itrial_pair); % the resp of two responses
        same_resp = resp_pair(1) == resp_pair(2);
        iPrs = iPRS_blk(itrial_pair); % whether this pair of trials is PRS/ABS
        assert(iPrs(1) == iPrs(2))
        % (1) both
        respC(1, ipair == ipair_all) = same_resp;
        if  iPrs(1) == 1, respC(2, ipair == ipair_all) = same_resp; % (2) PRS
        else,               respC(3, ipair == ipair_all) = same_resp; % (3) ABS
        end
    end
    respC_perBlk(iblk_rec, :, :) = respC; % collect the index of rep for all T
    pA3_perBlk(:, iblk_rec) = nanmean(respC, 2);
    
    %%%%%%%%%%%%
    %   stim patch/noise   %
    %%%%%%%%%%%%
    if flagGetPatch
        for itrial = 1:nTrialsPerBlock
            % patch
            pp = run_allTrials{itrial}.stimPatch_all{iLoc_blk};
            patchSD_perBlk(iblk_rec, itrial) = std(pp(:));
            patch_tgt_perBlk{iblk_rec, itrial} = pp;
            
            % noise
            nn = run_allTrials{itrial}.noisePatch_all{iLoc_blk};
            noise_tgt_perBlk{iblk_rec, itrial} = nn;

        end % end of itrial
    end % if flagGetPatch
    
    if ~mod(iblk,10), fprintf('='), end
    
end % end of ib

fprintf('Loop finished.\n')

%%
[iCuedLoc_allT_, thresh_exp, correctness, iPRS, ipair, resp, run_allTrials, RT] = extractRecord(dirExpFile(ib_end));
iCuedLoc_allT_ = repmat(iCuedLoc_allT_(:, 1), [1, nTrialsPerBlock]); % make sure that the iCued in the following columns are correct

%% organize all measurements and metrics into the form nblocks x nTrialsPerBlock
itrial_allT = reshape(1:nblocks*nTrialsPerBlock, [nTrialsPerBlock, nblocks])'; % (1)
iSess_allT = cell(nSess, 1); for iSess = 1:nSess, iSess_allT{iSess} = ones(nLoc5, nTrialsPerBlock)*iSess; end
iSess_allT = cell2mat(iSess_allT); % (2)
iBlk_allT = repmat(1:nblocks, nTrialsPerBlock, 1)'; % (3)
itrial_perBlk_allT = repmat(1:nTrialsPerBlock, [nblocks, 1]); % (4)
iCuedLoc_allT = iCuedLoc_allT_(ib_start:ib_end, :); % (5)
iPRS_allT = iPRS(ib_start:ib_end, :); % (6)
iPass_allT = ones(nblocks, nTrialsPerBlock); % (7)
for ib = ib_start:ib_end
    for ip = 1:npairs
        iPass = find(ipair(ib, :) == ip);
        iPass_allT(ib-ib_start+1, iPass(2)) = 2;
    end
end
iPair_allT = ipair(ib_start:ib_end, :) + repmat((npairs * (0:nblocks-1))', [1, nTrialsPerBlock]); % (8)
resp_allT = resp(ib_start:ib_end, :); % (9)
RT_allT = RT(ib_start:ib_end, :); % (10)
cst_allT = repmat(cst_perBlk, 1, nTrialsPerBlock); % (11)

%% compile all metrics and measurements
fxn_reorder = @(data) reshape(data', nAllTrials * nLoc5, 1);
dataMatrix = [fxn_reorder(itrial_allT), ...
    fxn_reorder(iSess_allT), fxn_reorder(iBlk_allT), fxn_reorder(itrial_perBlk_allT), ...
    fxn_reorder(iCuedLoc_allT), fxn_reorder(iPRS_allT), ...
    fxn_reorder(iPass_allT), fxn_reorder(iPair_allT), fxn_reorder(resp_allT), fxn_reorder(RT_allT), fxn_reorder(cst_allT)];

%% save
clear repInd_allT answer_allT correctness_allT tgtPrs_allT
save(nameBehavMeas, 'dataMatrix', '*_allT') % patch/noise_all T are not created yet, so breath...

if flagGetPatch
    patch_allT = fxn_reorder(patch_tgt_perBlk);
    noise_allT = fxn_reorder(noise_tgt_perBlk);
    fprintf(' Saving patches...')
    save(nameTgtPatch, 'patch_allT') 
    save(nameNoisePatch, 'noise_allT')
    fprintf('DONE\n')
end

%%
function [iCuedLoc, thresh_exp, correctness, tgtPrs, repInd, answer, run_allTrials, RT] = extractRecord(dataFileDir_ib)
load(dataFileDir_ib.name, 'record'); % only load the record
iCuedLoc = record.iCuedLoc;
thresh_exp = record.thresh_exp;
correctness = record.correctness;
tgtPrs = record.tgtPrs;
repInd = record.repInd;
answer  = record.answer;
run_allTrials = record.run_allTrials;
RT = record.RT;
end

