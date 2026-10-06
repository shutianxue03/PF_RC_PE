txt = sprintf('data/%s/Perceptual_Learning_Binning_Data.xlsx', folderName);
opts = detectImportOptions(txt);
opts.VariableNamingRule = 'preserve';
timeBiningTbl = readtable(txt, opts);
close all

%% Days to complete experiment
figure('Position', [0 0 1600 800]), hold on, box off
bar(timeBiningTbl{1:11,3})
xlabel("Observer")
xticks(1:11)
ylabel("Total days")
title("Duration of Experiment from session 1 to end")
yline(median(timeBiningTbl{1:11,3}), 'LineWidth', 1.5)
set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)
set(gca, 'LineWidth', 2)

fileName = sprintf("figs/Perceptual Learning RC/TimeToComplete.jpg");
exportgraphics(gcf, fileName, 'Resolution', 300);

%% Average days between/within bins
figure('Position', get(0, 'Screensize'))
subplot(1,2,1), hold on
bar(timeBiningTbl{1:11,4})
xlabel("Observer")
xticks(1:11)
xticklabels(subjList)
ylabel("Number of days")
title("Average Number of Days between Bins")
ylim([0 35])
yline(median(timeBiningTbl{1:11,4}))

subplot(1,2,2), hold on
bar(timeBiningTbl{1:11,10})
xlabel("Observer")
xticks(1:11)
xticklabels(subjList)
ylabel("Number of days")
title("Average Number of Days within a Bin")
ylim([0 35])
yline(median(timeBiningTbl{1:11,10}))
set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)

fileName = sprintf("figs/Perceptual Learning RC/Time_Bin_Data.jpg");
saveas(gcf, fileName);

%% Binning Data
figure('Position', get(0, 'Screensize'))
subplot(1,2,1), hold on
bar(timeBiningTbl{1:11,7})
xlabel("Observer")
xticks(1:11)
xticklabels(subjList)
ylabel("Number of bins")
title("Number of Bins per Observer")
ylim([5 9])

subplot(1,2,2), hold on
bar(timeBiningTbl{1:11,8})
xlabel("Observer")
xticks(1:11)
xticklabels(subjList)
ylabel("Average number of trials per location")
title("Average Number of Trials per Location")
ylim([400 800])
yline(median(timeBiningTbl{1:11,8}))
set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)

fileName = sprintf("figs/Perceptual Learning RC/Binning_Data.jpg");
saveas(gcf, fileName);

%% Time within each bin for each observer

figure('Position', get(0, 'Screensize'))
for isubj = 1:11
    subplot(3,4,isubj), hold on
    % Get time data
    tD = timeBiningTbl{isubj,11};
    str = sprintf('%s,', tD{:});
    numArray = sscanf(str, '%g,');
    bar(numArray)
    xlabel("Bin Index")
    ylabel("Number of Days")
    xticks(1:length(numArray))
    ylim([0 60])
    title(sprintf("Observer: %s",subjList{isubj}))
end
sgtitle("Time within each bin for each observer")
set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)

fileName = sprintf("figs/Perceptual Learning RC/Within_Bins_Indvd.jpg");
saveas(gcf, fileName);

%% Time between each bin for each observer

figure('Position', get(0, 'Screensize'))
for isubj = 1:11
    subplot(3,4,isubj), hold on
    % Get time data
    tD = timeBiningTbl{isubj,5};
    str = sprintf('%s,', tD{:});
    numArray = sscanf(str, '%i,');
    bar(numArray)
    xlabel("Bin Index")
    ylabel("Number of Days")
    xticks(1:length(numArray))
    txt = '';
    for i = 1:length(numArray)
        txt = [txt; sprintf('B%d-B%d',i,(i+1))];
    end
    xticklabels(txt);
    ylim([0 60])
    title(sprintf("Observer: %s", subjList{isubj}))
end
sgtitle("Time between each bin for each observer")
set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)

fileName = sprintf("figs/Perceptual Learning RC/Between_Bins_Indvd.jpg");
saveas(gcf, fileName);

%% Amount of experience
figure('Position', get(0, 'Screensize'))
subplot(1,2,1), hold on
title("Start trial")
binD = nan(nBins,11);
for i = 1:11
    for b = 1:nBins
        binD(b, i) = binningData{i}(b,1);
    end
    plot(binD(:,i),sprintf('%s-',markers_allSubj{i}), 'Color', [0 0 0 .2])
end

subplot(1,2,2), hold on
title("End trial")
binD = nan(nBins,11);
for i = 1:11
    for b = 1:nBins
        binD(b, i) = binningData{i}(b,2);
    end
    plot(binD(:,i),sprintf('%s-',markers_allSubj{i}), 'Color', [0 0 0 .2])
end

sgtitle("WIP")
set(findall(gcf, '-property', 'FontSize'), 'FontSize',fontSize)

fileName = sprintf("figs/Perceptual Learning RC/Experience.jpg");
saveas(gcf, fileName);