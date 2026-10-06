
addpath(genpath('Data'))

nAve = 15; % number of values to be averaged

[nLoc, nStairs] = size(record.stairs_all);

titles = {'Center','Left','UVM','Right','LVM'};
subplot_locs = [5,4,2,6,8]; % center: 5, left: 4, right: 6, UVM: 2, LVM: 8
colors = {'r','b'};
thresh = nan(nLoc,nStairs);

figure('Position',[0 500 800 800])

for iLoc = 1:nLoc
    i_subplot_locs = subplot_locs(iLoc);
    subplot(3,3,i_subplot_locs), hold on
    
    %  collect all resp and stim levels
    stim = [];
    acc = [];
    for istair = 1:nStairs
        stim = [stim, record.stairs_all{iLoc,istair}.x];
        acc = [acc, record.stairs_all{iLoc,istair}.response];
    end
    
    [stim_sort, stim_ind]  = sort(stim);
    acc_sort = acc(stim_ind);
    
    % regroup data (to take average)
    nstim = length(stim_sort);
    nrows = floor(nstim/nAve)+1;
    nstim_full = nrows * nAve;
    ntail = nstim_full - nstim;
    
    stim_sort_full = [stim_sort, ones(1,ntail) * stim_sort(end)];
    acc_sort_full = [acc_sort, ones(1,ntail) * acc_sort(end)];
    
    % reshape
    stim_reshape = reshape(stim_sort_full, nAve, nrows);
    acc_reshape = reshape(acc_sort_full, nAve, nrows);
    
    % take average
    stim_reshape_ave = mean(stim_reshape);
    acc_reshape_ave = mean(acc_reshape);
    
    % fit PMF
    [param, PMF] = fitPMF(stim_reshape_ave, acc_reshape_ave);
    
    
    % plot
    plot(stim_reshape_ave, acc_reshape_ave,'ko')
    plot(stim_reshape_ave, PMF,'r');
    title(sprintf('%s thresh = %.2f', titles{iLoc}, param(1)))
    ylim([.5 1])
%     xlim([0 1])
    xlabel('contrast')
    ylabel('accuracy2')
    
end

% thresh_ave = mean(thresh,2);