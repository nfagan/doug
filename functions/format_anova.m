function [storeValues,storeLabels] = format_anova(images,weightMeans)

global drugTypes;
global dosages;
global allTrialTypes;

nDoses = length(dosages);
nDrugs = length(drugTypes);
nTT = length(allTrialTypes);
nBlocks = length(images.(allTrialTypes{1}).(drugTypes{1}));

toAdd = 1;
for i = 1:nTT % for each image type ...
    trial = allTrialTypes{i}; 
    for k = 1:nDrugs % for each drug ...
        drug = drugTypes{k};
        for j = 1:nBlocks % for each block ...
            for l = 1:nDoses % for each dose ...
                dose = dosages{l};
                % get number of data points for this combination of image-type,drug,blockN, and dose
                updateLength = size(images.(trial).(drug)(l).(dose),1); 
                if toAdd == 1 %if this is the very first run through of the loop ...
                    storeValues = images.(trial).(drug)(l).(dose);
                    storeDrug = repmat({drug},updateLength,1);
                    storeDose = repmat({dose},updateLength,1);
                    storeBlock = repmat({num2str(l)},updateLength,1);
                    storeTrial = repmat({trial},updateLength,1);
                else %otherwise, update the stored values with the values from the next combination
                    % of image-type,drug,blockN, and dose ...
                    updateValues = images.(trial).(drug)(l).(dose);
                    updateDrug = repmat({drug},updateLength,1);
                    updateDose = repmat({dose},updateLength,1);
                    updateBlock = repmat({num2str(l)},updateLength,1);
                    updateTrial = repmat({trial},updateLength,1);
                    
                    storeValues = [storeValues;updateValues];
                    storeDrug = [storeDrug;updateDrug];
                    storeDose = [storeDose;updateDose];
                    storeBlock = [storeBlock;updateBlock];
                    storeTrial = [storeTrial;updateTrial];
                end
                
                storeLabels = {storeDrug,storeDose,storeBlock,storeTrial}; %store all the labels in a cell array
                
%                 toAdd = toAdd + updateLength + 1; 
                toAdd = 0;
            end
        end
    end
end

if weightMeans %optionally, expand the labels and values matrices according to how many data points (N) form each mean
    
    if size(storeValues,2) == 1;
        warning(['Means will not actually be weighted, because the input values' ...
            , ' from ''images'' are not means.']);
    end

    if size(storeValues,2) > 1 && size(storeValues,2) < 4;
        error('Missing N, std deviation, or other values');
    elseif size(storeValues,2) == 4
        for i = 1:length(storeValues)
            if i == 1
                newStoreValues = [repmat(storeValues(i,1),storeValues(i,4),1) ...
                    repmat(storeValues(i,2),storeValues(i,4),1) repmat(storeValues(i,3),storeValues(i,4),1)];
                for k = 1:length(storeLabels);
                    oneLabel = storeLabels{k};
                    newOneLabel = repmat({oneLabel{i}},storeValues(i,4),1);
                    newStoreLabels{k} = newOneLabel;
                end

            else
                update = [repmat(storeValues(i,1),storeValues(i,4),1) ...
                    repmat(storeValues(i,2),storeValues(i,4),1) repmat(storeValues(i,3),storeValues(i,4),1)];
                newStoreValues = [newStoreValues;update];

                for k = 1:length(storeLabels);
                    oneLabel = storeLabels{k};
                    updateOneLabel = repmat({oneLabel{i}},storeValues(i,4),1);
                    newStoreLabels{k} = [newStoreLabels{k};updateOneLabel];
                end

            end
        end

    storeLabels = newStoreLabels;
    storeValues = newStoreValues;
    
    end

end

            
            
    
            
        
            
    
