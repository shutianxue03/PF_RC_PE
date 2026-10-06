
function seprblty = getSeparability(data2D_)

datasSF_ = mean(abs(data2D_), 1);
datasOri_ = mean(abs(data2D_), 2);
data_new = datasOri_ * datasSF_;
seprblty = corr2(data2D_, data_new);