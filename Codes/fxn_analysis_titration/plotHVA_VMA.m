
function plotHVA_VMA(data1, data2, data3, isubplot)

% data1: stair1, data2: stair2, data3: the average

color_r = [1 0 0]; % red
color_b= [0 0 1];% blue
color_p= [.75 .25 1]; % purple
color_o = [1, .75, 0]; % orange
color_g = [.25 .75, 0]; % green
color_k = [0 0 0]; % black

%% 
nmeaures = 3;
% threshold and RT, HVA and VMA are expected to be < 1
LR = nan(1,nmeaures); HVA = LR; VMA = LR;
for n=1:nmeaures % stair1, stair2, stair_ave
    switch n, case 1, data = data1; case 2, data = data2; case 3, data = data3; end 
        left = data(2); upper = data(3); right = data(4); lower = data(5);
        LR(n) = left/right;
        HVA(n) = mean([left, right])/mean([upper, lower]);
        VMA(n) = lower/upper;
end

title_ = sprintf('LR = L/R\nHVA = HM/VM\nVMA = lower/upper');

%%
subplot(3,5,isubplot), hold on
b = bar(1:nmeaures, [LR; HVA;VMA]);
plot([.5, nmeaures + .5], [1,1], '--k', 'LineWidth', 1.5)
xlim([.5, nmeaures + .5])

if isubplot == 11
    b(1).FaceColor = color_r;
    b(2).FaceColor = color_b;
    b(3).FaceColor = color_p;
else
    b(1).FaceColor = color_o;
    b(2).FaceColor = color_g;
    b(3).FaceColor = color_k;
end

xticks(1:nmeaures), xticklabels({'LR', 'HVA', 'VMA'})
if isubplot == 11, title(title_), end

