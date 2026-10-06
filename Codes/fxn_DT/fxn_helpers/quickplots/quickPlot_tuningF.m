function quickPlot_tuningF(marg_, iLoc, iBin,markers_allSubj)
    marg_ = squeeze(marg_(iLoc,:,iBin,3,:));
    figure, hold on
    for isubj = 1:11
        plot(marg_(isubj,:), sprintf('-%sk',markers_allSubj{isubj}))
    end
end