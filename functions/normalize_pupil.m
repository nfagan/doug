function [normalized,normLabels] = normalize_pupil(storeValues,storeLabels,includeBaseline)

preBaseline = 200;

baselineMeans = mean(storeValues(:,1:preBaseline),2);

if includeBaseline
    withoutBase = storeValues;
else
    withoutBase = storeValues(:,preBaseline+1:end);
end

normalized = zeros(size(withoutBase,1),size(withoutBase,2));
for i = 1:size(withoutBase,2);
    normalized(:,i) = withoutBase(:,i)./baselineMeans;
end

checkZeros = sum(normalized == 0,2) >= 1; %index errors - zeros
checkNans = sum(isnan(normalized),2) >= 1; %index errors - nans

allErrors = checkZeros | checkNans;

normalized(allErrors,:) = [];
% normalized(checkZeros,:) = [];
normLabels = cell(1,length(storeLabels));
for i = 1:length(storeLabels);
    storeLabels{i}(allErrors,:) = [];
%     storeLabels{i}(checkZeros,:) = [];
end

normLabels = storeLabels;

end % end function








    
    