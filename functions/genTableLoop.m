function M = genTableLoop(saveData,region)

global allTrialTypes;
global drugTypes;
global dosages;

M = cell(length(allTrialTypes),1);
for i = 1:length(allTrialTypes);
    for j = 1:length(drugTypes);
        for k = 1:length(dosages);
            M{i}{j,k} = genTable(saveData{i}{j,k},region);
        end
    end
end