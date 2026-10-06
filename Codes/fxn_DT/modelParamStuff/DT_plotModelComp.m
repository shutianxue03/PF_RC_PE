function DT_plotModelComp(dev, nparams, paramInd_all, nData, nmodels, plotmode)
% Compile data
dev_mean = nan(nmodels, nmodels);
dev_SE = nan(nmodels, nmodels);
for i = 1:nmodels
    dev_SE(i,:) = DT_getSE(dev{i}); 
    dev_mean(i,:) = mean(dev{i});
end

[dDev, I] = sort(dev_mean,2);
dDev = dDev - dDev(:,1);

% plot stuff
figure ('Name','Model Comparison')

tiledlayout (3,3)
for i = 1:nmodels
    nexttile
    hold on
    txt = sprintf('Model %d: %d,%d,%d', i, paramInd_all(i,1),paramInd_all(i,2),paramInd_all(i,3));
    title(txt)
    bar(dDev(i,:));
    xticks(1:nmodels);
    for j = 1:nmodels
        if j == 1
            txt = [sprintf('Model %d', I(i,j)), sprintf(' [%d, %d, %d]', paramInd_all(I(i,j),1),paramInd_all(I(i,j),2),paramInd_all(I(i,j),3))];
        else
            txt = [txt; sprintf('Model %d', I(i,j)), sprintf(' [%d, %d, %d]', paramInd_all(I(i,j),1),paramInd_all(I(i,j),2),paramInd_all(I(i,j),3))];
        end
    end

    xticklabels(txt);
    xlabel('Candidate Model')
    switch plotmode
        case 0
            txt = 'nLL';
        case 1
            txt = 'BIC';
        case 2
            txt = 'AIC';
        case 3
            txt = 'AICc';
    end
    ylabel(txt)
    hold off
end