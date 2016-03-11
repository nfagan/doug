%make trialTypes a cell array like this: {'animals','monkeys'} ...

function [wantedTimes] = getTrials(times,trialTypes)

getTrial = zeros(length(trialTypes),1);
invalid = ones(length(trialTypes),1); %convenience to let you know if input is valid
for i = 1:length(trialTypes);    
    toComp = trialTypes{i};    
    if ~strcmp(toComp,'all');        
        if strcmp(toComp,'animals');
            getTrial(i) = 1; invalid(i) = 0;
        end
        if strcmp(toComp,'monkeys');
            getTrial(i) = 2; invalid(i) = 0;
        end
        if strcmp(toComp,'outdoors');
            getTrial(i) = 3; invalid(i) = 0;
        end
        if strcmp(toComp,'people');
            getTrial(i) = 4; invalid(i) = 0;
        end
        if strcmp(toComp,'scrambled');
            getTrial(i) = 5; invalid(i) = 0;
        end
        if strcmp(toComp,'nonConspecific');
            getTrial = [1 4]; invalid(i) = 0;
        end
        if strcmp(toComp,'nonSocial');
            getTrial = [3 5]; invalid(i) = 0;
        end            
    else        
        getTrial = [1 2 3 4 5]; invalid(i) = 0;   
    end
    
end

if any(invalid);
    error('At least one trialType is of invalid format');
end
        
wantedTimes = cell(1,length(times));

for j = 1:length(times);
    
    oneTimes = times{j};
    oneTimes(:,3) = oneTimes(:,2) + 15e3;
    
    toKeep = zeros(length(oneTimes),size(getTrial,1));
    for i = 1:length(getTrial);
        toKeep(:,i) = oneTimes(:,1) == getTrial(i);        
    end
    
    toKeep = sum(toKeep,2); toRemove = toKeep == 0;
    
    oneTimes(toRemove,:) = [];    
    wantedTimes{j} = oneTimes(:,2:3);
    
end
    
    








    
    
    
    
    
    

