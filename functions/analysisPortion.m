function saveData = analysisPortion()

global add_on;
global identifiers;
global allTrialTypes;
global monkeys;
global drugTypes;
global dosages;

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
            end
        end
    end
end

end %end func