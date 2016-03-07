function [storePerImage,d] = newPlot(M,varargin)

global drugTypes;
global dosages;
global allTrialTypes;

params = struct(... %default values of params struct
    'lineType','per stim', ...
    'xAxis','dose', ...
    'treatNaNs','error' ... 
    );    

params = structInpParse(params,varargin);

M2 = M;

storePerImage = cell(length(M2),1);
for i = 1:length(M2); % for each image ...
    
    if strcmp(params.xAxis,'dose');
        meanPerImage = zeros(size(M2{1},1),size(M2{1},2));
        for j = 1:size(M2{1},1);
            for k = 1:size(M2{1},2);                
                drugDose = M2{i}{j,k};                
                if sum(isnan(drugDose)) > 1;
                    
                    warning(['\nIMAGES: %s\nDOSE: %s\nDRUG: %s\nThese trials have %d blocks of empty data.' ...
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
                    if strcmp(params.treatNaNs,'meanReplace');
                        tempMean = nanmean(drugDose(:,k));
                        drugDose(checkNans,k) = tempMean;
                    elseif strcmp(params.treatNaNs,'zeroReplace');
                        drugDose(checkNans,k) = 0;
                    else
                        if strcmp(params.treatNaNs,'error');
                            error(['\nIMAGES: %s\nDOSE: %s\nDRUG: %s\nThese trials have %d blocks of empty data.' ...
                        , ' Cannot plot across time with these images!'],...
                        char(allTrialTypes{i}),dosages{k},drugTypes{j},sum(isnan(drugDose(:,k))));
                    
                        end
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

if strcmp(params.lineType,'per stim') && strcmp(params.xAxis,'dose');
    for i = 1:length(storePerImage);
        plot(storePerImage{i}')
    end;
end

if strcmp(params.lineType,'per stim') && strcmp(params.xAxis,'time');
end
    

% d = concatenateData(storePerImage);
% 
% % if strcmp(params.lineType,'per drug') && strcmp(params.xAxis,'time');    
% %     for i = 1:size(d,2);
% %         perDrug = reshape(d(:,i),size(M2{1}{1,1},1),length(storePerImage));
% %         storeMeans(:,i) = mean(perDrug,2);
% %     end            
% % end
% 
% if strcmp(params.lineType,'per drug') && strcmp(params.xAxis,'dose');
%     
%     for i = 1:length(drugTypes):size(d,1);        
%         perImg = d(i:length(drugTypes):end,:);               
%         subplot(10,3,i);
%         plot(perImg');
%     end
%     
% end


    









        
    