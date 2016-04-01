%first output is always looking duration associated with each image
%presentations; if there is only one additional output specified (2 total), 
%it will be pupil size; if there are two additional outputs specified (3
%total), the outputs will be pupil size and the duration of the first
%looking event - in that order!

function data = getDur(wantedTimes,allEvents,pos)

if nargin < 3; %default values, if pos isn't specified

    minX = -10e3;
    maxX = 10e3;
    minY = -10e3;
    maxY = 10e3;
    
else
    
    minX = pos.minX;
    maxX = pos.maxX;
    minY = pos.minY;
    maxY = pos.maxY;
    
end

nFixationsPerImagePerFile = cell(1,length(wantedTimes));
fixEventDursPerImagePerFile = cell(1,length(wantedTimes));
durPerImagePerFile = cell(1,length(wantedTimes));
meanDurFixEventPerImagePerFile = cell(1,length(wantedTimes));
semDurFixEventPerImagePerFile = cell(1,length(wantedTimes));

for i = 1:length(wantedTimes);
    
    oneTimes = wantedTimes{i}; %get one file's timing info
    oneFixEvents = allEvents{i}; %get one file's fixation events
    
    fixStarts = oneFixEvents(:,1); %separate columns of fixation events for clarity; start of all fixations
    fixEnds = oneFixEvents(:,2); %end of all fixations
    dur = oneFixEvents(:,3); %durations
    x = oneFixEvents(:,4);
    y = oneFixEvents(:,5);
    pupSize = oneFixEvents(:,6);
    
    rowN = 1:length(fixStarts); %for indexing
    step = 1; %for saving per image
    
    nFixationsPerImage = cell(1,length(oneTimes));
    fixEventDursPerImage = cell(1,length(oneTimes));
    durPerImage = cell(1,length(oneTimes));    
    meanDurFixEventPerImage = cell(1,length(oneTimes));    
    semDurFixEventPerImage = cell(1,length(oneTimes));
    
    for j = 1:size(oneTimes,1); %for each image display time ...
        
        if oneTimes(j,2) < max(fixEnds); % if
            
            startEndTimes = [oneTimes(j,1) oneTimes(j,2)];
            timeIndex = zeros(1,2); firstLastDur = zeros(1,2);        

            for k = 1:2;

                toFindTime = startEndTimes(k);        
                testIndex = toFindTime >= fixStarts & toFindTime <= fixEnds;                      

                if sum(testIndex) == 1;
                    timeIndex(k) = rowN(testIndex);                
                    if k == 1;                    
                        firstLastDur(k) = fixEnds(timeIndex(k)) - toFindTime;          
                    else
                        firstLastDur(k) = toFindTime - fixStarts(timeIndex(k));
                    end
                else
                    lastGreater = find(toFindTime <= fixStarts,1,'first');
                    if k == 1;                    
                        timeIndex(k) = lastGreater;
                        firstLastDur(k) = dur(timeIndex(k));            
                    else                    
                        timeIndex(k) = lastGreater-1;
                        firstLastDur(k) = dur(timeIndex(k));
                    end
                end

            end

            startIndex = timeIndex(1);
            endIndex = timeIndex(2);

            if startIndex ~= endIndex        
                allDurs = dur(startIndex:endIndex);
                allDurs(1) = firstLastDur(1); allDurs(end) = firstLastDur(2); %replace first and last durations with adjusted durations;        
            else
                allDurs = firstLastDur(1);
            end

            allPup = pupSize(startIndex:endIndex);      
            allX = x(startIndex:endIndex);
            allY = y(startIndex:endIndex);   

            checkXBounds = allX >= minX & allX <= maxX;
            checkYBounds = allY >= minY & allY <= maxY;
            checkBounds = checkXBounds & checkYBounds;

            allDurs(~checkBounds) = [];
            allPup(~checkBounds) = [];        

            if ~isempty(allDurs);
                nFixationsPerImage{j} = length(allPup);
                meanDurFixEventPerImage{j} = mean(allDurs);
                semDurFixEventPerImage{j} = [SEM(allDurs) (std(allDurs))^.2 length(allDurs)];
                fixEventDursPerImage{step} = allDurs;
                durPerImage{step} = sum(allDurs);
                step = step+1;
