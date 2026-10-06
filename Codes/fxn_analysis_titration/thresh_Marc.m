% % thresholds from Marc's study
%              RHM UVM LVM LHM
% Aysun - 1.99  2.55 1.99 2.05
% Ekin - 1.98 2.85 2.45 1.97
% Zhilin - 2.36 4.35 3.86 2.48
% rania - 1.93 2.55 2.00 1.74

polar_ang = [90, 180, 270, 0, 90]/180*pi;

% sequence: LHM, UVM, RHM, LVM
thresh(1,1:4) = [2.05, 2.55, 1.99, 1.99]; % Aysun
thresh(2,1:4) = [1.97, 2.85, 1.98, 2.45]; % Ekin
thresh(3,1:4) = [2.48, 4.35, 2.36, 3.86]; % Zhilin
thresh(4,1:4) = [1.74, 2.55, 1.93, 2.00]; % Rania
%
% thresh(5,1:4) = [];
thresh_mean = mean(thresh);
thresh_SEM = std(thresh)/sqrt(size(thresh, 1));
%%
polarAxesHandle = figure;
% ax = gca;
% ax.XTick = [];
% ax.YTick = [];
polaraxes('Units',polarAxesHandle.Units,'Position',polarAxesHandle.Position)
hold on
polarplot(polar_ang, thresh_mean([1:4,1]), 'r')
polarplot(polar_ang, thresh([1:4,1], :), 'k')
ax = gca;
ax.ThetaTick = [];



