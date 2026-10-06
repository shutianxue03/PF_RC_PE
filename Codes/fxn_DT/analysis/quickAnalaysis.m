clc
%% Locations to analyze
locsToAnalyze = [1 2 4 5 3];
% locsToAnalyze = [1 6 5 3];
partialCorrLocs = [2 4 5 3];
itype = itypes;

%% Pearson's Correlations
fprintf('\Pearson''s Correlations\n')
for ifeature = 1:2
    if ifeature == 1, marg_ = margTuningCharORIRatio; ifamily = 1; nparams = 3;
    else, marg_ = margTuningCharSFRatio; ifamily = 2; nparams = 4; end
        for iparam = 1:nparams
            data_x = [];
            data_y = [];
            locInd = [];
            for isubj = isubj2%1:nsubjs
                for iiLoc = partialCorrLocs
                    data_x = [data_x; squeeze(margCstRatio(iiLoc,isubj))];
                    data_y = [data_y; squeeze(marg_(iiLoc, isubj, iparam))];
                    locInd = [locInd; iiLoc];
                end
            end

            [r, p] = corr(data_x, data_y);
           fprintf('%s - partial corr: r=%.2f p=%.3f\n', namesTuningC_all{ifeature}{iparam}, r, p)
%             fprintf('r=%.2f\tp=%.2f\n', r, p)
        end %end of iparam
end %end of ifeature

%% Time Correlations
% fprintf('\Time Correlations\n')
% for ifeature = 1:2
% %     if ifeature == 1, marg_ = margTuningCharORIRatio - mean(margTuningCharORIRatio,2); nparams = 3;
% %     else, marg_ = margTuningCharSFRatio - mean(margTuningCharSFRatio,2); nparams = 4; end
%     if ifeature == 1, marg_ = margTuningCharORIRatio; ifamily = 1; nparams = 3;
%     else, marg_ = margTuningCharSFRatio; ifamily = 2; nparams = 4; end
%         for iparam = 1:nparams
%             data_x = [];
%             data_y = [];
%             locInd = [];
%             for isubj = isubj2%1:nsubjs
%                 for iiLoc = partialCorrLocs
%                     data_x = [data_x; squeeze(timeBiningTbl{isubj,3})];
%                     data_y = [data_y; squeeze(marg_(iiLoc, isubj, iparam))];
%                     locInd = [locInd; iiLoc];
%                 end
%             end
% 
% %             [r, p] = partialcorr([data_x, data_y], locInd);
%             [r, p] = corr(data_x, data_y);
% %             r = r(2,1); p = p(2,1);
%            fprintf('%s - pearson''s corr: r=%.2f p=%.3f\n', namesTuningC_all{ifeature}{iparam}, r, p)
% %             fprintf('r=%.2f\tp=%.2f\n', r, p)
%         end %end of iparam
% end %end of ifeature

%% correlations all Locs
% fprintf('\nCorrelations each location\n')
% marg__ = margCstRatio - mean(margCstRatio,2);
% for ifeature = 1%1:2
%     if ifeature == 1, marg_ = margTuningCharORIRatio - mean(margTuningCharORIRatio,2); nparams = 3;
%     else, marg_ = margTuningCharSFRatio - mean(margTuningCharSFRatio,2); nparams = 4; end
%     fprintf('ifeature: %d\n', ifeature)
%     for iparam = 1:nparams
%         fprintf('%s:\n', namesTuningC_all{ifeature}{iparam})
%         for iloc = locsToAnalyze
%             [r, p] = corr(squeeze(marg__(iloc,:))', squeeze(marg_(iloc, :, iparam))');
% %             fprintf('%s: r=%.2f, p=%.2f\n', namesLocComb{iloc}, r, p)
%             fprintf('r=%.2f p=%.2f\n', r, p)
%             if iloc == 6, fprintf('\n'), end
%         end
%         fprintf('\n')
%     end
% end

%% Metric ANOVAs
clc
fprintf('\nTwo-Way ANOVAs\n')
im = 4;
locAnalysis = [1 8; 6 7; 5 3];
for locind = 1:3
    data = [];
    loc = [];
    bin = [];
    locpair = locAnalysis(locind,:);
    for iloc_ = 1:5
        for ibin = 1:nBins
            data = [data,squeeze(margMetrics(iloc_,:,ibin,im))];
            loc = [loc, ones(1,nsubjs) * iloc_];
            bin = [bin, ones(1,nsubjs) * ibin];
        end
    end %end of iloc_
    fprintf('Loc %i\n%s\n', locind, print_nANOVA({'Loc','Practice'}, data, {loc,bin}));
end

%% Metric ANOVAs HVA/VMA
clc
fprintf('\nTwo-Way ANOVAs\n')
im = 5;
locAnalysis = [6 7; 5 3];
data = [];
loc = [];
bin = [];
for locind = 1:2
    for ibin = 1:nBins
        asym = (squeeze(margMetrics(locAnalysis(locind,1),:,ibin,im))-squeeze(margMetrics(locAnalysis(locind,2),:,ibin,im)))./...
                    (squeeze(margMetrics(locAnalysis(locind,1),:,ibin,im))+squeeze(margMetrics(locAnalysis(locind,2),:,ibin,im)));
        data = [data, asym];
        loc = [loc, ones(1,nsubjs) * locind];
        bin = [bin, ones(1,nsubjs) * ibin];
    end
end
fprintf('Loc %i\n%s\n', locind, print_nANOVA({'Asym', 'Practice'}, data, {loc, bin}));

