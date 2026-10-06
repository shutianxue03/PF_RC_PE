figure
tiledlayout(1,3)

nexttile
hold on
histogram(estParams2(1,:,1))
xline(.25, 'r');
xline(mean(estParams2(1,:,1)))
title('Distribution of Gain')
xlabel('Gain')
ylabel('Frequency')
hold off

nexttile
hold on
histogram(estParams2(1,:,2))
xline(16, 'r');
xline(mean(estParams2(1,:,2)))
title('Distribution of Width')
xlabel('Width')
ylabel('Frequency')
hold off

nexttile
hold on
histogram(estParams2(1,:,3))
xline(-.1, 'r');
xline(mean(estParams2(1,:,3)))
title('Distribution of Baseline')
xlabel('Baseline')
ylabel('Frequency')
hold off