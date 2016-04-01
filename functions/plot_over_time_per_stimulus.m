function varargout = plot_over_time_per_stimulus(images,wantedDrug,varargin)

global toExamine;
global allTrialTypes;
global drugTypes;
global dosages;

whatToPlot = 'perDose'; %change this to per-drug if you want ...
varCol = 3; %which column stores the variance
numBlocks = length(images.(allTrialTypes{1}).(drugTypes{1}));

if numBlocks == 1;
    error(['The images struct contains only one block''s worth of data. Re-run' ...
        , ' the analysis script with at least two blocks. Alternatively, use' ... 
        , ' ''plot_over_dose_per_stimulus.m'' to look at non-segmented data.']);
end

% -- define default values for optional inputs

params = struct( ...
    'debug',0, ...
    'limits',[] ...
    );

% -- parse optional inputs

params = structInpParse(params,varargin);

% -- error messages

checkDrug = strncmpi(wantedDrug,drugTypes,length(wantedDrug));
if sum(checkDrug) == 0;
    error(['The specified drug ''%s'' isn''t present in the images struct. Re-run' ...
        , ' the analysis script with ''%s'' as a drugType.'],wantedDrug,wantedDrug);
end

switch whatToPlot
    
    case 'perDrug'

    % -- get mean across dosages

    for i = 1:length(allTrialTypes);
        trialType = allTrialTypes{i};
        for k = 1:length(drugTypes);
            drug = drugTypes{k};
            for h = 1:numBlocks
                storePerDose = [];
                for j = 1:length(dosages);
                    dose = dosages{j};
                    if j == 1;
                        storePerDose = images.(trialType).(drug)(h).(dose);
                        if isempty(storePerDose) & ~params.debug;
                            error(['Data is missing for ''%s'' images in block %d of %s trials. Try rerunning' ...
                        , ' the analysis script with fewer blocks.'],trialType,h,drug);
                        end
                    else
                        newDose = images.(trialType).(drug)(h).(dose);
                        if isempty(newDose) & ~params.debug;
                            error(['Data is missing for ''%s'' images in block %d of %s trials. Try rerunning' ...
                        , ' the analysis script with fewer blocks.'],trialType,h,drug);
                        end
                        storePerDose = vertcat(storePerDose,newDose);
                    end
                end

                if (any(isnan(storePerDose)) | isempty(storePerDose(:,1))) & ~params.debug
                    error(['Data is missing for ''%s'' images in block %d of %s trials. Try rerunning' ...
                        , ' the analysis script with fewer blocks.'],trialType,h,drug);
                else
                    storePerDose(isnan(storePerDose)) = 0;
                end

                if size(storePerDose,2) > 1 % get means and standard errors
%                     avg = mean(storePerDose(:,1));
%                     stdError = sqrt(mean(storePerDose(:,varCol)))/sqrt(length(storePerDose(:,varCol)));
                    [avg,stdError] = multiMeans(storePerDose);
                    means.(trialType).(drug)(h) = avg;
                    errors.(trialType).(drug)(:,h) = stdError;
                else
                    avg = mean(storePerDose);
                    stdError = SEM(storePerDose);
                    means.(trialType).(drug)(h) = avg;
                    errors.(trialType).(drug)(:,h) = stdError;                
                end

            end
        end
    end

    % -- plot

    xCoords = 1:length(means.(allTrialTypes{1}).(drugTypes{1}));

    for i = 1:length(allTrialTypes);
        trialType = allTrialTypes{i};
        subplot(length(allTrialTypes),1,i);
        for j = 1:length(drugTypes);
            hold on;
            drug = drugTypes{j};

            plotMeans = means.(trialType).(drug);
            plotErrors = errors.(trialType).(drug);

            errorbar(xCoords,plotMeans,plotErrors);
            
            if ~isempty(params.limits);
                ylim(params.limits);
            end
            
            title(trialType);
        end
        legend(drugTypes);
        
        if i == round(length(allTrialTypes)/2);
            yLabel = yLabeler;
            ylabel(yLabel);
        end
        
    end
    
    case 'perDose'

    % -- get means within dosages
        
    for i = 1:length(allTrialTypes);
        trialType = allTrialTypes{i};
%         drug = drugTypes{1};
        drug = wantedDrug;
        if i == 1
%         warning(['\nOnly data from drug ''%s'' are being plotted, since this is the first drug' ...
%             , ' in ''drugTypes''. If this isn''t the drug you''re interested in, rerun the script' ...
%             ' with the desired drug as the first element of ''drugTypes''.'],drugTypes{1});
        end
        for k = 1:length(dosages);
            dose = dosages{k};
            for h = 1:numBlocks
                oneDose = images.(trialType).(drug)(h).(dose);
                
                if (any(isnan(oneDose)) | isempty(oneDose)) & ~params.debug
                    error(['Data is missing for ''%s'' images in block %d of %s trials. Try rerunning' ...
                        , ' the analysis script with fewer blocks.'],trialType,h,drug);
                else
                    oneDose(isnan(oneDose)) = 0;
                end
                
                if size(oneDose,2) > 1;
                    [avg,stdError] = multiMeans(oneDose);
%                     avg = mean(oneDose(:,1));
%                     stdError = sqrt(mean(oneDose(:,varCol)))/sqrt(length(oneDose(:,varCol)));
                else
                    avg = mean(oneDose);
                    stdError = SEM(oneDose);
                end
            means.(trialType).(drug)(h).(dose) = avg;
            errors.(trialType).(drug)(h).(dose) = stdError;
            end
        end
    end
    
    % -- plot
    
%     xCoords = 1:length(means.(allTrialTypes{1}).(drugTypes{1}));
    xCoords = 1:length(means.(allTrialTypes{1}).(wantedDrug));
    
    for i = 1:length(allTrialTypes);
        trialType = allTrialTypes{i};
        subplot(length(allTrialTypes),1,i);
        for j = 1:length(dosages);
            dose = dosages{j};
            hold on;
            plotMeans = cell2mat({means.(trialType).(drug)(:).(dose)}');
            plotErrors = cell2mat({errors.(trialType).(drug)(:).(dose)}');
            
            errorbar(xCoords,plotMeans,plotErrors);
            
            if ~isempty(params.limits);
                ylim(params.limits);
            end
            
            title(trialType);
        end
        legend(dosages)
        
        if i == round(length(allTrialTypes)/2);
            yLabel = yLabeler;
            ylabel(yLabel);
        end
        
    end          
         
end %end switch

% ylabel(toExamine);
xlabel('Block Number');

if nargout == 1;
    varargout{1} = means;
elseif nargout == 2;
    varargout{1} = means;
    varargout{2} = errors;
end
    
        
    
    
    