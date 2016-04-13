function [storeVals,storeLabels] = combine_data(values,labels)

if length(values) ~= length(labels)
    error('Each value matrix must have a corresponding labels matrix');
end    

storeVals = concatenateData(values);

for i = 1:length(labels{1});
    for k = 1:length(labels);
        if k == 1;
            storeLabels{i} = labels{k}{i};
        else
            storeLabels{i} = [storeLabels{i};labels{k}{i}];
        end
        
    end
end