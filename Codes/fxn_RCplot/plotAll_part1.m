
%%%%%%%%%%%%%%%% PART 1 %%%%%%%%%%%%%%%%
% focus on RC analysis
% make sure you have run SX_analysis4_Boot first

close all, clc

%--------------%
SX_RC1_setting
%--------------%
paramMode = 2;
flag_standEnergy = 1;
flag_mirrorMapping = 1;
itype = 2;
nLoc = 2;
if nLoc == 2, nameFileLoc = sprintf('L%d%d', iLocComb_all(1), iLocComb_all(2)); else, nameFileLoc = sprintf('all%d', nLoc); end
iBin_lb = 1; iBin_ub = nBins; % compare the 1st and the last bin

%% 0. performance
close all
fprintf('\n\nCompiling Behav data...\n')
%-------------%
plot0_Behav
%-------------%

%% 1. 2D kernels
clc, close all
nameFigFolder_RC_kernels2D = sprintf('%s/kernels2D', nameFigFolder_RC); if isempty(dir(nameFigFolder_RC_kernels2D)), mkdir(nameFigFolder_RC_kernels2D), end
%-------------%
% plot1_2Dkernels
%-------------%

% close all

%% 2. separability
close all, clc
nameFigFolder_RC_sep = sprintf('%s/sep', nameFigFolder_RC); if isempty(dir(nameFigFolder_RC_sep)), mkdir(nameFigFolder_RC_sep), end

flag_plotIDVD = 1;
flag_plotDiff = 1;
flag_pairwiseComp = 1;

%-------------%
plot2_sep
%-------------%

%% 3. marginalized kernels per combined loc (compare two loci)
nameFigFolder_RC_marg = sprintf('%s/marg', nameFigFolder_RC); if isempty(dir(nameFigFolder_RC_marg)), mkdir(nameFigFolder_RC_marg), end
flag_plotIDVD = 0; % 1=plot idvd tuning fxn

for iiLoc = 1:nLoc
    %-------------%
%     plot3_marg
%-------------%
end
close all

%% 3b. idvd tuning function
close all
nameFigFolder_RC_margIDVD = sprintf('%s/margIDVD', nameFigFolder_RC); if isempty(dir(nameFigFolder_RC_margIDVD)), mkdir(nameFigFolder_RC_margIDVD), end
%-------------%
% plot3b_margIDVD
%-------------%
close all

%% 4. params
close all, clc
nameFigFolder_RC_params = sprintf('%s/params/L%d%d', nameFigFolder_RC, iLocComb_all); if isempty(dir(nameFigFolder_RC_params)), mkdir(nameFigFolder_RC_params), end

flag_plotIDVD = 1;
flag_plotDiff = 1;
flag_pairwiseComp = 1;

%-------------%
plot4_params
%-------------%

