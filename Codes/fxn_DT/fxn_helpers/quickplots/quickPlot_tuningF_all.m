marg_ = margPredOri;
marg2_ = margOri;
bounds = oriTuningFBounds;
for isubj = 1:11
    figure
    for iLoc = 1:5
        for iBin = 1:nBins
            subplot(5,nBins, (iLoc-1)*nBins + iBin), hold on
            plot(squeeze(marg_(iLoc,isubj,iBin,3,:)), '-k')
            plot(squeeze(marg2_(iLoc,isubj,iBin,3,:)), sprintf('%sk',markers_allSubj{isubj}))
            ylim(bounds)
        end
    end
end