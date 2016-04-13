function saveData = getSaveData(allTimes,allEvents,trialTypes)

global add_on;
global identifiers;
global allBlockStarts;
global allBlockEnds;
global allPos;
global monkeys;
global allTrialTypes;
global drugs;
global dosages;

saveData = cell(1,1);
for j = 1:length(trialTypes);
    
    trialType{1} = trialTypes{j};
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
            
        toSave = cell(1,2);
        for i = 1:2;
            data = getDur(timesWithinBounds,fixedEvents,allPos{i});
            toSave{i} = data;
        end
        
        toSave = getProportion(toSave,'mean');

        saveData{step,j} = toSave;
        step = step+1;
        
 
    end
end

