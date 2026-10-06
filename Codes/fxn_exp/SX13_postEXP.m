
%% save data (integrate all files and only leave one file)
addpath(genpath('Data/'))
folderName = ['Data/', subjName, '/'];
fileName = record.fileName;
fileName.formal_dir = dir([fileName.brief,'*']); % find out all past titratio files

% delete the last saved file containing data of the last block
if (sum(find(exp_mode == [0,3]))) && (length(params.design.loc_list) > 1)
    n_redundantFiles = size(fileName.formal_dir,1);
    for ir = 1:n_redundantFiles
        redundantFilesName = fileName.formal_dir(ir).name;
        if exist(redundantFilesName,'file'), delete([folderName, redundantFilesName]),end
    end
    save(fileName.formal, 'exp_mode', 'fileName', 'subjName', 'params', 'record')
end

%% rename eyedata file
if EL_mode
    eyeDataFileName = fileName.formal; % saved in record
    k = strfind(eyeDataFileName,'/');
    eyeDataFileName = eyeDataFileName(k(end)+1:end);
    movefile('eyedata/xx.edf', sprintf('eyedata/%s.edf', eyeDataFileName))
end

%% save params of this subj
if exp_mode ~= 2, save([folderName,subjName, 'params', num2str(exp_mode)], 'params'), end

%% plot thresh and acc
locNames = {'Fovea', 'Left', 'Upper', 'Right', 'Lower'};

figure
subplot(2,1,1), RCplot_allAcc
subplot(2,1,2), RCplot_CSTbySess
set(findall(gcf, '-property', 'FontSize'), 'FontSize',15)
set(findall(gcf, '-property', 'linewidth'), 'linewidth',1.5)

%% save thresh and acc of the current session
% saveThreshAcc % in exp folder

%% plot titration data
if exp_mode == 0, exp_plotTitration, end % also save PDF!!

%% plot titration data of qstair
if exp_mode == 3, exp_plotQstair, end % plot titration data of qstair
    