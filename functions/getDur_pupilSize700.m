function data = getDur_pupilSize700(wantedTimes,allEvents,pos,pupil,pupilDurThreshold)

global addPupilData;

fullTime = 1500; %ms
preImageTime = 200; %ms

add_time_course = 1;

addFixEventPupilSize = 1; % if aiming to plot PSTH-style pupil plot, where t=0 is fixation-onset
addFullTimeCourse = 1; % if looking from image onset -> image offset, irrespective of fix-events
requireStartingFixation = 0; %if looking from image onset -> some threshold

if addFullTimeCourse
    requireStartingFixation = 0;
end

if addFixEventPupilSize
    addFullTimeCourse = 0;
end

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
storePupilTimeCourse = [];

store_fix_dur_time_course = cell(length(wantedTimes),1);
store_fix_counts_time_course = cell(length(wantedTimes),1);

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
    newStp = 1; %for saving pupil data
    stp3 = 1; % for saving time course of fixation counts and duration
    
    baselinePupilSizePerFixEvent = cell(1,length(oneTimes));
    pupilSizePerFixEvent = cell(1,length(oneTimes));
    nFixationsPerImage = cell(1,length(oneTimes));
    fixEventDursPerImage = cell(1,length(oneTimes));
    durPerImage = cell(1,length(oneTimes));    
    meanDurFixEventPerImage = cell(1,length(oneTimes));    
    semDurFixEventPerImage = cell(1,length(oneTimes));
    pupilPerImage = cell(1,length(oneTimes));
    pupilSizePerImage = cell(1,length(oneTimes));
    firstFixEventPup = nan(1000,pupilDurThreshold+preImageTime);%additional one for session number
    
    for j = 1:size(oneTimes,1); %for each image display time ...
        
        if oneTimes(j,2) < max(fixEnds); % if valid display time
            
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
            
            if startIndex > endIndex
                warning('Start indices are greater than end indices. Data will be missing and skipped');
            end
            
%             if isempty(allX) || isempty(allY)
% %                 disp(startIndex); disp(endIndex);
%                 disp(allPup);
%                 disp(oneTimes(j,:));
%                 error('missing');
%             end

            checkXBounds = allX >= minX & allX <= maxX;
            checkYBounds = allY >= minY & allY <= maxY;
            checkBounds = checkXBounds & checkYBounds;

            allDurs(~checkBounds) = [];
            allPup(~checkBounds) = [];
%             fixEvents(~checkBounds,:) = [];
               
            if ~isempty(allDurs); %%% if there're fixations within the defined positional bounds ...
                if ~isempty(checkBounds);
                    if addPupilData && requireStartingFixation
                        if checkBounds(1)
                            firstEvent = fixEvents(1,:);
                            startDiff = startEndTimes(1) - firstEvent(1);
                            if sign(startDiff) == 1;
                                pupilStart = startEndTimes(1);
                                pupilEnd = firstEvent(2);
                                if (pupilEnd - pupilStart) > pupilDurThreshold
    %                                 firstFixEventPup(newStp,1:pupilDurThreshold+preImageTime) = ...
    %                                     getPupilSize(onePupil,...
    %                                     [pupilStart pupilStart+pupilDurThreshold-1],-preImageTime);%get fixation baseline
                                    firstFixEventPup(newStp,:) = ...
                                        getPupilSize(onePupil,...
                                        [pupilStart pupilStart+pupilDurThreshold-1],-preImageTime);%get fixation baseline
    %                                 firstFixEventPup(newStp,end+1) = i;
                                    newStp = newStp + 1;

                                end
                            end
                        end
                    end
                end
                
                if add_time_course
                    if ~isempty(checkBounds);
                        addFixEventPupilSize = 0;
                        time_vector = startEndTimes(1):startEndTimes(2);

                        fixation_counts_time_course = zeros(1,length(time_vector));
                        event_duration_time_course = zeros(1,length(time_vector));

                        fixEvents(~checkBounds,:) = []; %discard out-of-bounds fixEvents

                        for ti = 1:size(fixEvents,1);
                            fixation_counts_time_course(time_vector == fixEvents(ti)) = 1;
                            event_duration_time_course(time_vector == fixEvents(ti)) = allDurs(ti);
                        end                    

                        store_fix_counts_time_course{i}{stp3,1} = fixation_counts_time_course;
                        store_fix_dur_time_course{i}{stp3,1} = event_duration_time_course;
                        stp3 = stp3+1;
                    end 
                end
                
                if addFixEventPupilSize && addPupilData % if getting pupil data per fixation event, with some time-lag
                    fixEvents(~checkBounds,:) = []; %discard out-of-bounds fixEvents
                    fixEventPups = cell(length(fixEvents),1); %preallocate cells based on N Fix Events within bounds
                    baselinePup = cell(length(fixEvents),1);
                    for ll = 1:size(fixEvents,1); %for each fix event ...
                        %get pupil size from fixEventStart -> 
                        % fixEventStart + pupilDurThreshold; last input as
                        % 0 indicates that the start time isn't adjusted
