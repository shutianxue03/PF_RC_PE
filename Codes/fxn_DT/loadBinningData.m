wbinningData = cell(1,nsubjs);
txt = sprintf("fxn_DT/data/PracticeEffect_Binning_Data.xlsx");
opts = detectImportOptions(txt);
opts.VariableNamingRule = 'preserve';
timeBiningTbl = readtable(txt, opts);

%% Read from files
for iisubj = 1:nsubjs
    tD = timeBiningTbl{iisubj,13};
    str = sprintf('%s,', tD{:});
    str = str(2:end-1);
    numArray = sscanf(str, '%i:%i,');

    binRange = nan(length(numArray)/2,2);
    for i = 1:length(numArray)/2
        binRange(i,:) = [numArray((i-1)*2+1), numArray(i*2)];
    end
    binningData(iisubj) = {binRange};
end

%% BinningData structure
% Each cell contains binning ranges for each subj
% rows: bins
% cols: [beginning block #, end block #]