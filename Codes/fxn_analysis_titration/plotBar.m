function plotBar(data_allSubj, data, err, barFaceColors, titles)

barX = repmat(1:5, 3, 1) + repmat([-1, 0, 1]' * .2, 1, 5);
if ~isempty(data_allSubj), nsubj = size(data_allSubj,2);end

for ib = 1:3
    % plot idvd data (subj)
%     if ~isempty(data_allSubj), for isubj = 1:nsubj, plot(barX(ib,:)', data_allSubj(:,isubj,ib), '.-','Color', barFaceColors(ib,:)), end, end
    % plot data
    if min(min(data)) < 0 % if data is log threshold (thus negative), plot dots, not bars, since bars will be hanging upside down
        if ib ==3, plot(barX(ib,:), data(ib,:), 'o','MarkerFaceColor', barFaceColors(ib,:),'MarkerEdgeColor', barFaceColors(ib,:), 'LineStyle', 'none', 'MarkerSize', 8)
        else, plot(barX(ib,:), data(ib,:), 'o','Color', barFaceColors(ib,:), 'LineStyle', 'none')
        end
    else
        b = bar(barX(ib,:), data(ib,:));
        b.FaceColor = barFaceColors(ib,:);
        b.BarWidth = .2;
    end
    % plot SEM
    errorbar(barX(ib,:), data(ib,:), err(ib,:), 'color',  barFaceColors(ib,:), 'LineStyle', 'none', 'handlevisibility', 'off')
    
end

xticks(1:5), xticklabels(titles), xtickangle(45)
