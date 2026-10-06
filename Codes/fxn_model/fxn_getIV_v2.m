
function [IV_PRS, IV_ABS, maxPRS_allT, maxABS_allT] = fxn_getIV_v2(iModelA, e2D, iPRS, convolveType, IVType, template_true, ORI_bound)


%% extract energy
e_perT_PRS = squeeze(e2D(boolean(iPRS), :, :));
e_perT_ABS = squeeze(e2D(boolean(1-iPRS), :, :));

%% get IV and max
[maxPRS_allT, IV_PRS] = fxn_IV_perPRSABS(e_perT_PRS, iModelA, convolveType, IVType, template_true, ORI_bound);
[maxABS_allT, IV_ABS] = fxn_IV_perPRSABS(e_perT_ABS, iModelA, convolveType, IVType, template_true, ORI_bound);

%%
function [max_allT, IV] = fxn_IV_perPRSABS(e_perT, iModelA, convolveType, IVType, template_true, ORI_bound, SS)
[ntrials, nORI, nSF] = size(e_perT);
IV = nan(ntrials, 1);
max_allT = nan(ntrials, 2);

% randomize pixels of template on each trial
% if iModelA == 2
%     rng('shuffle')
%     indRand = randperm(nORI*nSF);
%     template_true_ = template_true(:);
%     template_ = template_true_(indRand);
%     template = reshape(template_, nORI, nSF);
% else, template = template_true;
% end

parfor itrial = 1:ntrials
    if iModelA == 2 % randmize template on each trial
        temp_true_slice = squeeze(template_true(itrial, :, :));
        rng('shuffle')
        indRand = randperm(nORI*nSF);
        temp_true_slice_ = temp_true_slice(:);
        template = temp_true_slice_(indRand);
    else
        template = template_true;
    end
    
    e = squeeze(e_perT(itrial, :, :));
    
    switch convolveType
        case 1, tempCovE = template.*e; % dot multiply
        case 2 , tempCovE = conv2(template, e, 'same'); % convolve
    end
    
    % get the channel at which max value is found
    plotFlag = 0;
    [max_, maxORI, maxSF_log] = getIndMax(tempCovE, ORI_bound, plotFlag);
    max_allT(itrial, :) = [maxORI, maxSF_log];
    
    %     quickPlot_tempCovE, waitforbuttonpress
    
    % decide the format of IV
    switch IVType
        case 1, IV(itrial) = sum(tempCovE(:));
        case 2, IV(itrial) = max_;
        case 3, IV(itrial) = max_/(sum(tempCovE(:))); if sum(tempCovE(:)) == 0, error('ALERT: The suppressive drive is 0.'); end% SS stands for the eatimted semi-saturation factor
    end
end % end of itrial