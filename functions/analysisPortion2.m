function [new_saveData,varargout] = analysisPortion2()

global addPupilData;
global pupil;
global analysisVersion;
global add_on;
global identifiers;
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

if strcmp(analysisVersion,'new');

add_on = 1;

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
            [allTimes,allEvents,pupil] = getFilesDoug(umbrellaDirectory); % load all files
            % -- get all relevant data --
            wantedTimes = getTrials(allTimes,trialType); %only output the display times associated with the images we're interested in
            step = 1;
            for l = 1:length(allBlockStarts);
                blockStart = allBlockStarts(l); %per block, only get the times that fall within these time bounds - from block start to block end
                blockEnd = allBlockEnds(l); %one hour, in ms
                timesWithinBounds = timeBounds(wantedTimes,[blockStart blockEnd]);

                ind = checkEmpty(timesWithinBounds);

                if ~isempty(ind);
                    error('No %s images were displayed during block %d',char(trialType),l);
                end

                [timesWithinBounds,fixedEvents,fixedPupil] = fixLengths2(timesWithinBounds,allEvents,pupil);

                toSave = cell(1,2);
                for n = 1:2;
%                     data = getDur_new(timesWithinBounds,fixedEvents,allPos{n},fixedPupil);
                    % last input = threshold for how long first fix-event
                    % must be
                    data = getDur_pupilSize700(timesWithinBounds,fixedEvents,allPos{n},fixedPupil,400);
                    toSave{n} = data;
                end
                
                toSave = getProportion_new(toSave,'all values');
                
                saveData{ii}{i}{j,k}{step,1} = toSave;
                step = step+1;
                
                new_saveData{add_on} = toSave;
                labels{1}{add_on} = {monkey};
                labels{2}{add_on} = trialType;
                labels{3}{add_on} = {drugTypes{j}};
                labels{4}{add_on} = {dosages{k}};
                labels{5}{add_on} = l;
                add_on = add_on+1;
                
                
            end
            end
        end
    end
end

if nargout > 1
    varargout{1} = labels;
elseif nargout > 2
    varargout{1} = labels;
    varargout{2} = saveData;
end

elseif strcmp(analysisVersion,'old');
    
    if nargout > 1
        error(['More than one output (saveData) specified. Did you mean to run' ...
            , ' with analysisVersion = ''new''?'])
    end
    
    saveData = analysisPortion;
    new_saveData = acrossMonkeys(saveData); %combine across monkeys
    
else
    
    error(['analysisVersion ''%s'' is not a valid analysisVersion. Use'...
        , ' analysisVersion = ''old'' or ''new'''],analysisVersion);
    
end