clc
%% Locations to analyze
locsToAnalyze = [1 2 4 5 3];
% locsToAnalyze = [1 6 5 3];
partialCorrLocs = [1 2 4 5 3];
itype = itypes;

%% Pair-wise comparisons
clc
fprintf('\nPair-wise Comparisons\n')
for ifeature = 2
    if ifeature == 1, nparams = 3; tuningC = margTuningCharORI;
    else, nparams = 3; tuningC = margTuningCharSF;end
    for iparam = 1%1:nparams
        fprintf('%s\n', namesTuningC_all{ifeature}{iparam})
        %fprintf('\n')
        for iloc = [1 2 4 5 3]
            [h,p,~,stats] = ttest(squeeze(tuningC(iloc, :, 1, itype, iparam)), squeeze(tuningC(iloc, :, nBins, itype, iparam)), 'Alpha', .05/length(locsToAnalyze), 'tail', 'left');
            if ifeature == 2 && iparam == 1, [h,p,~,~] = ttest(squeeze(tuningC(iloc, :, 1, itype, iparam)), squeeze(tuningC(iloc, :, nBins, itype, iparam)), 'Alpha', .05/length(locsToAnalyze), 'tail', 'both'); end
            if ifeature == 1 && iparam == 2, [h,p,~,~] = ttest(squeeze(tuningC(iloc, :, 1, itype, iparam)), squeeze(tuningC(iloc, :, nBins, itype, iparam)), 'Alpha', .05/length(locsToAnalyze), 'tail', 'both'); end
            if h, sig = '*'; else, sig = ''; end
            
            fprintf('%s%s: t(%i)=%.3f, p=%.3f\n', sig, namesLocComb{iloc}, stats.df, stats.tstat, p)
            %fprintf('p=%.3f\n', p)
            if iloc == 6, fprintf('\n'), end
        end %end of iloc
        fprintf('\n')
    end %end of iparam
end %end of ifeature

%% Pair-wise comparisons
clc
fprintf('\nTwo-way ANOVA\n')
for ifeature = 1:2
    if ifeature == 1, nparams = 3; tuningC = margTuningCharORI;
    else, nparams = 4; tuningC = margTuningCharSF;end
    for iparam = 1:nparams
        fprintf('%s\n', namesTuningC_all{ifeature}{iparam})
		data = [];
		loc = [];
		bin = [];
        %fprintf('\n')
        for iloc = locsToAnalyze%[2 4]
            for ibin = [1 3]%1:nBins
				data = [data, squeeze(tuningC(iloc, :, ibin, itype, iparam))];
				loc = [loc, ones(1,nsubjs) * iloc];
				bin = [bin, ones(1,nsubjs) * ibin];
            end
        end %end of iloc
		fprintf(print_nANOVA({'Loc', 'Practice'}, data, {loc, bin}))
        fprintf('\n')
    end %end of iparam
end %end of ifeature