function [outputValues,outputLabels] = separate_data(storeValues,storeLabels,varargin)

monkeys = unique(storeLabels{1});
allTrialTypes = unique(storeLabels{2});
drugTypes = unique(storeLabels{3});
dosages = unique(storeLabels{4});
storedBlocks = unique(storeLabels{5});
uniq_sessions = unique(storeLabels{6});

% global monkeys;
% global drugTypes;
% global dosages;
% global allTrialTypes;

params = struct(...
    'monkeys','all',...
    'drugs','all',...
    'doses','all',...
    'images','all',...
    'blocks','all',...
    'sessions','all',...
    'errorIfEmpty',0 ...
    );

params = structInpParse(params,varargin);

extr_monkeys = params.monkeys;
drugs = params.drugs;
doses = params.doses;
images = params.images;
blocks = params.blocks;
sessions = params.sessions;

% nBlocks = max(str2num(cell2mat(unique(storeLabels{5})))); %block data is 5th column of storeLabels
nBlocks = length(unique(storeLabels{5}));
% nSessions = max(storeLabels{6}); %session data is 6th column of storeLabels

% -- parse desired variables

if strcmp(extr_monkeys,'all');
    wantedMonkeys = monkeys;
else
    wantedMonkeys = extr_monkeys;
end

if strcmp(drugs,'all');
    wantedDrugs = drugTypes;
else
    wantedDrugs = drugs;
end

if strcmp(doses,'all');
    wantedDoses = dosages;
else
    wantedDoses = doses;
end

if strcmp(images,'all');
    wantedImages = allTrialTypes;
else
    wantedImages = images;
end

if strcmp(blocks,'all');
%     wantedBlocks = 1:nBlocks;
    wantedBlocks = storedBlocks;
else
    wantedBlocks = blocks;
end

if strcmp(sessions,'all');
%     wantedSessions = 1:nSessions;
    wantedSessions = uniq_sessions;
else
    wantedSessions = sessions;
end

% -- extract based on wantedVariables

monkInd = zeros(size(storeLabels{1},1),length(wantedMonkeys));
for i = 1:length(wantedMonkeys);
    monkInd(:,i) = strcmp(storeLabels{1},wantedMonkeys{i});
end

drugIndex = zeros(size(storeLabels{1},1),length(wantedDrugs));
for i = 1:length(wantedDrugs);
    drugIndex(:,i) = strcmp(storeLabels{3},wantedDrugs{i});
end

doseIndex = zeros(size(storeLabels{1},1),length(wantedDoses));
for i = 1:length(wantedDoses);
    doseIndex(:,i) = strcmp(storeLabels{4},wantedDoses{i});
end

imageIndex = zeros(size(storeLabels{1},1),length(wantedImages));
for i = 1:length(wantedImages);
    imageIndex(:,i) = strcmp(storeLabels{2},wantedImages{i});
end

blockIndex = zeros(size(storeLabels{1},1),length(wantedBlocks));
for i = 1:length(wantedBlocks);
%     blockIndex(:,i) = strcmp(storeLabels{5},num2str(wantedBlocks(i)));
    blockIndex(:,i) = storeLabels{5} == wantedBlocks(i);
end

sessInd = zeros(size(storeLabels{1},1),length(wantedSessions));
for i = 1:length(wantedSessions);
    sessInd(:,i) = storeLabels{6} == wantedSessions(i);
end

monkInd = sum(monkInd,2) >= 1;
drugIndex = sum(drugIndex,2) >= 1;
doseIndex = sum(doseIndex,2) >= 1;
imageIndex = sum(imageIndex,2) >= 1;
blockIndex = sum(blockIndex,2) >= 1;
sessInd = sum(sessInd,2) >= 1;

allInds = drugIndex & doseIndex & imageIndex & blockIndex & monkInd & sessInd;

for k = 1:length(storeLabels);
    oneLab = storeLabels{k};
    outputLabels{k} = oneLab(allInds); %only keep wanted labels
end

outputValues = storeValues(allInds,:); % only keep wanted values;

if isempty(outputValues) && params.errorIfEmpty
    msg = sprintf(['\nNo data matched the input criteria.\n\n1) Confirm that your specified drugs and dosages'...
        , ' are also present in the global variables drugTypes and dosages.' ...
        , '\n2) If specifying block numbers, ensure you''re running the analysisPortion'...
        , ' with the appropriate number of blocks.\n3) As it stands, there are very few data files per drug / dose combination.'...
        , ' Thus, it may prove difficult or impossible to separate by session number.']);
    error(msg)
end
