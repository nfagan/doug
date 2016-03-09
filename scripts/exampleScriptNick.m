startDir = '/Users/dougstreat/Google Drive/PSYC Thesis/Raw Data/';
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
drugTypes = {'OT'};
dosages = {'small','medium','large','saline'};

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
toExamine = 'proportion';
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
storePerImage = newPlot(M,'lineType','per stim','xAxis','dose','treatNaNs','meanReplace','doseNames',doseNames,'limits',[]);
%'lineType' -- what different lines correspond to
%   'per stim' -- each line is a different image
%   'per drug' -- each line is a different drug
%'xAxis' -- what's on the x axis
%   'dose' -- each x coord is a dose
%   'time' -- each x coord is a block number
%'limits' -- ylimits of the plot, specified as two element vector: [a b]
%'treatNaNs' -- how to deal with nan values (missing data) when plotting
%over time. Choose 'meanReplace' to guarentee that *something* will be
%plotted, but understand that this is probably a bad idea. Choose
%{'valReplace',VALUE} to specify what these empty values should b

%%
% --------------------------------
% plot
% --------------------------------
limits = [];
% barPlots(M,'all',allTrialTypes); %per stimulus, per block, all
M2 = reformatData(M,'lineType',lineType,'xAxis',xAxis,'limits',limits); %lineType: 'per drug' or 'per stim'; xAxis: 'dose' or 'time'
