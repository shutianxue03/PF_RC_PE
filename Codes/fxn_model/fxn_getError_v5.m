
function nLL = fxn_getError_v5(iModelB, params, data_perCST, ncst_unik)

for icst_unik = 1:ncst_unik
% make prediction
pred = PR_pred(iModelB, params, data_perCST);

%% way 2: fit trial-wise responses
% only pC: from Fernandez2022
% plus pA: Dosher&Lu2008, Eq F2
fxn_nLL = @(p, m, n) -(n*log(p) + (m-n) * log(1-p));% + sum(log(1:m)) - (sum(log(1:n)) - sum(log(1:(m - n))));
fxn_factorialLog =@(m,n) sum(log(1:m)) - sum(log(1:n)) - sum(log(1:(m-n)));

ratio = .9;

pC = pred.metrics(3);
m_pC = length(data_perCST.resp{1}) + length(data_perCST.resp{2}); % number of total trials
n_pC = sum(data_perCST.resp{1}) + sum(1-data_perCST.resp{2}); % number of total correct trials

pA = pred.metrics(6);
m_pA = length(data_perCST.respC(:, 1)); assert(m_pA == m_pC/2)% number of total pairs
n_pA = nansum(data_perCST.respC(:, 1));% number of consistent pairs

nLL = fxn_nLL(pC, m_pC, n_pC) * fxn_factorialLog(m_pC, n_pC) + fxn_nLL(pA, m_pA, n_pA) * fxn_factorialLog(m_pA, n_pA);

if nLL == Inf, nLL = 1/eps; end

nLL_perCST(icst_unik) = nLL_perCST;
end
nLL = sum(nLL_perCST);
