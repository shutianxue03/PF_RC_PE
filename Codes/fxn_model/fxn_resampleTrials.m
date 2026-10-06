
nLoc2 = length(iLoc_all);

e2D_train = nan(ntrain * nLoc2, nORI, nSF);
iPRS_train = nan(ntrain * nLoc2, 1);
resp_train = iPRS_train;
cst_train = iPRS_train;
respC_train = nan(ntrain/2 * nLoc2, 3);

e2D_test = nan(ntest * nLoc2, nORI, nSF);
iPRS_test = nan(ntest * nLoc2, 1);
resp_test = iPRS_test;
cst_test = iPRS_test;
respC_test = nan(ntest/2 * nLoc2, 3);

for iiLoc = 1:nLoc2
    iLoc_ = iLoc_all(iiLoc);
    indLoc = dataMatrix(:, 5) == iLoc_;
    ndataPerLoc = sum(indLoc);
    
    e2D_nonrand = e2D_allT(indLoc, :, :);
    iPRS_nonrand = dataMatrix(indLoc, 6);
    resp_nonrand = dataMatrix(indLoc, 9);
    cst_nonrand = dataMatrix(indLoc, 11);
    cst_unik_nonrand = unique(cst_nonrand);
    iPass_nonrand = dataMatrix(indLoc, 11);
    iPair_nonrand = dataMatrix(indLoc, 8);
    iPair_unik_nonrand = unique(iPair_nonrand); % range: [1, ntrials_ofThisSubj/2]
    
    % get the itrial of selected data (for each loc) according to the unik pair
    rng('shuffle')
    indUnikPair_rand = randperm(ndataPerLclc
    oc/2, ndataPerLoc/2); % range: [1, ntrialsPerLoc/2]
    indUnikPair_rand_train_ = indUnikPair_rand(1:ntrain/2); % range: [1, ntrialsPerLoc/2]
    indUnikPair_rand_test_ = indUnikPair_rand(ntrain/2+1:end); assert(length(indUnikPair_rand_test_) == ntest/2) % range: [1, ntrialsPerLoc/2]
    
    % TRAIN
    [e2D_train_, iPRS_train_, resp_train_, cst_train_, respC_train_] = fxn_getRespC(indUnikPair_rand_train_, iPair_nonrand, iPair_unik_nonrand, e2D_nonrand, iPRS_nonrand, resp_nonrand, cst_nonrand);
    % TEST
    [e2D_test_, iPRS_test_, resp_test_, cst_test_, respC_test_] = fxn_getRespC(indUnikPair_rand_test_, iPair_nonrand, iPair_unik_nonrand, e2D_nonrand, iPRS_nonrand, resp_nonrand, cst_nonrand);
    
    itrain_start = (iiLoc-1)*ntrain +1;
    itrain_end = iiLoc*ntrain;
    itrain_start2 = (iiLoc-1)*ntrain/2 +1;
    itrain_end2 = iiLoc*ntrain/2;
    e2D_train(itrain_start: itrain_end, :, :) = e2D_train_; % ntrain
    iPRS_train(itrain_start: itrain_end) = iPRS_train_(:);
    resp_train(itrain_start: itrain_end) = resp_train_(:);
    cst_train(itrain_start: itrain_end) = cst_train_;
    respC_train(itrain_start2: itrain_end2, :) = respC_train_;
    
    itest_start = (iiLoc-1)*ntest +1;
    itest_end = iiLoc*ntest;
    itest_start2 = (iiLoc-1)*ntest/2 +1;
    itest_end2 = iiLoc*ntest/2;
    e2D_test(itest_start: itest_end, :, :) = e2D_test_; % ntest
    iPRS_test(itest_start: itest_end) = iPRS_test_(:);
    resp_test(itest_start: itest_end) = resp_test_(:);
    cst_test(itest_start: itest_end) = cst_test_;
    respC_test(itest_start2: itest_end2, :) = respC_test_;
end % iLoc_
