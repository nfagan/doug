function varargout = plot_over_dose_per_stimulus(images,varargin)

% -- define global variables

global toExamine;
global allTrialTypes;
global drugTypes;
global dosages;

varCol = 3; %which column stores the variance
numBlocks = length(images.(allTrialTypes{1}).(drugTypes{1}));
numDoses = length(dosages);
numImages = length(allTrialTypes);

% -- check basic input validity

if numBlocks > 1
    error(['There is more than 1 block in the images struct. Rerun the script' ...
        , ' with only one block''s worth of data. Alternatively, use' ...
        , ' ''plot_over_time_per_stimulus.m'' to plot multiple blocks'' worth'...
        , ' of data.']);
end

% -- define default values for optional inputs

params = struct( ...
    'debug',0, ...
    'limits',[] ...
    );

% -- parse optional inputs

params = structInpParse(params,varargin);

% -- get means per dose

for i = 1:numImages;
    trialType = allTrialTypes{i};
    for j = 1:length(drugTypes);
        drug = drugTypes{j};
        for k = 1:length(dosages);
            dose = dosages{k};
            oneDose = images.(trialType).(drug).(dose);

            if (any(isnan(oneDose)) | isempty(oneDose)) & ~params.debug
                error(['Data is missing for ''%s'' images in block %d of %s trials. Try rerunning' ...
                    , ' the analysis script with fewer blocks.'],trialType,h,drug);
            else
                oneDose(isnan(oneDose)) = 0;
            end

            if size(oneDose,2) > 1;
                [avg,stdError] = multiMeans(oneDose);
%                 avg = mean(oneDose(:,1));
%                 stdError = sqrt(mean(oneDose(:,varCol)))/sqrt(length(oneDose(:,varCol)));
            else
                avg = mean(oneDose);
                stdError = SEM(oneDose);
            end
        means.(trialType).(drug).(dose) = avg;
        errors.(trialType).(drug).(dose) = stdError;
        end
    end

end

% -- plot

xCoords = 1:numDoses; %

toLabel = cell(1,numDoses*2);
for i = 1:length(toLabel);
    if isempty(toLabel{i});
        toLabel{i} = '';
    end
end

for i = 1:numDoses;
    toLabel{i*2} = dosages{i};
end


for i = 1:numImages
    trialType = allTrialTypes{i};
    subplot(length(allTrialTypes),1,i);
    for k = 1:length(drugTypes);
        drug = drugTypes{k};
        plotMeans = []; plotErrors = [];
        for j = 1:length(dosages);
            dose = dosages{j};
            plotMeans(j) = cell2mat({means.(trialType).(drug)(:).(dose)}');
            plotErrors(j) = cell2mat({errors.(trialType).(drug)(:).(dose)}');
        end
        hold on;
        errorbar(xCoords,plotMeans,plotErrors);

        if ~isempty(params.limits);
            ylim(params.limits);
        end

        title(trialType);
        set(gca,'XTickLabel',toLabel);
        legend(drugTypes);
    end
    
    if i == round(length(allTrialTypes)/2);
        yLabel = yLabeler;
        ylabel(yLabel);
    end
    
end 

if nargout == 1;
    varargout{1} = means;
elseif nargout == 2;
    varargout{1} = means;
    varargout{2} = errors;
end
    
    
    




