function [storeValues,outputLabels] = extract_data(new_saveData,labels)

global toExamine;
global region;

possibleInputs = ['\nproportions\nmeanLookingDuration\nmeanFixEventDuration\nnImages'...
, '\nnFixations\npupilSize\nlookingDuration\nfixEventDuration\n'];

switch toExamine;
    case 'fixCountsTimeCourse'
        wantedField = 'fix_counts_time_course';
    case 'fixDurTimeCourse'
        wantedField = 'fix_dur_time_course';
    case 'nImagesPerSession'
        wantedField = 'nImagesPerSession';
    case 'pupilPSTHBaseline'
        wantedField = 'baselinePupilSizePerFixEvent';
    case 'pupilPSTH'
        wantedField = 'pupilSizePerFixEvent';
    case 'pupilTimeCourse'
        wantedField = 'pupilTimeCourse';
    case 'pupilSizePerFixEvent'
        wantedField = 'pupilSizePerFixEvent'; %duplicate to preserve compabatibility
    case 'nImages'
        wantedField = 'nImages';
    case 'lookingDuration'
        wantedField = 'lookingDuration';
    case 'fixEventDuration'
        wantedField = 'fixEventDuration';
    case 'proportions'
        wantedField = 'proportions';
    case 'nFixations'
        wantedField = 'nFixationsPerImage';
    case 'meanLookingDuration'
        error(['Use toExamine = ''meanLookingDuration'' with analysisVersion = ''old'''...
            , ' and function reformatSaveData.m']);
        wantedField = 'meanLookingDuration';
    case 'meanFixEventDuration'
        error(['Use toExamine = ''meanFixEventDuration'' with analysisVersion = ''old'''...
            , ' and function reformatSaveData.m']);
        wantedField = 'meanDurationFixEvent';
    case 'pupilSize'
        wantedField = 'pupilSize';
    otherwise
        fprintf(possibleInputs);
        error(['\n ''%s'' is not a recognized output of getDur2. See above for possible' ...
            , ' values of toExamine'],toExamine);
end 

if strcmp(region,'screen');
    rg = 2;
else
    rg = 1;
end

l = length(labels);
outputLabels = cell(1,l+1);

for k = 1:l;

toAdd = 1;

for i = 1:length(new_saveData);
    extrValues = new_saveData{i}{rg}.(wantedField);
    nReps = size(extrValues,1);
        oneLabel = labels{k}{i};
        if toAdd == 1;
            outputLabels{k} = repmat(oneLabel,nReps,1);
            toAdd = 0;
        else
            outputLabels{k} = [outputLabels{k};repmat(oneLabel,nReps,1)];
        end
        
        if k == 1;%only do this on the first pass of k
            if i == 1;
                storeValues = extrValues;
            else                
                if size(extrValues,2) == size(storeValues,2)
                    storeValues = [storeValues;extrValues];
                else
                    storeValues = [storeValues;nan(nReps,size(storeValues,2))];
                end
            end
        end
end
end

sessionCol = size(storeValues,2);
outputLabels{l+1} = storeValues(:,sessionCol);

if sessionCol > 1;
    storeValues = storeValues(:,1:(sessionCol - 1));
end

% nanInd = isnan(storeValues(:,1)); %get rid of repeated NaN values (from empty data)
nanInd = sum(isnan(storeValues),2) >= 1; %get rid of repeated NaN values (from empty data)

storeValues(nanInd,:) = [];
for i = 1:l+1
    outputLabels{i}(nanInd) = [];
end

% if strcmp(toExamine,'nImages') || strcmp(toExamine,'nFixations')
%     [storeValues,outputLabels] = sums_within_condition(storeValues,outputLabels);
% end


        
        
        
        