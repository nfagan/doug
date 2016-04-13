function separate_data(storeValues,storeLabels,drugs,doses,images,blocks

drugs = {'OT','N'};
doses = {'small'};
images = {'people'};
blocks = [1 2];

nBlocks = max(str2num(cell2mat(unique(storeLabels{3}))));

global drugTypes;
global dosages;
global allTrialTypes;

if strcmp(drugs,'all');
    wantedDrugs = drugTypes;
else
    wantedDrugs = {'OT','N'};
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

if iscell(blocks) && strcmp(blocks,'all');
    wantedBlocks = [1:nBlocks];
else
    wantedBlocks = blocks;
end

for i = 1:length(wantedDrugs);
    drugIndex(:,i) = strcmp(storeLabels{1},wantedDrugs{i});
end

for i = 1:length(wantedDoses);
    doseIndex(:,i) = strcmp(storeLabels{2},wantedDoses{i});
end

for i = 1:length(wantedImages);
    imageIndex(:,i) = strcmp(storeLabels{4},wantedImages{i});
end

for i = 1:length(wantedBlocks);
    blockIndex(:,i) = strcmp(storeLabels{3},num2str(wantedBlocks(i)));
end

drugIndex = sum(drugIndex,2) >= 1;
doseIndex = sum(doseIndex,2) >= 1;
imageIndex = sum(imageIndex,2) >= 1;
blockIndex = sum(blockIndex,2) >= 1;

allInds = drugIndex & doseIndex & imageIndex & blockIndex;

for k = 1:length(storeLabels);
    oneLab = storeLabels{k};
    storeLabels{k} = oneLab(allInds); %only keep wanted values
end

storeValues = storeValues(allInds); % only keep wanted values;

% [~,~,stats] = anovan(storeValues,{storeLabels{1},storeLabels{2},storeLabels