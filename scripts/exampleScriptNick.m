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
global region;

% --------------------------------
% -- master inputs -- 
% --------------------------------
% monkeys = {'Coppola'};
% drugTypes = {'OTN_2','OT_test'};
monkeys = {'Lager','Lager'};
drugTypes = {'OT','N'};

compName = 'nick';
dosages = {'small','medium','large','saline'};

%'proportions', 'meanLookingDuration' 'meanFixEventDuration','nImages'
toExamine = 'meanFixEventDuration';
region = 'roi';

allPos = lookingCoords('roi to whole face');
allBlockStarts = [0 300e4 600e4 900e4];
allBlockEnds = allBlockStarts(:) + 60e4;

allTrialTypes = {'scrambled','people','monkeys','outdoors','animals'};

saveData = analysisPortion; %get all data per monkey
allSaveData = acrossMonkeys(saveData); %combine across monkeys
images = reformatSaveData(allSaveData);

plot_over_time_per_stimulus(images,'perDose','debug',0);


%%
normalized = getNormalizedProportion(images,'saline','normMethod','divide');
% M = genTableLoop(allSaveData,region); %extract wanted data based on toExamine 
%%
% --------------------------------
% plot
% --------------------------------
storePerImage = newPlot(M,'lineType','per stim','xAxis','dose',...
    'treatNaNs','default','limits',[],'subplotPerDrug',1);
%%
% allBlockStarts = [0 150e4 300e4 450e4 600e4 750e4 900e4 1050e4];
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
toExamine = 'n images';
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