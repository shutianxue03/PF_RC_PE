
function R2 = getR2(y, yfit)
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);

R2 = 1 - SSresid/SStotal;