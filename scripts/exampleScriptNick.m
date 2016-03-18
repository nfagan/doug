% --------------------------------
% -- define global variables --
% --------------------------------

global monkeys;
global drugTypes;
global dosages;
global toExamine;
global allTrialTypes;
global allBlockStarts;
global allBlockEnds;
global allPos;
global compName;

% --------------------------------
% -- master inputs -- 
% --------------------------------

compName = 'nick';
monkeys = {'Coppola'};
drugTypes = {'OTN_2','OT_test'};
dosages = {'small','medium','large'};

toExamine = 'raw counts'; %'proportion', 'normalized proportion' 'raw counts', 'average duration', or 'n images'
region = 'roi';

lineType = 'per stim';
xAxis = 'dose';

roiPos.minX = 620;
roiPos.maxX = 980;
roiPos.minY = 345;
roiPos.maxY = 495;

wholePos.minX = 600;
wholePos.maxX = 1000;
wholePos.minY = 250;
wholePos.maxY = 650;

allPos = {roiPos,wholePos};
% allBlockStarts = [0 150e4 300e4 450e4 600e4 750e4 900e4 1050e4];
allBlockStarts = [0 300e4 600e4 900e4];
allBlockEnds = allBlockStarts(:) + 60e4;

allTrialTypes = {'nonConspecific','people','monkeys','outdoors','animals'}; %define the images you want to isolate
% if toExamine is 'normalized proportion', make sure first allTrialTypes is 'scrambled'

% --------------------------------
%  -- analysis portion -- 
% --------------------------------

M = cell(length(allTrialTypes),1);
M2 = cell(length(allTrialTypes),1);
for ii = 1:length(monkeys); % for each monkey ...
    monkey = monkeys{ii};
    for i = 1:length(allTrialTypes); % for each image ...
        fprintf('\nIMAGE: %d of %d (%s)',i,length(allTrialTypes),allTrialTypes{i});
        trialType = {allTrialTypes{i}};
        for j = 1:length(drugTypes); % for each drug ...
            fprintf('\n\tDRUG: %d of %d (%s)',j,length(drugTypes),drugTypes{j});
            for k = 1:length(dosages); % for each dose ...
            fprintf('\n\t\tDOSE: %d of %d (%s)',k,length(dosages),dosages{k});
            
            % -- load in files --
            
            [umbrellaDirectory,doseNames{k}] = getUmbrDir(monkey,drugTypes{j},dosages{k});
            [allTimes,allEvents] = getFilesDoug(umbrellaDirectory); % load all files
            
            % -- get all relevant data --
            saveData{ii}{i}{j,k} = getSaveData(allTimes,allEvents,trialType);
%             saveData{i}{j,k} = getSaveData(allTimes,allEvents,trialType);
            end
        end
    end
end

% -- combine across monkeys --

fprintf('\nCombing across monkeys ...');
allSaveData = acrossMonkeys(saveData);
fprintf('\nDone!\n');
%% generate table
toExamine = 'proportion';
for i = 1:length(allTrialTypes);
    for j = 1:length(drugTypes);
        for k = 1:length(dosages);
            % --------------------------------
            % construct matrix and plot
            % --------------------------------
            M{i}{j,k} = genTable(allSaveData{i}{j,k},region);
        end
    end
end
%%
% --------------------------------
% plot
% --------------------------------
storePerImage = newPlot(M,'lineType','per stim','xAxis','dose','treatNaNs','default','doseNames',...
    doseNames,'limits',[],'subplotPerDrug',1);