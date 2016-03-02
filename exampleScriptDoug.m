% --------------------------------
% load in files
% --------------------------------
startDir = '/Volumes/My Passport/NICK/Chang Lab 2016/repositories/doug/';
umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/doug/data/OTN/time_efix'; %change this to where your files are located
[allTimes,allEvents] = getFilesDoug(umbrellaDirectory); % load all files

% --------------------------------
% define global parameters
% --------------------------------

runGroups = {'Coopola0.5N','Coppola1N'};

global toExamine;

toExamine = 'proportion'; %'proportion', 'raw counts', 'average duration', or 'n images'

roiPos.minX = 620;
roiPos.maxX = 980;
roiPos.minY = 345;
roiPos.maxY = 495;

wholePos.minX = 600;
wholePos.maxX = 1000;
wholePos.minY = 250;
wholePos.maxY = 650;

allBlockStarts = [0 150e4 300e4 450e4 600e4 750e4 900e4 1050e4];
allBlockEnds = allBlockStarts(:) + 60e4;

allTrialTypes = {'scrambled','people','monkeys','outdoors','animals'}; %define the images you want to isolate
% if toExamine is 'normalized proportion', make sure first allTrialTypes is
% 'scrambled

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

barPlots(M,'all',allTrialTypes); %per stimulus, per block, all
    
