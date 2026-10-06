%--------------------------------------------------------------------------------------------------------------
% INIT Settings
%--------------------------------------------------------------------------------------------------------------
fprintf('Initializing\n')

addpath(genpath('Data_OOD'));
addpath(genpath('fxn_analysis_RC_v2'));
addpath(genpath('fxn_MC'));
addpath(genpath('fxn_DT'));
addpath(genpath('fig'));

SX_RC1_setting                          % Use to extract initial variables (upper and lower bounds, models, etc.)

iLoc_all = [1];                        % Which locations to sample from
nLoc2 = length(iLoc_all);                % Number of sampled locations
x = linspace(-90, 90, 100);               % X axis params (e.g. ORI or SF array)
yData = nan(nLoc2, length(x));           % Your dataset; Generate dataset from yPred +- noise
ifamily = 1;                             % Gaussian curve: index for namesFamily_all
fitmode = 2;                             % SSE = 1, MLE = 2;
namesParams = namesParams_all{ifamily};  % Names of my parameters
nparams_full = length(namesParams);      % Number of parameters
nSimData = 1000;                         % Number of simulated data points per location
nDistrSize = 1;                          % Number of times to run program
sim_noise = 0;                           % Noise level
doPlot = 1;                              % 1 = yes, 0 = no
doHist = 0;                              % 1 = yes, 0 = no
doSave = 0;                              % 1 = yes, 0 = no

%Guess starting parameters for locations (Refer to iLoc_all for each location)
true_Gain  = [.25];
true_Width = [16];
true_Base = [-.1];
trueParams = [true_Gain; true_Width; true_Base];

lb_full = lb_full_all{ifamily};                  % bounds based on ul_full_all
ub_full = ub_full_all{ifamily};                  % bounds based on ub_full_all

% lb_full(2) = 16;                               % for controlling what fmincon searches for
% ub_full(2) = 16;

% lb_full(3) = 16;
% ub_full(3) = 16;

if doSave == 1
    conName = sprintf('Param(%.3f,%.3f,%.3f), Noise(%.6f), nData(%d), distSize(%d)', trueParams, sim_noise, nSimData, nDistrSize);       % Set folder and figure names
    
    foldername = sprintf('fig/%s',conName);
    mkdir(foldername)
    dirFigures = dir(foldername);
end

rng shuffle

close all
fprintf('Initializing complete!')

rhoDist = [];
pDist = [];
for iDist = 1:nDistrSize
    fprintf('\nCreating Simulating Data: %d\n',iDist)

    % Simulate Data for each sampleset
    % simData_ = cell(num Locations, nSimData)
    simData_ = DT_SimData(iLoc_all, nLoc2,nSimData,trueParams,x,ifamily,sim_noise);
    
    fprintf('Simulating Data complete!\n')
    fprintf('Finding optimal parameters\n')
    
    estParams2 = nan(nLoc2, nSimData, nparams_full);
    for i = 1:nLoc2
        [estParams2(i,:,:), rho, p] = DT_optParams(x, simData_(i,:), lb_full, ub_full, ifamily, fitmode);
        rhoDist = [rhoDist; rho];
        pDist = [pDist; p];
    end

    if mod(iDist,100) == 0, fprintf('Dist: %d/%d',iDist,nDistrSize); end
end

fprintf('\n')

% which location to plot
i = 1;
%simData_ = DT_SimData(iLoc_all, nLoc2,nSimData,trueParams,x,ifamily,sim_noise);
%[estParams2(i,:,:), rho, p] = DT_optParams(x, simData_(i,:), lb_full, ub_full, ifamily, fitmode);

