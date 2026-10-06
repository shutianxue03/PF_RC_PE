function [e2D, iPRS, resp, cst, respC] = fxn_getRespC(indRand, iPair_nonrand, iPair_unik_nonrand, e2D_nonrand, iPRS_nonrand, resp_nonrand, cst_nonrand)


% indRand = indRand_unikPair_train; % range: [1, ntrialsPerLoc/2], not repeated
iPair_unik = iPair_unik_nonrand(indRand);
nUNIK = length(iPair_unik);
indTrial = nan(2, nUNIK);
for iu = 1:nUNIK
    indTrial(:, iu) = find(iPair_unik(iu) == iPair_nonrand);
end

e2D = e2D_nonrand(indTrial(:), :, :);
iPRS = [iPRS_nonrand(indTrial(1,:))'; iPRS_nonrand(indTrial(2,:))']; assert(sum(iPRS(1, :) ~= iPRS(2, :)) == 0)
resp = [resp_nonrand(indTrial(1, :))'; resp_nonrand(indTrial(2, :))'];
cst = cst_nonrand(indTrial(:));
% iPair = iPair_nonrand(indTrial(:));

%% get pA
respC = nan(nUNIK, 3); % pA_both/PRS/ABS (must be in this order)
for iu = 1:nUNIK
    respA = resp(1,iu);
    respB = resp(2,iu);
    assert(iPRS(1, iu) == iPRS(2, iu))
    if iPRS(1, iu) == 1, respC(iu,:) = [respA==respB, respA==respB, nan]; % PRS
    else, respC(iu,:) = [respA==respB, nan,respA==respB]; % ABS
    end
end
%
% % if max(itrial_sampled) > length(ipair_perLoc_unik), error('ALERT: the sampled trial ind is beyond the ipair range'), end
%
% % get the index of unique pair of the sampled trials
% npairs_unik_sampled = length(ipair_unik_sampled);
%
% % get the PAIR index of the sampled trials, two passes are together
% % ipair_2passes_sampled = [];
% % for ip = 1:npairs_unik_sampled
% %     ipair_2passes_sampled = [ipair_2passes_sampled; find(ipair_unik_sampled(ip) == ipair_perLoc)];
% % end
%
% % get the TRIAL index of the sampled trials, two passes are together
% itrial_2passes_sampled = [];
% for iip = 1:npairs_unik_sampled
%     itrial_2passes_sampled = [itrial_2passes_sampled; find(ipair_unik_sampled(iip) == dataMatrix(:, 8))];
% end
% % extract data
% iPRS = dataMatrix(itrial_2passes_sampled, 6);
% resp = dataMatrix(itrial_2passes_sampled, 9);
% resp_AB = reshape(resp, 2, npairs_unik_sampled); % so that each column is the itrial of two passes of one pair
% iPRS_AB = reshape(iPRS, 2, npairs_unik_sampled);
% assert(sum(iPRS_AB(1,:) ~= iPRS_AB(2,:)) == 0)
%
% % get pA
% respC = [];
% for ip = 1:npairs_unik_sampled
%     respA = resp_AB(1,ip);
%     respB = resp_AB(2,ip);
%     assert(iPRS_AB(1, ip) == iPRS_AB(2, ip))
%      % pA, pA_PRS, pA_ABS (has to be in this order !!!)
%     if iPRS_AB(1, ip) == 1 % PRS
%         respC = [respC; [respA==respB, respA==respB, nan]];
%     else % ABS
%         respC = [respC; [respA==respB, nan, respA==respB]];
%     end
% end
