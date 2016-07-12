function [normalized,normLabels] = normalize_pupil2(storeValues,storeLabels,bins)

useBaselineBins = 0;
preBaseline = 200;

method = 2;

if useBaselineBins
    for i = 1:preBaseline/bins;
        binMeans(:,i) = mean(storeValues(:,1:bins*i),2);
    end
else
    binMeans = mean(storeValues(:,1:preBaseline),2);
    withoutBase = storeValues;
end

% withoutBase = storeValues(:,preBaseline+1:end);
if method == 1;
    stp = 0;
    for i = 1:round(size(withoutBase,2)/bins);
        binned = withoutBase(:,1+stp:bins*i);
        binned = mean(binned,2);
        normalized(:,i) = binned ./ binMeans(:,1);
        stp = stp + bins;
    end
elseif method == 2;
    stp = 0;
    for i = 1:round(size(withoutBase,2)/bins);
        binned = withoutBase(:,1+stp:bins*i);
    %     binned = mean(binned,2);
        binned = mean(nanmean(binned));
        normalized(:,i) = binned ./ mean(binMeans(:,1));
        stp = stp + bins;
    end
end

checkZeros = sum(normalized == 0,2) >= 1; %index errors - zeros
checkNans = sum(isnan(normalized),2) >= 1; %index errors - nans

allErrors = checkZeros | checkNans;

normalized(allErrors,:) = [];

normLabels = cell(1,length(storeLabels));

for i = 1:length(storeLabels);
    if method == 1;
        storeLabels{i}(allErrors,:) = [];
    elseif method == 2;
        if iscell(storeLabels{i})
            storeLabels{i} = storeLabels{i}{1};
        else
            storeLabels{i} = storeLabels{i}(1);
        end
    end
end

normLabels = storeLabels;



% baselineMeans = mean(storeValues(:,1:preBaseline),2);
% 
% if includeBaseline
%     withoutBase = storeValues;
% else
%     withoutBase = storeValues(:,preBaseline+1:end);
% end
% 
% normalized = zeros(size(withoutBase,1),size(withoutBase,2));
% for i = 1:size(withoutBase,2);
%     normalized(:,i) = withoutBase(:,i)./baselineMeans;
% end
% 
% checkZeros = sum(normalized == 0,2) >= 1; %index errors - zeros
% checkNans = sum(isnan(normalized),2) >= 1; %index errors - nans
% 
% allErrors = checkZeros | checkNans;
% 
% normalized(allErrors,:) = [];
% % normalized(checkZeros,:) = [];
% normLabels = cell(1,length(storeLabels));
% for i = 1:length(storeLabels);
%     storeLabels{i}(allErrors,:) = [];
% %     storeLabels{i}(checkZeros,:) = [];
% end
% 
% normLabels = storeLabels;
% 
% end % end function