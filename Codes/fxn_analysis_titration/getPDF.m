
% pull out the mean and std of the pdf at each location

subplot_locs = [5,4,2,6,8];

nx = length(x);
xlog = log10(x);
nStairs = size(stairs_inUse, 2);

%% get stair, mode and mean
for n = 1:nStairs
    stair = stairs_inUse{iLoc,n};
    mode_ = stair.mode; mode_log = log(mode_); % to avoid using the fxn name mean or mode
    mean_ = stair.mean; mean_log = log(mean_);
    sd_ = stair.sd;
    if n==1, stair1 = stair; mode1 = mode_; mean1 = mean_; sd1 = sd_;
    else,    stair2 = stair; mode2 = mode_; mean2 = mean_; sd2 = sd_;
    end
end

%% get average (given 2 staircases)
if nStairs == 2
    ssd = 1/sd1^2+1/sd2^2;
    sd_comb = sqrt(1/ssd);
    sd_flat = sd_comb*flattenFactor;
    mean_comb = (mode1/sd1^2 + mode2/sd2^2)/ssd;
    pdf_ave = normpdf(x, mean_comb, sd_comb); pdf_ave = pdf_ave/sum(pdf_ave);
    pdf_ave_flatten = normpdf(x, mean_comb, sd_flat); pdf_ave_flatten = pdf_ave_flatten/sum(pdf_ave_flatten);
else
    mean_comb = mode1;sd_flat=0;
end

%% plot
if plotFlag
    xaxis_start = round(nx/8);
    xaxis_mid = round(nx/2);
    xaxis_end = nx;
    
    subplot(3,3, subplot_locs(iLoc)), hold on
    plot(xlog, stair1.pdf, 'r')
    xline(log10(mode1),  'r-', 'handlevisibility', 'off');
    
    if nStairs == 2
        plot(xlog, stair2.pdf, 'b')
        xline(log10(mode2),  'b', 'handlevisibility', 'off');
        plot(xlog, pdf_ave, 'k', 'lineWidth', 2)        
        xline(log10(mean_comb),  'k-', 'handlevisibility', 'off', 'linewidth', 1.5);
    end
    
    xlim(xlog([xaxis_start, xaxis_end]))
    ylim([0, ymax])
    xticks(xlog([xaxis_start, xaxis_mid, xaxis_end])), xticklabels(round(x([xaxis_start, xaxis_mid, xaxis_end]),2))
    
    if iLoc == 2, xlabel('contrast'), ylabel('probability'), end
    title(sprintf('%.4f (%.4f)', mean_comb, sd_flat))
end

