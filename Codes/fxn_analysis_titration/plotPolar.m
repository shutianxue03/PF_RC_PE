function plotPolar(isubplot, polar_ang, data, barFaceColors)

ndata = size(data,1); % no. of conditions (e.g., 3, for stair1,stair2 and both)
polarAxesHandle = subplot(3,5,isubplot);
ax = gca;
ax.XTick = [];
ax.YTick = [];
polaraxes('Units',polarAxesHandle.Units,'Position',polarAxesHandle.Position)
hold on

for idata = 1:ndata
    polarplot(polar_ang, data(idata,:), 'Color', barFaceColors(idata,:))
end

ax = gca;
ax.ThetaTick = [];