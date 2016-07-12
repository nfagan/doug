function [store_mean,store_std] = get_binned_fix_dur(fix_durs,bin_size,varargin)

params = struct(...
    'multiMeans',1 ...
    );
params = structInpParse(params,varargin);

if params.multiMeans;
    account_for_multiple_means = 1;
else
    account_for_multiple_means = 0;
end

store_mean = zeros(1,size(fix_durs,2)/bin_size);
store_std = zeros(1,size(fix_durs,2)/bin_size);

stp = 1;
for i = 1:size(fix_durs,2)/bin_size
    
    extr = fix_durs(:,stp:bin_size*i);
    
    if account_for_multiple_means
        col_mean = zeros(size(extr,2),1); col_var = zeros(size(extr,2),1);
        N = zeros(size(extr,2),1);
        for j = 1:size(extr,2);
                non_zero_extr = extr(extr(:,j) ~= 0,j);
                if ~isempty(non_zero_extr);
                    col_mean(j,1) = mean(non_zero_extr);
                    col_var(j,1) = std(non_zero_extr)^2;
                    N(j,1) = length(non_zero_extr);
                end
        end
        [store_mean(i),store_std(i)] = multiMeans([col_mean zeros(bin_size,1) col_var N],...
            'errorType','std');
    else
        col_mean = zeros(1,bin_size); col_var = zeros(1,bin_size);
        for j = 1:size(extr,2);
            non_zero_extr = extr(extr(:,j) ~= 0,j);
            if ~isempty(non_zero_extr);
                col_mean(j) = mean(non_zero_extr);
                col_var(j) = std(non_zero_extr)^2;
            end
        end
        store_mean(i) = mean(col_mean);
        store_std(i) = mean(sqrt(std(col_var).^2));
%         store_mean(i) = mean(mean(extr));
%         store_std(i) = mean(sqrt((std(extr).^2)));
    end
    
    stp = stp + bin_size; % update start index
end
