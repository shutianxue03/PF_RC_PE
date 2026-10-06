function [simData_] = DT_SimData(iLoc_all, nLoc2, nSimData, trueParams, x, ifamily, sim_noise)
y_pred = cell(nLoc2,nSimData);
for n = 1:nLoc2
%     switch iLoc_all(n)
%         case 1, title('Fovea');
%         case 2, title('LHM');
%         case 3, title('UVM');
%         case 4, title('RHM');
%         case 5, title('LVM');
%         case 6, title('HM');
%         case 7, title('VM');
%         case 8, title('Periphery');
%     end

    for i = 1:nSimData
        params0 = [trueParams(1,n), trueParams(2,n), trueParams(3,n)];
        y_pred(n,i) = {predSFkernel(x, ifamily, params0,0) + randn(1,length(x))*sim_noise};
    end
end

simData_ = y_pred;