%                         disp([length(fixEvents) ll fixEvents(2) max(onePupil(:,1)) min(onePupil(:,1))]);
                        fixEventPups{ll}(1,:) = getPupilSize(...
                            onePupil,[fixEvents(ll,1) (fixEvents(ll,1)+pupilDurThreshold-1)],0);
                        if ll == 1; %to save time, only get baseline-size on first loop
                            baselinePup{ll}(1,:) = getPupilSize(... %get the baseline period pupil data
                                onePupil,[(startEndTimes(1)-preImageTime+1) startEndTimes(1)],0);
                        else
                            baselinePup{ll} = baselinePup{1};
                        end
                    end
                    
                    fixEventPups = concatenateData(fixEventPups); %reformat fix-event pupil data
                    baselinePup = concatenateData(baselinePup); %reformat baseline pupil data
                    fixEventPups(:,end+1) = i; %add session id
                    fixEventPups = [baselinePup fixEventPups]; %add baseline data to fixEventPup
                    baselinePup(:,end+1) = i;
                    pupilSizePerFixEvent{step} = fixEventPups;  %store fix event size per image
                    baselinePupilSizePerFixEvent{step} = baselinePup; %store baseline size per image

                    else 
                        pupilSizePerFixEvent{step} = [allPup repmat(i,length(allPup),1)];
                        baselinePupilSizePerFixEvent{step} = [NaN i];
                end
                
                nFixationsPerImage{j} = [length(allPup) i];
                meanDurFixEventPerImage{j} = mean(allDurs);
                semDurFixEventPerImage{j} = [SEM(allDurs) (std(allDurs))^.2 length(allDurs) i];
                fixEventDursPerImage{step} = [allDurs repmat(i,length(allDurs),1)];
                durPerImage{step} = [sum(allDurs) i];
                pupilPerImage{step} = [mean(allPup) SEM(allPup) (std(allPup))^.2 length(allPup) i];
                step = step+1;

            else
                nFixationsPerImage{j} = [NaN NaN];
            end
            
            if ~isempty(checkBounds) && addPupilData && addFullTimeCourse %if adding full time-course of pupil changes (slows down code a lot)
                pupilData = getPupilSize(onePupil,...
                    [startEndTimes(1) startEndTimes(1) + fullTime],-preImageTime);
                pupilSizePerImage{j} = [pupilData' i];
%                 disp(size(pupilSizePerImage{j}));
            else                
                pupilSizePerImage{j} = nan(1,fullTime+preImageTime+2);
%                 disp(size(pupilSizePerImage{j}));
            end
        
        end %end if
        
        
    end
    
    if i == 1;
        storePupilTimeCourse = firstFixEventPup;
    else
        checkSize = size(storePupilTimeCourse);
        checkSize2 = size(firstFixEventPup);
        if checkSize ~= checkSize2
            error('sizes don''t match');
        end
        storePupilTimeCourse = [storePupilTimeCourse;firstFixEventPup];
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
    baselinePupilSizePerFixEventPerFile{i} = concatenateData(baselinePupilSizePerFixEvent);
    
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

%%% fix event counts and duration time course

fix_counts_time_course = concatenateData(concatenateData(...
    store_fix_counts_time_course));

fix_dur_time_course = concatenateData(concatenateData(...
    store_fix_dur_time_course));

%%% new outputs

baselinePupilSizePerFixEventPerFile = concatenateData(baselinePupilSizePerFixEventPerFile);

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

if size(durPerImagePerFile,2) > 1;
    for n = 1:length(unique(durPerImagePerFile(:,2)));
        nImagesPerSession(n,:) = [size(durPerImagePerFile(durPerImagePerFile(:,2) == n),1) n];
    end
else
    nImagesPerSession = [NaN NaN];
end

data.nImagesPerSession = nImagesPerSession;
data.pupilSize = pupilSizePerImagePerFile;
data.pupilSizePerFixEvent = pupilSizePerFixEventPerFile;
data.baselinePupilSizePerFixEvent = baselinePupilSizePerFixEventPerFile;

storePupilTimeCourse = [storePupilTimeCourse ones(size(storePupilTimeCourse,1),1)];
storePupilTimeCourse(isnan(storePupilTimeCourse(:,1)),:) = [];
% data.pupilTimeCourse = [storePupilTimeCourse ones(size(storePupilTimeCourse,1),1)];
data.pupilTimeCourse = storePupilTimeCourse;

%%% add new time course outputs

data.fix_counts_time_course = fix_counts_time_course;
data.fix_dur_time_course = fix_dur_time_course;

end %end function
