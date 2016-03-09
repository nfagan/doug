startDir = '/Volumes/My Passport/NICK/Chang Lab 2016/repositories/doug/';
% umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/doug/data/OTN/time_efix'; %change this to where your files are located
% --------------------------------
% define global variables
% --------------------------------

global drugTypes;
global dosages;
global toExamine;
global allTrialTypes;
global allBlockStarts;
global allBlockEnds;
global allPos;

% --------------------------------
% master inputs
% --------------------------------

monkey = 'Coppola';
drugTypes = {'OT','OTN_2'};
dosages = {'small','medium','large','saline'};

toExamine = 'average duration'; %'proportion', 'normalized proportion' 'raw counts', 'average duration', or 'n images'
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
allBlockStarts = [0 150e4 300e4 450e4 600e4 750e4 900e4 1050e4];
allBlockEnds = allBlockStarts(:) + 60e4;

allTrialTypes = {'scrambled','people','monkeys','outdoors','animals'}; %define the images you want to isolate
% if toExamine is 'normalized proportion', make sure first allTrialTypes is 'scrambled'

% --------------------------------
% analysis portion
% --------------------------------

M = cell(length(allTrialTypes),1);
for i = 1:length(allTrialTypes); % for each image ...
    fprintf('\nIMAGE: %d of %d (%s)',i,length(allTrialTypes),allTrialTypes{i});
    trialType = {allTrialTypes{i}};
for j = 1:length(drugTypes); % for each drug ...
    fprintf('\n\tDRUG: %d of %d (%s)',j,length(drugTypes),drugTypes{j});
    for k = 1:length(dosages); % for each dose ...
    fprintf('\n\t\tDOSE: %d of %d (%s)',k,length(dosages),dosages{k});
    % --------------------------------
    % load in files
    % --------------------------------
    [umbrellaDirectory,doseNames{k}] = getUmbrDir(monkey,drugTypes{j},dosages{k});
    [allTimes,allEvents] = getFilesDoug(umbrellaDirectory); % load all files
    % --------------------------------
    % get all relevant data
    % --------------------------------
    saveData{i}{j,k} = getSaveData(allTimes,allEvents,trialType);
    end
end
end
fprintf('\nDone!\n');
%% generate table
for i = 1:length(allTrialTypes);
    for j = 1:length(drugTypes);
        for k = 1:length(dosages);
            % --------------------------------
            % construct matrix and plot
            % --------------------------------
            M{i}{j,k} = genTable(saveData{i}{j,k},region);
        end
    end
end
%%
% --------------------------------
% plot
% --------------------------------
storePerImage = newPlot(M,'lineType','per drug','xAxis','time','treatNaNs','meanReplace','doseNames',doseNames,'limits',[]);

%%
% --------------------------------
% plot
% --------------------------------
limits = [];
% barPlots(M,'all',allTrialTypes); %per stimulus, per block, all
M2 = reformatData(M,'lineType',lineType,'xAxis',xAxis,'limits',limits); %lineType: 'per drug' or 'per stim'; xAxis: 'dose' or 'time'










%