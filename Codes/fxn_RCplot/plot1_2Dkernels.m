e2D_med_allSubj = getCI(kernels2D_allSubj, 1, 2); % med kernel of each subj (to conduct t-test on FP diff)
kernelLim_allLoc{1} = {[-.08, 0.12], [-.08, .12]}; % Fov, peri
kernelLim_allLoc{2} = {[-.08, .12], [-.08, .12]}; % HM, VM
kernelLim_allLoc{3} = {[-.08, .12], [-.08, .12]}; % LVM, UVM
kernelLim = kernelLim_allLoc{ill};
sz_title = 30;

for iBin=1:nBins
%     kernelLim = kernelLim_allType{itype};
    pCriterion = .001;
    [e2D_ave, ~, ~, e2D_sd] = getCI(e2D_med_allSubj(:, iBin, :, itype, :, :), 2, 1);
    
    folderDir = dir(nameFigFolder_RC_kernels2D); if isempty(folderDir), mkdir(nameFigFolder_RC_kernels2D), end
    
    % get interpolated axis
    e2D_ave1_interp = nan(nSF, 181);
    e2D_ave2_interp = e2D_ave1_interp;
    for iSF =1:nSF
        e2D_ave1_interp(iSF, :) =  interp1(axis_tuning{1}, squeeze(e2D_ave(1, :, iSF)), -90:90);
        e2D_ave2_interp(iSF, :) =  interp1(axis_tuning{1}, squeeze(e2D_ave(2, :, iSF)), -90:90);
    end
    e2D_diff_interp = e2D_ave1_interp - e2D_ave2_interp;
    
    % get axis ticks
    fprintf('[%s]\n', namesType{itype})
    for iiLoc=1:2
        ss = squeeze(e2D_ave(iiLoc, :, :));
        fprintf('%s: MIN is %.3f, MAX is %.3f\n', namesLocComb{iLocComb_all(iiLoc)}, min(ss(:)), max(ss(:)))
    end
    
    %%%%%%
    % Loc 1
    %%%%%%
    figure('Position', [0 0 1e3 1e3])
    RCplot_2Dkernel(e2D_ave1_interp, kernelLim{1})
    title(sprintf('n%d %s [%s - Bin%d]', nsubj, binStrategy, namesLocComb{iLocComb_all(1)}, iBin), 'FontSize', sz_title)
    saveas(gcf, sprintf('%s/n%d_L%d_Bin%d_%s.jpg', nameFigFolder_RC_kernels2D, nsubj, iLocComb_all(1), iBin, namesType{itype}))
    
    %%%%%%
    % Loc 2
    %%%%%%
    figure('Position', [4e2 0 1e3 1e3])
    RCplot_2Dkernel(e2D_ave2_interp, kernelLim{2})
    title(sprintf('n%d %s [%s - Bin%d]', nsubj, binStrategy, namesLocComb{iLocComb_all(2)}, iBin), 'FontSize', sz_title)
    saveas(gcf, sprintf('%s/n%d_L%d_Bin%d_%s.jpg', nameFigFolder_RC_kernels2D, nsubj, iLocComb_all(2), iBin, namesType{itype}))
    
end % iBins