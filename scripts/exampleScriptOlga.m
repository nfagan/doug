%%
startDir = '/Volumes/My Passport/NICK/Chang Lab 2016/repositories/doug';
cd(startDir);
%%
% --------------------------------
% -- define global variables --
% --------------------------------

global analysisVersion;
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
analysisVersion = 'old'; %or 'old'

monkeys = {'Coppola','Lager','Joda'};
drugTypes = {'OT','N','OTN'};
dosages = {'small','medium','large','saline'};

%toExamine = 'proportions','meanLookingDuration','meanFixEventDuration','nImages',
%'nFixations','pupilSize','lookingDuration','fixEventDuration'

region = 'eyes'; %image, screen
allPos = lookingCoords;

% allBlockStarts = [0 300e4 600e4 900e4];
% allBlockEnds = allBlockStarts(:) + 300e4;
allBlockStarts = 0;
allBlockEnds = 1000e5;

allTrialTypes = {'scrambled','people','monkeys','outdoors','animals'};

% --------------------------------
% -- get data and data ids --
% --------------------------------

% [new_saveData,labels] = analysisPortion2;
[allSaveData] = analysisPortion2;

%%
toExamine = 'proportions';
region = 'eyes';
images = reformatSaveData(allSaveData);

% [values,labels] = format_anova(images,1);

%% plot w/ time on x-axis

[means,errors] = plot_over_time_per_stimulus(images,'N');

%% plot w/ dose on x-axis
 
% [means,errors] = plot_over_dose_per_stimulus(images); 
[means,errors] = plot_over_dose_per_stimulus(normalized); 

%%
normalized = getNormalizedProportion(images,'saline','normMethod','divide');
% M = genTableLoop(allSaveData,region); %extract wanted data based on toExamine 