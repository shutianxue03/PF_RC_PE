function energy_norm = normEnergy(energy, cst_loc, itgt)
%  energy_norm = normEnergy(energy, cst_loc)
% energy: nAllTrials x nOri x nSF

if nargin == 2
    ntrials = size(energy,1)/2;
    itgt = [ones(ntrials,1); zeros(ntrials,1)];
    assert(length(itgt) == length(cst_loc))
end

%% preprocess based on cst levels (WITH itgt)
energy_norm = nan(size(energy));

% get unique cst
cst_unique = unique(cst_loc);
cst_unique = reshape(cst_unique, 1, length(cst_unique));

% loop
for icst = cst_unique
    indPRS = (cst_loc == icst & itgt);
    indABS = (cst_loc == icst & ~itgt);
    %     assert(sum(indPRS) == sum(indABS))
    
    %energy(indPRS, :, :) = energy(indPRS, :, :) - mean(energy(indPRS, :, :), 1);
    %energy(indABS, :, :) = energy(indABS, :, :) - mean(energy(indABS, :, :), 1);
    energy_norm(indPRS, :,:) = energy(indPRS, :, :) ./ std(energy(indPRS, :, :), [], 1);
    energy_norm(indABS, :,:) = energy(indABS, :, :) ./ std(energy(indABS, :, :), [], 1);
end

%% preprocess NOT based on cst levels
% energy_norm = [];
% for n=1:2
%     if n==1, energy_ = energy(1:ntrials, :, :); else, energy_ = energy(ntrials+1:end, :, :); end
%     e_mean = mean(energy_);
%     e_std = std(energy_, [], 1);
%     energy_norm = cat(1, energy_norm, (energy_ - repmat(e_mean, ntrials, 1)) ./ repmat(e_std, ntrials, 1));
% end

%% AF's code
% contra = unique(trialsMat(:,9)); %contrast
%
% for ii = 1:length(contra)
%     ind1 = targettype==1 & trialsMat(:,9)==contra(ii);
%     ind0 = targettype== 0 & trialsMat(:,9)==contra(ii);
%     %subtract mean
%     dX(:,:,ind1) = dX(:,:,ind1)-mean(dX(:,:,ind1),3); % the 3rd dim is itrial
%     dX(:,:,ind0) = dX(:,:,ind0)-mean(dX(:,:, ind0),3);
%     %divide by std
%     dX(:,:,ind1) = dX(:,:,ind1)./std(dX(:,:,ind1),[],3);
%     dX(:,:,ind0) = dX(:,:,ind0)./std(dX(:,:,ind0),[],3);
% end


