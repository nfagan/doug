%first output is always looking duration associated with each image
%presentations; if there is only one additional output specified (2 total), 
%it will be pupil size; if there are two additional outputs specified (3
%total), the outputs will be pupil size and the duration of the first
%looking event - in that order!

function data = getDur_new(wantedTimes,allEvents,pos,pupil)

global addPupilData;

addFixEventPupilSize = 0;

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
pupilPerImagePerFile = cell(1,length(wantedTimes));
pupilSizePerImagePerFile = cell(1,length(wantedTimes));
pupilSizePerFixEventPerFile = cell(1,length(wantedTimes));

for i = 1:length(wantedTimes);
    
    onePupil = pupil{i}.pupil;
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
    
    pupilSizePerFixEvent = cell(1,length(oneTimes));
    nFixationsPerImage = cell(1,length(oneTimes));
    fixEventDursPerImage = cell(1,length(oneTimes));
    durPerImage = cell(1,length(oneTimes));    
    meanDurFixEventPerImage = cell(1,length(oneTimes));    
    semDurFixEventPerImage = cell(1,length(oneTimes));
    pupilPerImage = cell(1,length(oneTimes));
    pupilSizePerImage = cell(1,length(oneTimes));
    
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
            
            fixEvents = [fixStarts(startIndex:endIndex) fixEnds(startIndex:endIndex)];

            allPup = pupSize(startIndex:endIndex);      
            allX = x(startIndex:endIndex);
            allY = y(startIndex:endIndex);   

            checkXBounds = allX >= minX & allX <= maxX;
            checkYBounds = allY >= minY & allY <= maxY;
            checkBounds = checkXBounds & checkYBounds;

            allDurs(~checkBounds) = [];
            allPup(~checkBounds) = [];
            fixEvents(~checkBounds,:) = [];

            if ~isempty(allDurs);
                nFixationsPerImage{j} = [length(allPup) i];
                meanDurFixEventPerImage{j} = mean(allDurs);
                semDurFixEventPerImage{j} = [SEM(allDurs) (std(allDurs))^.2 length(allDurs) i];
                fixEventDursPerImage{step} = [allDurs repmat(i,length(allDurs),1)];
                durPerImage{step} = [sum(allDurs) i];
                pupilPerImage{step} = [mean(allPup) SEM(allPup) (std(allPup))^.2 length(allPup) i];
                step = step+1;
                
                if addFixEventPupilSize && addPupilData % if getting pupil data per fixation event, with some time-lag
                    fixEventPups = cell(length(fixEvents),1);
                    for ll = 1:length(fixEvents);
                        fixEventPups{ll} = getPupilSize(onePupil,fixEvents(ll,:),150); %adjust start time of fixation event to be 150ms to allow 
                    end

                    fixEventPups = concatenateData(fixEventPups);
                    fixEventPups(:,2) = i;
                    pupilSizePerFixEvent{step} = fixEventPups;

                    else 
                        pupilSizePerFixEvent{step} = [allPup repmat(i,length(allPup),1)];
                end

            else
                nFixationsPerImage{j} = [NaN NaN];
            end
            
            if addPupilData %if adding full time-course of pupil changes (slows down code a lot)
                pupilData = getPupilSize(onePupil,startEndTimes);
                pupilSizePerImage{j} = [pupilData' i];
            else                
                pupilSizePerImage{j} = NaN;
            end
        
        end %end if
        
        
    end
    
    [nFixationsPerImage,fixEventDursPerImage,durPerImage] = ...
        concatenateData(nFixationsPerImage,fixEventDursPerImage,durPerImage);
    
    [meanDurFixEventPerImage,semDurFixEventPerImage] = concatenateData(...
        meanDurFixEventPerImage,semDurFixEventPerImage);
    
    pupilPerImage = concatenateData(pupilPerImage);
    
    meanDurFixEventPerImagePerFile{i} = meanDurFixEventPerImage;
    semDurFixEventPerImagePerFile{i} = semDurFixEventPerImage;
    
    nFixationsPerImagePerFile{i} = nFixationsPerImage;
    fixEventDursPerImagePerFile{i} = fixEventDursPerImage;
    durPerImagePerFile{i} = durPerImage;
    
    pupilPerImagePerFile{i} = pupilPerImage;
    
    pupilSizePerImagePerFile{i} = concatenateData(pupilSizePerImage);
    pupilSizePerFixEventPerFile{i} = concatenateData(pupilSizePerFixEvent);
    
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

pupilSizePerImagePerFile = concatenateData(pupilSizePerImagePerFile);

[nFixationsPerImagePerFile,fixEventDursPerImagePerFile,durPerImagePerFile] = ...
    concatenateData(nFixationsPerImagePerFile,fixEventDursPerImagePerFile,durPerImagePerFile);

[meanDurFixEventPerImagePerFile,semDurFixEventPerImagePerFile] = ...
    concatenateData(meanDurFixEventPerImagePerFile,semDurFixEventPerImagePerFile);

pupilPerImagePerFile = concatenateData(pupilPerImagePerFile);
pupilSizePerFixEventPerFile = concatenateData(pupilSizePerFixEventPerFile);

% data.pupilSize = pupilPerImagePerFile;
data.nImages = length(durPerImagePerFile);
data.forProportion = nFixationsPerImagePerFile;
if ~isempty(nFixationsPerImagePerFile);
    data.nFixationsPerImage = nFixationsPerImagePerFile(~isnan(nFixationsPerImagePerFile(:,1)),:);
else
    data.nFixationsPerImage = [];
end
data.meanLookingDuration = [mean(durPerImagePerFile) SEM(durPerImagePerFile) (std(durPerImagePerFile)).^2 ...
    length(durPerImagePerFile)];
data.meanDurationFixEvent = [mean(fixEventDursPerImagePerFile) SEM(fixEventDursPerImagePerFile) (std(fixEventDursPerImagePerFile)).^2 ...
    length(fixEventDursPerImagePerFile)];
data.meanDurationFixEventPerImage = [meanDurFixEventPerImagePerFile semDurFixEventPerImagePerFile];

data.lookingDuration = durPerImagePerFile;
data.fixEventDuration = fixEventDursPerImagePerFile;

% for n = 1:length(unique(durPerImagePerFile(:,2)));
%     nImagesPerSession(n,:) = [length(durPerImagePerFile(durPerImagePerFile(:,2) == n,:)) n];
% end
nImagesPerSession = NaN;

data.nImagesPerSession = nImagesPerSession;
data.pupilSize = pupilSizePerImagePerFile;
data.pupilSizePerFixEvent = pupilSizePerFixEventPerFile;

end %end monkey number loop