%% ANOVAs
clc
fprintf('\nTwo-Way ANOVAs\n')
for ifeature = 1:2
    if ifeature == 1, nparams = 3; tuningC = margTuningCharORI;
    else, nparams = 4; tuningC = margTuningCharSF;end
    for iparam = 1:nparams
        data = [];
        loc = [];
        bin = [];
        
        margNorm_all = (tuningC(:, isubj2, [1 nBins], itype, iparam)); %./ (tuningC(1, :, [1], itype, iparam));
        for iloc_ = locsToAnalyze
            for ibin = [1 2]
                data = [data, squeeze(margNorm_all(iloc_,:,ibin))];
                loc = [loc, ones(1,nsubjs) * iloc_];
                bin = [bin, ones(1,nsubjs) * ibin];
            end
        end %end of iloc_
        fprintf('%s\n%s\n', namesTuningC_all{ifeature}{iparam}, print_nANOVA({'Loc', 'practice'}, data, {loc, bin}));
    end %end of iparam
end %end of ifeature

%% Pair-wise comparisons
fprintf('\nPair-wise Comparisons\n')
for ifeature = 1:2
    if ifeature == 1, nparams = 3; tuningC = margTuningCharORI;
    else, nparams = 3; tuningC = margTuningCharSF;end
    for iparam = 1:nparams
        fprintf('%s\n', namesTuningC_all{ifeature}{iparam})
        %fprintf('\n')
        for iloc = locsToAnalyze
            [h,p,~,~] = ttest(squeeze(tuningC(iloc, isubj2, 1, itype, iparam)), squeeze(tuningC(iloc, isubj2, nBins, itype, iparam)), 'Alpha', .05/length(locsToAnalyze), 'tail', 'left');
            if ifeature == 2 && iparam == 1, [h,p,~,~] = ttest(squeeze(tuningC(iloc, :, 1, itype, iparam)), squeeze(tuningC(iloc, :, nBins, itype, iparam)), 'Alpha', .05/length(locsToAnalyze), 'tail', 'both'); end
            if ifeature == 1 && iparam == 2, [h,p,~,~] = ttest(squeeze(tuningC(iloc, :, 1, itype, iparam)), squeeze(tuningC(iloc, :, nBins, itype, iparam)), 'Alpha', .05/length(locsToAnalyze), 'tail', 'both'); end
            if h, sig = '*'; else, sig = ''; end
            
            fprintf('%s%s: p=%.3f\n', sig, namesLocComb{iloc}, p)
            %fprintf('p=%.3f\n', p)
            if iloc == 6, fprintf('\n'), end
        end %end of iloc
        fprintf('\n')
    end %end of iparam
end %end of ifeature

%% Tuning Function 3-way ANOVA
clc
for ifeature = 1:2
    data = [];
    loc = [];
    bin = [];
    channel = [];
    
    switch ifeature
        case 1
            marg = margOri;
        case 2
            marg = margSF;
    end

    for ichannel = 1:length(marg)
        for iloc = 1:nLoc5
            for iBin = [1 3]
                data = [data; marg(iloc, :, iBin, itypes, ichannel)'];
                loc = [loc; iloc * ones(nsubjs,1)];
                bin = [bin; iBin * ones(nsubjs,1)];
                channel = [channel; ichannel * ones(nsubjs,1)];
            end
        end
    end
    fprintf('3-Way Anova\n%s\n', print_nANOVA({'Loc', 'practice', 'channel'}, data, {loc, bin, channel}));
end

%% Tuning Function 2-way ANOVA
clc
for ifeature = 1:2
    data = [];
    loc = [];
    practice = [];
    
    switch ifeature
        case 1
            marg = margOri;
        case 2
            marg = margSF;
    end

    for iloc = 1:nLoc5
        for ichannel = 1:length(marg)
            for iBin = 1:nBins
                data = [data; squeeze(marg(iloc, :, iBin, itypes, ichannel))'];
                loc = [loc; ones(nsubjs,1) * iloc];
                practice = [practice; ones(nsubjs,1) * iBin];
            end
        end
    end
    fprintf('2-Way Anova\n%s\n', print_nANOVA({'Loc', 'practice'}, data, {loc, practice}));
%     fprintf('2-Way Anova\n%s\n', print_nANOVA({'Loc', 'practice'}, [data;data;data], {[loc;loc;loc], [practice;practice;practice]}));
end

%% Posthoc Analsis
clc
for ifeature = 1:2
    for iloc = 1:5
        data = [];
        channel = [];
        practice = [];

        switch ifeature
            case 1
                marg = margOri;
            case 2
                marg = margSF;
        end

        for iBin = [1 nBins]%1:nBins
            for ichannel = 1:length(marg)
                data = [data; squeeze(marg(iloc, :, iBin, itypes, ichannel))'];
                channel = [channel; ichannel*ones(nsubjs,1)];
                practice = [practice; iBin*ones(nsubjs,1)];
            end
        end
%         fprintf('Post-Hoc Anova Location: %s\n%s\n', namesLocComb{iloc}, print_nANOVA({'practice'}, data, {practice}));
        a = marg(iloc,:,nBins,itypes,:);
        a = a(:)';
        b = marg(iloc,:,1,itypes,:);
        b = b(:)';
        [h,p,~,stats] = ttest(a,b,"Alpha",.05/6);
        if h, txt1 = '*'; else, txt1=''; end
        fprintf('Location: %s - t(%i)=%.2f, %sp=%.2f\n', ...
            namesLocComb{iloc},stats.df,stats.tstat,txt1,p)
    end
end