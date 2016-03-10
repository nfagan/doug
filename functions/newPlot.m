function [storePerImage] = newPlot(M,varargin)

global toExamine;
global drugTypes;
global dosages;
global allTrialTypes;

params = struct(... %default values of params struct
    'lineType','per stim', ...
    'xAxis','dose', ...
    'treatNaNs',{'default'}, ...
    'limits',[], ...
    'doseNames',[], ...
    'subplotPerDrug',0 ...
    );    

params = structInpParse(params,varargin);

%%% fix treatNaNs if necessary

if ~iscell(params.treatNaNs);
    params.treatNaNs = {params.treatNaNs};
end

%%% add warning for meanReplace

if strcmp(params.treatNaNs,'meanReplace');
    warning(['Replacing missing values with mean values isn''t recommended.' ...
        , ' This feature is mainly for troubleshooting purposes - to confirm' ...
        , ' that plotting over time is working as it should. You should probably' ...
        , ' change ''meanReplace'' to ''default''.']);
end

M2 = M;

storePerImage = cell(length(M2),1);
for i = 1:length(M2); % for each image ...
    
    if strcmp(params.xAxis,'dose');
        meanPerImage = zeros(size(M2{1},1),size(M2{1},2));
        for j = 1:size(M2{1},1);
            for k = 1:size(M2{1},2);                
                drugDose = M2{i}{j,k};                
                if sum(isnan(drugDose)) >= 1;
                    
                    warning(['\nIMAGES: %s\nDOSE: %s\nDRUG: %s\nThese trials have %d block(s) of empty data.' ...
                        , ' Data will be averaged with NaNs removed.'],...
                        char(allTrialTypes{i}),dosages{k},drugTypes{j},sum(isnan(drugDose)));
                    
                    if sum(isnan(drugDose)) == length(drugDose);
                        error('IMAGES: %s. No data exists for these images. Rerun exampleScript with these images removed.',allTrialTypes{i});
                    end
                    
                end               
                meanPerImage(j,k) = nanmean(M2{i}{j,k});
            end            
        end
        storePerImage{i} = meanPerImage;
    end
    
    if strcmp(params.xAxis,'time');
        crossDrug = cell(size(M2{1},1),1);
        for j = 1:size(M2{1},1);
            drugDose = [];
            for k = 1:size(M2{1},2);        
                if k ==1;
                    drugDose = M2{i}{j,k};
                else                    
                    drugDose = horzcat(drugDose,M2{i}{j,k});
                end                

                checkNans = isnan(drugDose(:,k));
                
                if any(checkNans);
                    if sum(checkNans) < length(checkNans)
                        if strcmp(params.treatNaNs{1},'meanReplace');
                            tempMean = nanmean(drugDose(:,k));
                            drugDose(checkNans,k) = tempMean;
                        elseif strcmp(params.treatNaNs{1},'valReplace');
                            drugDose(checkNans,k) = params.treatNaNs{2};
                        else
                            if strcmp(params.treatNaNs{1},'default');
                                error(['\nIMAGES: %s\nDOSE: %s\nDRUG: %s\nThese trials have %d block(s) of empty data.' ...
                            , ' Cannot plot across time with these images!'],...
                            char(allTrialTypes{i}),dosages{k},drugTypes{j},sum(isnan(drugDose(:,k))));

                            end
                        end
                    else
                        error(['\nIMAGES: %s\nDOSE: %s\nDRUG: %s\nThese trials have all %d blocks of empty data.' ...
                            , ' Cannot plot across time with these images, nor can values be replaced!'],...
                            char(allTrialTypes{i}),dosages{k},drugTypes{j},sum(isnan(drugDose(:,k))));
                    end                        
                end            
            end
            crossDose = nanmean(drugDose,2);
            crossDrug{j} = crossDose;
        end       
        
    crossDrug = reshape(concatenateData(crossDrug),size(M2{1}{1,1},1),size(M2{1},1));
    
    if strcmp(params.lineType,'per stim')
        storePerImage{i} = mean(crossDrug,2);
    else
        storePerImage{i} = crossDrug;
    end    
    
    end %end ... time

end

% --------------------------------
% first get labels, etc.
% --------------------------------

switch toExamine
    case 'average duration'
        toYLabel = 'Average Duration of Fixation Event (ms)';
    case 'proportion'
        toYLabel = 'Proportion of Fixations ROI : Whole Face';
    case 'raw counts'
        toYLabel = 'Number of Fixations';
    case 'n images'
        toYLabel = 'Number of Images Seen';
end

% --------------------------------
% plot
% --------------------------------

if strcmp(params.lineType,'per stim') && strcmp(params.xAxis,'dose') && ...
        params.subplotPerDrug
    hold on;
    for j = 1:size(storePerImage{1},1)
        subplot(size(storePerImage{1},1),1,j);
        title(drugTypes{j});
        for i = 1:length(storePerImage)
            hold on;
            plot(1:size(storePerImage{i},2),storePerImage{i}(j,:));
            set(gca,'xtick',1:length(dosages));
            if ~isempty(params.doseNames) && length(drugTypes) == 1;
                set(gca,'xticklabel',params.doseNames);
            else                        
                set(gca,'xticklabel',dosages);
            end
            if ~isempty(params.limits);
                ylim(params.limits);
            end
        end
    end    
    xlabel('Dose');
    ylabel(toYLabel);
    legend(allTrialTypes);
else

if strcmp(params.lineType,'per stim')
    hold on;
    for i = 1:length(storePerImage);
        if strcmp(params.xAxis,'dose');
            if size(storePerImage{1},1) > 1
                plot(mean(storePerImage{i})');
                if i == 1;
                    warning(['M contains multiple drugs'' worth of data. What''s plotted' ...
                    , ' will be an average across these!']);
                end
            else
                plot(storePerImage{i}');
            end
            set(gca,'xtick',1:length(dosages));
            if ~isempty(params.doseNames) && length(drugTypes) == 1;
                set(gca,'xticklabel',params.doseNames);
            else                        
                set(gca,'xticklabel',dosages);
            end            
            xlabel('Dose');
        elseif strcmp(params.xAxis,'time');
            plot(storePerImage{i});
            xlabel('Block Number');
        end
    end;
    legend(allTrialTypes);
    ylabel(toYLabel);
    
    if ~isempty(params.limits);
        ylim(params.limits);
    end
    
end

if strcmp(params.lineType,'per drug');
    hold on;
    for i = 1:length(storePerImage);
        oneImage = storePerImage{i};
        subplot(length(storePerImage),1,i);
            if strcmp(params.xAxis,'dose');
                plot(oneImage');
                set(gca,'xtick',1:length(dosages));
                if i == length(storePerImage);
                    xlabel('Dose');
                    if ~isempty(params.doseNames) && length(drugTypes) == 1;
                        set(gca,'xticklabel',params.doseNames);
                    else                        
                        set(gca,'xticklabel',dosages);
                    end
                end
            elseif strcmp(params.xAxis,'time');
                plot(oneImage);
                if i == length(storePerImage);
                    xlabel('Block Number');
                end
            end
            
            if i == round(length(storePerImage)/2);
                ylabel(toYLabel);
            end            
            title(allTrialTypes{i});   
            
            if ~isempty(params.limits);
                ylim(params.limits);
            end
    end
    legend(drugTypes);
end

end









        
    