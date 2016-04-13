%%
startDir = '/Volumes/My Passport/NICK/Chang Lab 2016/repositories/doug';
cd(startDir);
%
% --------------------------------
% -- define global variables --
% --------------------------------

global addPupilData;
global pupil;
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
analysisVersion = 'new'; %or 'old'
addPupilData = 1;

% monkeys = {'Lager'};
% monkeys = {'Joda'};
monkeys = {'Lager','Joda','Coppola'};
drugTypes = {'OT','N','OTN'};
% drugTypes = {'N'};  
dosages = {'small','medium','large','saline'};
% dosages = {'medium'};

%toExamine = 'proportions','meanLookingDuration','meanFixEventDuration','nImages',
%'nFixations','pupilSize','lookingDuration','fixEventDuration'

region = 'image'; %image, screen, eyes
allPos = lookingCoords;

allBlockStarts = [0 300e4 600e4 900e4];
allBlockEnds = allBlockStarts(:) + 300e4;
% allBlockStarts = 0;
% allBlockEnds = 1000e5;

allTrialTypes = {'scrambled','people','monkeys','outdoors','animals'};

% --------------------------------
% -- get data and data ids --
% --------------------------------

if strcmp(analysisVersion,'old');
    [allSaveData] = analysisPortion2;
elseif strcmp(analysisVersion,'new');
    [new_saveData,labels] = analysisPortion2;
end

% cd('/Volumes/My Passport/for_doug/for_doug2');
cd('/Volumes/My Passport/NICK/Chang Lab 2016/doug/pupil_stuff');
saveStr = sprintf('%s.mat',region);

save(saveStr,'new_saveData','labels');

%%
toExamine = 'nImages';
region = 'eyes';
images = reformatSaveData(allSaveData);

% [values,labels] = format_anova(images,1);

%% plot w/ time on x-axis

[means,errors] = plot_over_time_per_stimulus(images,'N','limits',[]);

%% plot w/ dose on x-axis
 
[means,errors] = plot_over_dose_per_stimulus(images,'limits',[]); 
% [means,errors] = plot_over_dose_per_stimulus(normalized); 

%%
normalized = getNormalizedProportion(images,'saline','normMethod','divide');
% M = genTableLoop(allSaveData,region); %extract wanted data based on toExamine 