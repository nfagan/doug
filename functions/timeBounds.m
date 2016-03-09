function newTimes = timeBounds(wantedTimes,startEnd)

for i = 1:length(wantedTimes);
    oneTimes = wantedTimes{i};    
    checkTimes = oneTimes(:,1) - oneTimes(1,1);    
    index = checkTimes >= startEnd(1) & checkTimes <= startEnd(2);    
    newTimes{i} = oneTimes(index,:);
end
    