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
compName = 'nick';

monkeys = {'Lager','Lager'};
drugTypes = {'OT','N'};
dosages = {'small','medium','large','saline'};

%'proportions','meanLookingDuration','meanFixEventDuration','nImages','nFixations'
region = 'roi';

allPos = lookingCoords('roi to whole face'); %'whole picture to whole screen'
allBlockStarts = [0 300e4 600e4 900e4];
allBlockEnds = allBlockStarts(:) + 300e4;
% allBlockStarts = 0;
% allBlockEnds = 1000e5;

allTrialTypes = {'scrambled','people','monkeys','outdoors','animals'};

saveData = analysisPortion; %get all data per monkey
allSaveData = acrossMonkeys(saveData); %combine across monkeys

%%
toExamine = 'nImages';
images = reformatSaveData(allSaveData);

%% plot w/ time on x-axis

[means,errors] = plot_over_time_per_stimulus(images,'N');

%% plot w/ dose on x-axis
 
[means,errors] = plot_over_dose_per_stimulus(images); 

%%
normalized = getNormalizedProportion(images,'saline','normMethod','divide');
% M = genTableLoop(allSaveData,region); %extract wanted data based on toExamine 