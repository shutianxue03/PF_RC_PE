
xlim_allM = [.7, 1.6; -1, 1; .5, 1; .5, 1; .1, .5; .5, .9; .5, .9;.5, .9];
colors2 = {'r', 'b'};
figure('Position', [0 0 1000 600])

for im = 1:nmetrics
    subplot(2,4,im), hold on
    for iiLoc = 1:nLocComb
        errorbar(data_med_allSubj(:, im, iiLoc), pred_med_allSubj(:, im, iiLoc), ...
            pred_neg_allSubj(:, im, iiLoc), pred_pos_allSubj(:, im, iiLoc), ...
            data_neg_allSubj(:, im, iiLoc), data_pos_allSubj(:, im, iiLoc), [colors2{iiLoc}, '.'], 'CapSize', 0)
        for isubj = 1:nsubj
            plot(data_med_allSubj(isubj, im, iiLoc), pred_med_allSubj(isubj, im, iiLoc), [colors2{iiLoc}, markers_allSubj{isubj}])
        end
    end
    plot([xlim_allM(im, 1), xlim_allM(im, 2)], [xlim_allM(im, 1), xlim_allM(im, 2)], 'k-')
    xlim(xlim_allM(im, :))
    ylim(xlim_allM(im, :))
    axis square
    title(namesMetrics{im})
end % im