%                 meanFixEventDurPerImage{step} = mean(allDurs);
%                 semFixEventDurPerImage{step} = SEM(allDurs);                
                
                
%                 forProportion{j} = length(allPup);
%                 meanDurPerImage{step} = mean(allDurs);
%                 dursPerImage{step} = sum(allDurs);
%                 sizePerImage{step} = mean(allPup);
%                 nFixPerImage{step} = length(allPup);
%                 firstLookPerImage{step} = allDurs(1);
%                 patchResidencePerImage{step} = startEndTimes(2) - startEndTimes(1);
%                 step = step+1;
            else
%                 forProportion{j} = NaN;
                nFixationsPerImage{j} = NaN;
            end
        
        end %end if
        
    end
    
    [nFixationsPerImage,fixEventDursPerImage,durPerImage] = ...
        concatenateData(nFixationsPerImage,fixEventDursPerImage,durPerImage);
    
    [meanDurFixEventPerImage,semDurFixEventPerImage] = concatenateData(...
        meanDurFixEventPerImage,semDurFixEventPerImage);
    
    meanDurFixEventPerImagePerFile{i} = meanDurFixEventPerImage;
    semDurFixEventPerImagePerFile{i} = semDurFixEventPerImage;
    
    nFixationsPerImagePerFile{i} = nFixationsPerImage;
    fixEventDursPerImagePerFile{i} = fixEventDursPerImage;
    durPerImagePerFile{i} = durPerImage;
    
%     [dursPerImage,sizePerImage,nFixPerImage,firstLookPerImage,patchResidencePerImage] = ...
%         concatenateData(dursPerImage,sizePerImage,nFixPerImage,firstLookPerImage,patchResidencePerImage);
%     
%     meanDurPerImage = concatenateData(meanDurPerImage);
%     forProportion = concatenateData(forProportion);
%     
%     forPropPerFile{i} = forProportion;
%     meanDurPerFile{i} = meanDurPerImage;
%     patchResidencePerFile{i} = patchResidencePerImage;
%     dursPerFile{i} = mean(dursPerImage); %this is new; before, was simply = dursPerImage
%     sizePerFile{i} = sizePerImage;
%     nFixPerFile{i} = mean(nFixPerImage); %this is new; before, was simply = nFixPerImage
%     firstLookPerFile{i} = firstLookPerImage;    
    
end

%%% new outputs

[nFixationsPerImagePerFile,fixEventDursPerImagePerFile,durPerImagePerFile] = ...
    concatenateData(nFixationsPerImagePerFile,fixEventDursPerImagePerFile,durPerImagePerFile);

[meanDurFixEventPerImagePerFile,semDurFixEventPerImagePerFile] = ...
    concatenateData(meanDurFixEventPerImagePerFile,semDurFixEventPerImagePerFile);

data.nImages = length(durPerImagePerFile);
data.forProportion = nFixationsPerImagePerFile;
data.nFixationsPerImage = nFixationsPerImagePerFile(~isnan(nFixationsPerImagePerFile));
data.meanLookingDuration = [mean(durPerImagePerFile) SEM(durPerImagePerFile) (std(durPerImagePerFile)).^2 ...
    length(durPerImagePerFile)];
% data.semLookingDuration = SEM(durPerImagePerFile);
data.meanDurationFixEvent = [mean(fixEventDursPerImagePerFile) SEM(fixEventDursPerImagePerFile) (std(fixEventDursPerImagePerFile)).^2 ...
    length(fixEventDursPerImagePerFile)];
% data.semDurationFixEvent = SEM(fixEventDursPerImagePerFile);
data.meanDurationFixEventPerImage = [meanDurFixEventPerImagePerFile semDurFixEventPerImagePerFile];
% data.semDurationFixEventPerImage = semDurFixEventPerImagePerFile;
% 
% 
% 
% 
% saveMeanDur = concatenateData(meanDurPerFile);
% [saveDurs,savePupil,saveNFix,saveFirstLook] = concatenateData(dursPerFile,sizePerFile,nFixPerFile,firstLookPerFile);
% savePatchResidence = concatenateData(patchResidencePerFile);
% saveProp = concatenateData(forPropPerFile);
% 
% %%%% outputs
% data.nImages = length(saveMeanDur);
% data.nSessions = i;
% data.forProportion = saveProp;
% data.meanDuration = saveMeanDur;
% data.allDurations = saveDurs;
% data.firstLook = saveFirstLook;
% data.pupilSize = savePupil;
% % data.nFixations = sum(saveNFix);
% data.nFixations = saveNFix;
% data.patchResidence = savePatchResidence;

end %end monkey number loop
