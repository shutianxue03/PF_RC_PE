function [df1, df2, F, p, anova_text] = print_nANOVA_v2(varNames, data, IVs)
% anova_text = print_nANOVA(varNames, data, IVs)
nVars = length(varNames);
[~, tbl] = anovan(data, IVs,'model','full','varnames', varNames, 'display', 'off');
df2 = tbl{end,3};

if nVars>1
    nrows = nchoosek(nVars,2) + nVars;
else
    nrows = 1;
end

anova_text = [];
for aa = 1:nrows
    varName = tbl{aa+1, 1};
    df1 = tbl{aa+1, 3};
    F = tbl{aa+1, 6};
    p =  tbl{aa+1, 7};
    anova_text = [anova_text, sprintf('%s: F(%d,%d) = %.3f, p = %.3f\n', varName, df1, df2, F,p)];
    %         anova_text = [anova_text, sprintf('%s%s\n', varName, getString_starts(p))];
end
