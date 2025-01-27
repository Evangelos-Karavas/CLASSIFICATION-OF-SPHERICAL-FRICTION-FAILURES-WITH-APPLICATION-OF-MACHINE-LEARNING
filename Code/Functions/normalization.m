function [tbl_standarized,M,S] = normalization(tbl)

%Normalization of the Features to have 0 mean
% tbl_centered = normalize(tbl,'center','mean');
%Normalization of the Features to have 0 mean and 1 std
tbl_standarized = normalize(tbl,'zscore','std');

% NaN Handling
for i= 1: width(tbl_standarized)
    tbl_standarized.(i)(isnan(tbl_standarized.(i))) = 0;
end

M = mean(tbl.Variables);
S = std(tbl.Variables);
end

