% --------------------------------
% load in files
% --------------------------------
startDir = '/Volumes/My Passport/NICK/Chang Lab 2016/repositories/doug/';
umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/doug/data/OTN/time_efix'; %change this to where your files are located
[allTimes,allEvents] = getFilesDoug(umbrellaDirectory); % load all files

% --------------------------------
% define global parameters
% --------------------------------

global toExamine;

toExamine = 'average duration'; %'proportion', 'raw counts', 'average duration', or 'n images'

roiPos.minX = -10e3;
roiPos.maxX = 10e3;
roiPos.minY = -10e3;
roiPos.maxY = 10e3;

wholePos.minX = -10e3;
wholePos.maxX = 10e3;
wholePos.minY = -10e3;
wholePos.maxY = 10e3;

allBlockStarts = [0 150e4 300e4 450e4 600e4 750e4 900e4 1050e4];
allBlockEnds = allBlockStarts(:) + 60e4;

allTrialTypes = {'scrambled','people','monkeys','outdoors','animals'}; %define the images you want to isolate

% --------------------------------
% get all relevant data
% --------------------------------

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
            error('missing block');
        end
        
        [timesWithinBounds,fixedEvents] = fixLengths2(timesWithinBounds,allEvents);
        
        if ~isempty(concatenateData(timesWithinBounds));            
            
            [roiData] = getDur2(timesWithinBounds,fixedEvents,roiPos);
            [wholeFaceData] = getDur2(timesWithinBounds,fixedEvents,wholePos);
            
            proportion = roiData.nFixations/wholeFaceData.nFixations;
            
            roiData.proportion = proportion; wholeFaceData.proportion = proportion;
            
            saveData{step,j} = {roiData,wholeFaceData};
            step = step+1;
        
        end           
    end
end

%% 
% --------------------------------
% construct matrix and plot
% --------------------------------

M = genTable(saveData,'roi',toExamine); 

Limits = [0 15e3];

barPlots(M,'all',allTrialTypes);
    
