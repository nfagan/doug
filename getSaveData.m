function saveData = getSaveData(allTimes,allEvents)

global allTrialTypes;
global allBlockStarts;
global allBlockEnds;
global allPos;

saveData = cell(1,1);
for j = 1:length(allTrialTypes);
    
    trialType{1} = allTrialTypes{j};
    wantedTimes = getTrials(allTimes,trialType); %only output the display times associated with the images we're interested in
    
    step = 1;
    
    for k = 1:length(allBlockStarts);

        blockStart = allBlockStarts(k); %per block, only get the times that fall within these time bounds - from block start to block end
        blockEnd = allBlockEnds(k); %one hour, in ms
        timesWithinBounds = timeBounds(wantedTimes,[blockStart blockEnd]);
        
        ind = checkEmpty(timesWithinBounds);
        
        if ~isempty(ind);
            error('No %s images were displayed during block %d',char(trialType),k);
        end
        
        [timesWithinBounds,fixedEvents] = fixLengths2(timesWithinBounds,allEvents);
            
        storeFix = zeros(2); toSave = cell(1,2);
        for i = 1:2;
            data = getDur2(timesWithinBounds,fixedEvents,allPos{i});
            storeFix(i) = data.nFixations;
            toSave{i} = data;
        end

        toSave{1}.proportion = storeFix(1)/storeFix(2);
        toSave{2}.proportion = storeFix(1)/storeFix(2);

        saveData{step,j} = toSave;
        step = step+1;
 
    end
end