% rhoDist = (dataset index, param combination)
% pDist = (dataset index, param combination
% param combination: 1 = Gain vs. Baseline, 2 = Gain vs. Width, 3 = Width vs Base

if doHist == 1
    figure('Name','Dist of Rho')
    set(gcf,'Position',[100 100 1600 800])
    tiledlayout(1,3)
    
    nexttile
    hold on
    histogram(rhoDist(:,1));
    xline(mean(rhoDist(:,1)));
    xlabel('Rho');
    ylabel('Frequency');
    title('Rho Dist between Gain and Baseline')
    hold off
    
    nexttile
    hold on
    histogram(rhoDist(:,2));
    xline(mean(rhoDist(:,2)));
    xlabel('Rho');
    ylabel('Frequency');
    title('Rho Dist between Gain and Width')
    hold off
    
    nexttile
    hold on
    histogram(rhoDist(:,3));
    xline(mean(rhoDist(:,3)));
    xlabel('Rho');
    ylabel('Frequency');
    title('Rho Dist between Width and Baseline')
    hold off

    if doSave==1, saveas(gcf,'rho Distr.jpg'); end
    
    figure('Name','Dist of p')
    set(gcf,'Position',[100 100 1600 800])
    tiledlayout(1,3)
    
    nexttile
    hold on
    histogram(pDist(:,1));
    xline(mean(pDist(:,1)));
    xlabel('p');
    ylabel('Frequency');
    title('p Dist between Gain and Baseline')
    hold off
    
    nexttile
    hold on
    histogram(pDist(:,2));
    xline(mean(pDist(:,2)));
    xlabel('p');
    ylabel('Frequency');
    title('p Dist between Gain and Width')
    hold off
    
    nexttile
    hold on
    histogram(pDist(:,3));
    xline(mean(pDist(:,3)));
    xlabel('p');
    ylabel('Frequency');
    title('p Dist between Width and Baseline')
    hold off

    if doSave==1, saveas(gcf,'p Distr.jpg'); end 
end

% I use i below to refer to the latest location calculated but can be
% ignored since I am only focusing on one location

if doPlot == 1
    txt = sprintf('Model fitting via fmincon');
    figure ('Name',txt)
    hold on
    set(gcf,'Position',[100 100 1600 800])
    tiledlayout (1,3);
    
    nexttile
    hold on
    xline(trueParams(1,i))
    yline(trueParams(3,i))
%     plot(estParams2(i,:,1), estParams2(i,:,3), '.', 'MarkerSize', 8);
%     plot(mean(estParams2(i,:,1)), mean(estParams2(i,:,3)), 'r+', 'MarkerSize',8)
    plot(fitlm(estParams2(i,:,1), estParams2(i,:,3)))
    analysis = {sprintf('Rho:%.4f',mean(rhoDist(1))),sprintf('p:%.4f',mean(pDist(1)))};
    %text(ub_full(1)/2,ub_full(3)/2,analysis)
    title('Gain vs Baseline',analysis)
    xlabel('Gain')
    ylabel('Baseline')
%     xlim([lb_full(1), ub_full(1)])
%     ylim([lb_full(3), ub_full(3)])
    axis square
    hold off

    nexttile
    hold on
    xline(trueParams(1,i))
    yline(trueParams(2,i))
%     plot(estParams2(i,:,1), estParams2(i,:,2), '.', 'MarkerSize', 8);
%     plot(mean(estParams2(i,:,1)), mean(estParams2(i,:,2)), 'r+', 'MarkerSize',8)
    plot(fitlm(estParams2(i,:,1), estParams2(i,:,2)))
    analysis = {sprintf('Rho:%.4f',mean(rhoDist(2))),sprintf('p:%.4f',mean(pDist(2)))};
    %text(ub_full(1)/2,ub_full(2)/2,analysis)
    title('Gain vs Width',analysis)
    xlabel('Gain')
    ylabel('Width')
%     xlim([lb_full(1), ub_full(1)])
%     ylim([lb_full(2), ub_full(2)])
    axis square
    hold off

    nexttile
    hold on
    xline(trueParams(2,i))
    yline(trueParams(3,i))
%     plot(estParams2(i,:,2), estParams2(i,:,3), '.', 'MarkerSize', 8);
%     plot(mean(estParams2(i,:,2)), mean(estParams2(i,:,3)), 'r+', 'MarkerSize',8)
    plot(fitlm(estParams2(i,:,2), estParams2(i,:,3)))
    analysis = {sprintf('Rho:%.4f',mean(rhoDist(3))),sprintf('p:%.4f',mean(pDist(3)))};
    %text(ub_full(2)/2,ub_full(3)/2,analysis)
    title('Width vs Baseline',analysis)
    xlabel('Width')
    ylabel('Baseline')
%     xlim([lb_full(2), ub_full(2)])
%     ylim([lb_full(3), ub_full(3)])
    axis square
    hold off

    if doSave==1
        fileName = sprintf('%s/Params Recovery.jpg', foldername);
        saveas(gcf,fileName)
    end
end