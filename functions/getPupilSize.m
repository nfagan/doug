function pupilSize = getPupilSize(pupilData,startEndTimes,startAdjust)

if nargin < 3;
    startAdjust = -200;
end    

starts = startEndTimes(:,1);
ends = startEndTimes(:,2);

starts = starts + startAdjust; %adjust to look 200ms pre-image presentation

rows = 1:length(pupilData);
startInd = rows(pupilData(:,1) == starts);
endInd = rows(pupilData(:,1) == ends);

if isempty(startInd) || isempty(endInd);
%     error('No start / end indices found');
    warning('No start / end indices found. Skipping this file ...');
    pupilSize = nan(ends-starts+1,1);
elseif length(startInd) > 1 || length(endInd) > 1;
    error('Multiple start or end indices found');
else
    pupilSize = pupilData(startInd:endInd,2);
end





