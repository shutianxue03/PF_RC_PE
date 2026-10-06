
colors = colors_perBinPerComb(:, iLocComb_all);
x_ticks = namesLocComb(iLocComb_all);
paramMode = 2;
sz_fig = [350 350]; % size of the figure canvas

for ifeature = 1:2
    
    xaxis = axis_tuning{ifeature};
    nfilters = length(xaxis);
    ifamily = ifamily_perF(ifeature);
    namesTunC = namesTunC_unit_perF{ifamily, paramMode};
    nTunC_full = length(namesTunC);
    
    y_ticks_all = [];
    
    %% decide y_ticks of ORI/SF domain (3 values)
    switch ifamily_perF(ifeature)
        case 1
            if flag_plotIDVD, y_ticks_all{1} = linspace(0, 36, 5); % preferred ori
            else, y_ticks_all{1} = linspace(0, 20, 5); % preferred ori
            end
            
            if flag_plotIDVD
                y_ticks_all{2} = linspace(0, .24, 5); % peak amp
                y_ticks_all{3} = linspace(0, 60, 5); % band
                y_ticks_all{4} = linspace(-.1, .1, 5); % baseline
            else
                y_ticks_all{2} = linspace(0, .24, 5); % peak amp
                y_ticks_all{3} = linspace(10, 50, 5); % band
                y_ticks_all{4} = linspace(-.05, .03, 5); % baseline
            end
        case 8
            % for L18
            y_ticks_all{1} = linspace(0, 16, 5); % preferred ori
            y_ticks_all{2} = linspace(.04, .12, 5); % peak amp
            y_ticks_all{3} =  linspace(30, 90, 5); % trough ori
            y_ticks_all{4} =  linspace(-.02, .02, 5); % trough amp
            y_ticks_all{5} = linspace(30, 50, 5); % band
            y_ticks_all{6} = linspace(-.02, .02, 5); % baseline
            
            % for others
            y_ticks_all{1} = linspace(0, 16, 5); % preferred ori
            y_ticks_all{2} = linspace(0, .12, 5); % peak amp
            y_ticks_all{3} =  linspace(20, 60, 5); % trough ori
            y_ticks_all{4} =  linspace(-.02, .02, 5); % trough amp
            y_ticks_all{5} = linspace(20, 60, 5); % band
            y_ticks_all{6} = linspace(-.02, .02, 5); % baseline
            
        case 2 % log parabola
            if flag_plotIDVD
                y_ticks_all{1} = linspace(0, 2, 5); % peak SF
                y_ticks_all{2} = linspace(0, .16, 5); % peak amp
                y_ticks_all{3} = linspace(0, 1.2, 5); % bandwidth
                y_ticks_all{4} = linspace(-.1, .1, 5); % baseline
            else
                y_ticks_all{1} = linspace(0, 2, 5); % peak SF
                y_ticks_all{2} = linspace(.02, .06, 5); % peak amp
                y_ticks_all{3} = linspace(.3, 1.5, 5); % bandwidth
                y_ticks_all{4} = linspace(-.08, 0, 5); % baseline
            end
            
        case 3 % truncated log parabola
            y_ticks_all{1} = linspace(0, 2, 5); % peak SF
            y_ticks_all{2} = 0:.02:.08; % peak amp
            y_ticks_all{3} = .3:.2:1.1; % bandwidth
            y_ticks_all{4} = linspace(-.04, .04, 5); % baseline
            y_ticks_all{5} = 0:.03:.12; % trunc
            
    end

    for iTunC = 1:nTunC_full
        
        text_title = sprintf('%s %s', namesFeature{ifeature}, namesTunC{iTunC});

        % get median of each observer
        switch ifeature
            case 1, data_allSubj = margTuningC_ORI_allSubj(:, :, :, :, itype, iTunC); % nsubj x nB x nBins, nLoc2 x ntypes x nTunC
            case 2, data_allSubj = margTuningC_SF_allSubj(:, :, :, :, itype, iTunC);
        end
        med_allSubj = getCI(data_allSubj, 1, 2);
        
        %%%%%%%
        % ONE-WAY ANOVAs
%         med_aveLoc = getCI(med_allSubj, 2, 2);
%         indLoc = repmat(1:nLoc, nsubj, 1);
%         text_aveLoc = print_nANOVA({'Loc'}, med_aveLoc(:), indLoc(:), nsubj);
%         
%         med_aveBin = getCI(med_allSubj, 2, 3);
%         indBin = repmat(1:nBins, nsubj, 1);
%         text_aveBin = print_nANOVA({'Bin'}, med_aveBin(:), indBin(:), nsubj);
%         
%         fprintf('%s %s:\n   %s   %s\n', namesFeature{ifeature}, namesTunC{iTunC}, text_aveLoc, text_aveBin)
        %%%%%%%
        
        % get ytick labels and ref
        y_ticklabels = y_ticks_all{iTunC};
        ref = nan;
        switch ifamily_perF(ifeature)
            case 1, if find(iTunC==[1,4]), ref = 0; end
            case 8
                switch iTunC
                    case 1, ref = 0;
                    case 6, ref = 0;
                end
                
            case 2 % log parabola
                switch iTunC
                    case 1, y_ticklabels = round(2.^y_ticks_all{iTunC}, 1); ref = log2(2); med_allSubj = log2(med_allSubj); % pref SF
                    case 4, ref = 0; % baseline
                end
            case 3 % truncated log parabola
                switch iTunC
                    case 1, y_ticklabels = round(2.^y_ticks_all{iTunC},2); ref = log2(2); med_allSubj = log2(med_allSubj); % pref SF
                    case 4, ref = 0; % baseline
                end
            case 12 % double peak
                if find(iTunC==[1,4]), y_ticklabels = round(2.^y_ticks_all{iTunC},2); ref = log2(2);  end
                
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %=== CI of t-test ===
        % have not decided what test to do
%         for iB = 1:nB
%             x=squeeze(data_allSubj(:, :, iB, :));[~, p, ~, stats] = ttest(x(:, 1), x(:, 2));cohenD = fxn_getES(x(:, 1), x(:, 2));
%             p_allB(iB) = p; t_allB(iB) = stats.tstat; cohenD_allB(iB) = cohenD;
%         end
%         [p_med, p_lb, p_ub] = getCI(p_allB, 1, 2); 
%         [t_med, t_lb, t_ub] = getCI(t_allB, 1, 2);
%         [d_med, d_lb, d_ub] = getCI(cohenD_allB, 1, 2);
%         title_CI = sprintf('t=%.3f [%.3f, %.3f], p=%.3f [%.3f, %.3f], d=%.3f [%.3f, %.3f]', t_med, t_lb, t_ub, p_med, p_lb, p_ub, d_med, d_lb, d_ub);
        %===============
%         text_title = sprintf('%s\n%s', text_title, title_CI);
        text_title = sprintf('n%d %s L%d%d\n%s ', nsubj, binStrategy, iLocComb_all, text_title);
        basicFxn_drawBars2(squeeze(med_allSubj(:, indBins, :)), ref, colors, y_ticks_all{iTunC}, y_ticklabels, flag_plotIDVD, text_title, sz_fig, markers_allSubj);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % save
        saveas(gcf, sprintf('%s/n%d_%s%d_nBins%d.jpg', nameFigFolder_RC_params, nsubj, namesFeature{ifeature}, iTunC, length(indBins)))
        
    end % end of iparam
end