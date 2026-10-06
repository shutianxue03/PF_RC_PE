function [iPair_unik_nonrand, e3D_nonrand, dataMtx_nonrand] = fxn_binData(dataMatrix, e2D_allT, indLoc, iStart, iEnd)
%FXN_BINDATA Summary of this function goes here
%   Detailed explanation goes here

[ntrials_allT, ~] = size(dataMatrix);
ntrialsAll = ntrials_allT/5; % ntrials per loc

blocks = [iStart, iEnd];

dataMtx_nonSamp = dataMatrix(indLoc,:);
dataMtx_Samp = [];
e2D_allT_nonSamp = e2D_allT(indLoc,:, :);
e2D_allT_Samp = nan(1, size(e2D_allT,2), size(e2D_allT,3));

% Determine bin
iiBin = 1;
for i = 1:ntrialsAll
    if (dataMtx_nonSamp(i,2) >= blocks(1)) && (dataMtx_nonSamp(i,2) <= blocks(2))
        dataMtx_Samp = [dataMtx_Samp; dataMtx_nonSamp(i,:)];
        e2D_allT_Samp(iiBin, :, :) = e2D_allT_nonSamp(i,:,:);
        iiBin=iiBin+1;
    end
end
e3D_nonrand = [];
e3D_nonrand = e2D_allT_Samp; % Sample energy matrix for this location
dataMtx_nonrand = dataMtx_Samp; % Sample dataMatrix for this location
iPair_nonrand = dataMtx_nonrand(:, 8); % Determine double band pass pairs for this location
iPair_unik_nonrand = unique(iPair_nonrand); % range: [1, ntrials_ofThisSubj/2]