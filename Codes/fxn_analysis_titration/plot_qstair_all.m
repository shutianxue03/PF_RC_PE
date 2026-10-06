
subjName = 'ZZ';
folderName = ['Data/', subjName, '/'];
dataFileDir = dir([folderName, subjName, '_qstair*']); % find out all possible file;
load([subjName, '_ThreshAccRecord'])
plotLoc = [5,4,2,6,8];

for n = 1:length(dataFileDir)
    load(dataFileDir(n).name)
    loc_list = params.design.loc_list;
    figure('Position', [0 0 600 500])
    for iLoc = loc_list
        subplot(3,3,plotLoc(iLoc)), hold on
        x = record.stairs_all{iLoc}.x(2:end);
        plot([1, length(x)], [threshT_allSess(1,iLoc), threshT_allSess(1,iLoc)], 'r')
        plot([1, length(x)], [threshT_allSess(end-1,iLoc), threshT_allSess(end-1,iLoc)], 'r--')
        plot(x)
        plot(length(x), x(end), '*')
        title(sprintf('%.4f, %.d%%', threshT_allSess(n+1,iLoc), round(accT_allSess(n+1, iLoc)*100)))
%         if plotLoc(iLoc) == 5, legend('titration', 'last thresh'),end
    end
    set(findall(gcf, '-property', 'FontSize'), 'FontSize',13)
    sgtitle(['qstair ', num2str(n)])
end
set(findall(gcf, '-property', 'FontSize'), 'FontSize',13)