
% written by Shutian Xue
% initiated on 01/17/2021
% updated on 02/28/2021, added eyetracking component
% updated on 06/24/2021, finished RC analysis part, and quick titration at the  start of each session

%% clean, clear and prepare
warning('off')
sca
clc
close all
format compact
commandwindow; % force the cursor to go automatically to command window
addpath(genpath('fxn_exp/'))
addpath(genpath('fxn_analysis_titration/'))
addpath(genpath('fxn_analysis_RC_v2/'))
addpath(genpath('fxn_RCplot'))
addpath(genpath('Data/'))
addpath(genpath('palamedes/'))
addpath(genpath('staircasecode_MJ/'))
addpath(genpath('fxn_checks/'))
addpath(genpath('AF_ExoRCV6/'))

%%
Screen('Preference', 'SkipSyncTests', 2);
exp_modes = {'Titration','Experiment','Practice', 'Quick titration', 'Simulation'};
EL_modes = {'OFF','ON'};

%% manually enter the info
subjName = 'SX';
exp_mode = 2;  % 0 = Titration, 1 = Experiment, 2 = Practice; 3 = quick titration; 4 = simulation
screen_mode = 1; % 0 = full screen; 1 = small screen
EL_mode = 0; % 0 = no eyelink; 1 = eyelink
demoFlag = 0;
if exp_mode == 2, EL_mode = 0; demoFlag = input('Demonstrate? (1 = YES, 0 = NO): '); end

clc
fprintf('Subject: %s\nMode: %s\nEye-tracker: %s\n ',subjName, exp_modes{exp_mode+1},EL_modes{EL_mode+1})

% try
%% initialize params
params = SX1_initParams(screen_mode, exp_mode);
fprintf("INIT FINISHED\n")

%% initialize eyelink
window = params.screen.wPtr;
if EL_mode, EL = SX3_initEL(window, params.screen); end
EL.ON = EL_mode;
fprintf("INIT EYELINNK FINISHED\n")

%% pull out threshold (if available)
[fileName,record] = SX4_checkFile(exp_mode, subjName, params);
fprintf("THRESHOLD INPUT COMPLETE\n")

%% display instruction
SX6_Intro(params)
fprintf("INSTRUCTIONS DISPLAY COMPLETE\n")
%% run the exp
record = SX7_run_AllBlocks(exp_mode, fileName, record, EL, params, demoFlag);
fprintf("EXPERIMENT RUN COMPLETE\n")
%% end exp
SX12_endExp
fprintf("END EXPERIMENT COMPLETE\n")
%% quick data analysis 
SX13_postEXP
fprintf("POST EXPERIMENT COMPLETE\n")

% catch
%     PsychPortAudio('Close', params.soundParams.pahandle);
%     Screen('CloseAll');
%     error('ALERT: something wrong in the middle !!')
% end


