%--------------------------------------------------------------------------------------------------------------
% INIT Settings
%--------------------------------------------------------------------------------------------------------------
fprintf('Initializing\n')

addpath(genpath('Data_OOD'));
addpath(genpath('fxn_analysis_RC_v2'));
addpath(genpath('fxn_MC'));
addpath(genpath('fxn_DT'));
addpath(genpath('fig'));

SX_RC1_setting

iLoc_all = [1];                          % Which locations to sample from
nLoc2 = length(iLoc_all);                % Number of sampled locations
x = linspace(-90, 90, 29);               % X axis params (e.g. ORI or SF array)
yData = nan(nLoc2, length(x));           % Your dataset; Generate dataset from yPred +- noise
ifamily = 1;                             % Gaussian curve: index for namesFamily_all
fitmode = 2;                             % SSE = 1, MLE = 2;
namesParams = namesParams_all{ifamily};  % Names of my parameters
nparams_full = length(namesParams);      % Number of parameters
nSimData = 1000;                          % Number of simulated data points per location
nDistrSize = 1;                          % Number of times to run program
sim_noise = .005;                        % Noise level
doSave = 0;

%Guess starting parameters for locations (Refer to iLoc_all for each location)
true_Gain  = [.25];
true_Width = [16];
true_Base = [.1];
trueParams = [true_Gain; true_Width; true_Base];

lb_full = lb_full_all{ifamily};                  % bounds based on ul_full_all
ub_full = ub_full_all{ifamily};                  % bounds based on ub_full_all

nSlice = 50;                            % How many interpolated points between the bounds

% lb_full(3) = 16;
% ub_full(3) = 16;

if doSave == 1
    conName = sprintf('No Opt Base_Parm(%.3f,%.3f,%.3f), Noise(%.6f), nData(%d), distSize(%d)', trueParams, sim_noise, nSimData, nDistrSize);       % Set folder and figure names
    
    foldername = sprintf('fig/%s',conName);
    mkdir(foldername)
    dirFigures = dir(foldername);
end

rng shuffle

close all
fprintf('Initializing complete!')

% Simulate Data
fprintf('\nCreating Simulating Data: %d\n',iDist)
   
simData_ = DT_SimData(iLoc_all, nLoc2,nSimData,trueParams,x,ifamily,sim_noise);

fprintf('Simulating Data complete!\n')

% Set up parameters
bounds = nan(3, nSlice);
for i = 1:3
    bounds(i,:) = linspace(lb_full(i),ub_full(i),nSlice);
end

nLL = nan(nSlice, nSlice, nSlice);
nLL_ = cell(1,nSimData);

% Organize the simulated data
y = nan(nSimData, length(x));
for i = 1:nSimData
    y(i,:) = simData_{i};
end

fprintf("Creating 3D Matrix\n");
for iData = 1:nSimData
    % Create 3D Matrix of nLL for each dataset
    yData = y(iData,:);
    parfor i = 1:nSlice
        for j = 1:nSlice
            for k = 1:nSlice
                params0 = [bounds(1,i),bounds(2,j),bounds(3,k)];
                nLL(i,j,k) = kernelFit(params0, x, yData, ifamily, fitmode);
            end
        end
    end
    nLL_(iData) = {nLL};
    if mod(iData,10)==0, fprintf('='), end
end

fprintf("\nCreating 3D Matrix complete!\n");
%%
fprintf("Greysearching Gain vs Base\n");
% minParams(dataset index, parameter index)
% parameter index: 1=gain, 2=width, 3=baseline, 4=deviance
minParams = nan(nSimData,4);
min_nLL_ = nan(nSimData,1);
for iData = 1:nSimData
    nLL = nLL_{iData};

    % Holding variable for 3 parameters (row indicates index on the bounds for width)
    p3 = nan(nSlice, 2);
    min_nLL = nan(1,nSlice);

    % Organize into workable slices
    for iWidth = 1:nSlice
        islice = nan(nSlice,nSlice);
        for iGain = 1:nSlice
            for iBase = 1:nSlice
                islice(iGain,iBase) = nLL(iGain,iWidth,iBase);
            end
        end
%         imagesc(bounds(1,:), bounds(3,:), islice)
%         xline(trueParams(1));
%         yline(trueParams(3));

        % Find param pair for minDev
        [M, I] = min(islice, [], 'all');
        [p1, p2] = ind2sub([nSlice nSlice], I);
%         plot(bounds(1,p1), bounds(3,p2), 'r+', "MarkerSize", 8);

        p3(iWidth,:) = [bounds(1,p1), bounds(3,p2)];
        min_nLL(iWidth) = M;
    end
    % Organize minParams for all datasets
    [M, I] = min(min_nLL);
    minParams(iData,:) = [p3(I,1),bounds(2,I),p3(I,2),M];

    if mod(iData,10)==0, fprintf('='), end
end

% xlim([bounds(1,1) bounds(1, length(bounds(1,:)))])
% ylim([bounds(3,1) bounds(3, length(bounds(3,:)))])
hold off

fprintf("\nGraysearching complete!\n")

fprintf('Corr Analysis\n')
% Corr analysis
rho = nan(1,3);
p = nan(1,3);

p1 = minParams(:,1);
p2 = minParams(:,3);
[rho(1), p(1)] = corr(p1, p2);

p1 = minParams(:,1);
p2 = minParams(:,2);
[rho(2), p(2)] = corr(p1, p2);

p1 = minParams(:,2);
p2 = minParams(:,3);
[rho(3), p(3)] = corr(p1, p2);

fprintf('Corr Analysis Complete!\n')

txt = sprintf('Model fitting via GraySearch');
figure ('Name',txt)
hold on
set(gcf,'Position',[100 100 1600 800])
tiledlayout (1,3);

nexttile
hold on
xline(trueParams(1))
yline(trueParams(3))
plot(minParams(:,1), minParams(:,3), '.', 'MarkerSize', 8);
plot(mean(minParams(:,1)), mean(minParams(:,3)), 'r+', 'MarkerSize',8)
% plot(fitlm(minParams(:,1), minParams(:,3)))
analysis = {sprintf('Rho:%.4f',mean(rho(1))),sprintf('p:%.4f',mean(p(1)))};
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
xline(trueParams(1))
yline(trueParams(2))
plot(minParams(:,1), minParams(:,2), '.', 'MarkerSize', 8);
plot(mean(minParams(:,1)), mean(minParams(:,2)), 'r+', 'MarkerSize',8)
% plot(fitlm(minParams(:,1), minParams(:,2)))
analysis = {sprintf('Rho:%.4f',mean(rho(2))),sprintf('p:%.4f',mean(p(2)))};
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
xline(trueParams(2))
yline(trueParams(3))
plot(minParams(:,2), minParams(:,3), '.', 'MarkerSize', 8);
plot(mean(minParams(:,2)), mean(minParams(:,3)), 'r+', 'MarkerSize',8)
% plot(fitlm(minParams(:,2), minParams(:,3)))
analysis = {sprintf('Rho:%.4f',mean(rho(3))),sprintf('p:%.4f',mean(p(3)))};
%text(ub_full(2)/2,ub_full(3)/2,analysis)
title('Width vs Baseline',analysis)
xlabel('Width')
ylabel('Baseline')
%     xlim([lb_full(2), ub_full(2)])
%     ylim([lb_full(3), ub_full(3)])
axis square
hold off