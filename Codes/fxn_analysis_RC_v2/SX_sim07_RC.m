function [kernel, intercept, R2, R2_Tjur, pValues, pCat, yfit] = SX_sim07_RC(filtersSF_all, filtersOri_all, e3D, resp, fxnLink)

if nargin < 5, fxnLink = 'probit'; end % defailt is probit
ntrials = length(resp);
nSF = length(filtersSF_all);
nORI = length(filtersOri_all);

%% empty containers
kernel = nan(nORI,nSF);
intercept = kernel;
R2 = kernel;
R2_Tjur = kernel;
pValues = nan(nORI,nSF, 2);
pCat = kernel;
yfit = nan(ntrials, nORI,nSF);

%%
for iORI = 1:nORI
    parfor iSF = 1:nSF %TEMP CHANGE: parfor
        
        x = e3D(:, iORI, iSF);
        try
            [beta,~,stats] = glmfit(x,resp,'binomial','Link', fxnLink);
        catch
            fprintf('\ne3D: %d, resp: %d', size(x,1), size(resp,1))
        end
        
        intercept(iORI, iSF) = beta(1);
        kernel(iORI, iSF) = beta(2);
        R2(iORI, iSF) = 1-var(stats.resid)./var(resp); % i.e., the typical R2
        pValues(iORI, iSF, :) = stats.p;
        yfit_ = glmval(beta, x, fxnLink);
        yfit(:, iORI, iSF) = yfit_;
        
        SS_res = sumsqr(stats.resid);
        SS_mod = sumsqr(mean(resp) - yfit(:, iORI, iSF));
        SS_total = sumsqr(mean(resp) - resp); % unquivalent to SS_res+SS_mod
        R2_mod = SS_mod/SS_total;
        R2_res = 1-SS_res/SS_total;
        R2_Tjur_ = (R2_mod+R2_res)/2;
        pCat_ = (sum(resp(yfit_>=.5)==1) + sum(resp(yfit_<=.5)==0))/length(resp);
        
        R2_Tjur(iORI, iSF) = R2_Tjur_;
        pCat(iORI, iSF) = pCat_;
        
        % quick plot
%                         quickPlot_regression
        
    end
end

