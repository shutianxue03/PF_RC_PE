

% run_allTrials: col cell [ntrialsPerBlock x 1]
%     - each cell contains a struct 'run', each contains stimPatch,
%     noisePatch, iCuedLoc, contrast, iTratget, phase_tgt
design.nrep = 2;
ntrialsPerRep = design.nTrialsPerBlock/design.nrep;
run = [];

run_nonrand = cell(ntrialsPerRep, 1); 
run.iCuedLoc = design.loc_list(idx_block);

for n = [1,0] % 1 = present; 0 = absent
    run.tgtPrs = n;
    if mod(ntrialsPerRep,2) ~= 0, error('ntrials is not multiple of 2!! '), end
    for ii = 1:ntrialsPerRep/2
        ind = ii+(1-n)*ntrialsPerRep/2;
        run_nonrand{ind} = exp_drawStim(exp_mode, params, run, record);
        run_nonrand{ind}.repInd = ind;
    end
end

% randomize sequence, create and combine two passes
ind_passA = randperm(ntrialsPerRep); % number of trials per pass (50 for double pass and 100 trials per block)
run_passA = run_nonrand(ind_passA); % randomize the sequence of the 1st rep
ind_passB = ind_passA(randperm(ntrialsPerRep));
run_passB = run_passA(ind_passB); % copy the first rep and randomize the sequence
run_allTrials = [run_passA; run_passB];


