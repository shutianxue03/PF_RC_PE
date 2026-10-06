function [se] = DT_getSE(data)

se = std(data)/sqrt(length(data));