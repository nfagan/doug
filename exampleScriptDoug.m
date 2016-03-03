% --------------------------------
% define global parameters
% --------------------------------

startDir = '/Volumes/My Passport/NICK/Chang Lab 2016/repositories/doug/';

global drugTypes;
global dosages;
global toExamine;
global allTrialTypes;
global allBlockStarts;
global allBlockEnds;
global allPos;

monkey = 'Kurosawa';
drugTypes = {'OT','OTN','N','Saline'};
dosages = {'small','medium','large'};

toExamine = 'proportion'; %'proportion', 'normalized proportion' 'raw counts', 'average duration', or 'n images'
region = 'roi';

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
M = cell(length(drugTypes),length(dosages));

for j = 1:length(drugTypes);
    
    for k = 1:length(dosages);
    % --------------------------------
    % load in files
    % --------------------------------
    umbrellaDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/doug/data/OTN/time_efix'; %change this to where your files are located
%     umbrellaDirectory = getUmbrDir(drugTypes{j},dosages{k});
    [allTimes,allEvents] = getFilesDoug(umbrellaDirectory); % load all files
    % --------------------------------
    % get all relevant data
    % --------------------------------
    saveData = getSaveData(allTimes,allEvents);
    % --------------------------------
    % construct matrix and plot
    % --------------------------------
    M{j,k} = genTable(saveData,region);
    end
end

%%

limits = [];

% barPlots(M,'all',allTrialTypes); %per stimulus, per block, all

M2 = reformatData(M,'lineType','per stim','xAxis','time','limits',limits); %lineType: 'per drug' or 'per stim'; xAxis: 'dose' or 'time'