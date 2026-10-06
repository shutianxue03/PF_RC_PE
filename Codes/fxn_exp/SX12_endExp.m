% function SX12_endExp(subjName, EL, params, record, exp_mode)

screen = params.screen;
stim = params.stim;
design = params.design;
soundParams = params.soundParams;
time = params.time;
exp_screenRefresh(screen);

%% turn off EL recording (after each block)
if EL.ON
    if ~exist(EL.eyeDataDir,'dir'), mkdir(EL.eyeDataDir); end
    rd_eyeLink('eyestop', screen.wPtr, {EL.eyeFile, EL.eyeDataDir});
end

%% turn off screen
DrawFormattedText(screen.wPtr, stim.line_end ,'center', 'center', screen.black); Screen('Flip', screen.wPtr);
WaitSecs(2);
Screen('CloseAll');
for ff = [800, 600, 400], makeBeep(soundParams, ff, time.feedback*2), end

%% turn off sound track
PsychPortAudio('Close', soundParams.pahandle);

%% present acc, d' and criterion
clc

for bb = 1:design.nBlocks
    fprintf('B%d/%d L%d: acc (%%) = %d, d'' = %.2f, c = %.2f, dur: %d secs.\n', bb, design.nBlocks, design.loc_list(bb), record.accPerBlock(bb)*100, record.dprime(bb), record.criterion(bb), round(record.duration(bb)));
end
fprintf('\nTotal dur: %d minutes.\n', round(sum(record.duration(end:-1:end-design.nBlocks+1))/60));
[~,b] = sort(design.loc_list);
fprintf('All accuracy: [%d, %d, %d, %d, %d]\n', round(record.accPerBlock(b)*100))
