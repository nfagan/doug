function newCell = reformat_results(results,groupNames,includeAll)

if nargin < 3; %exclude non-significant results, by default
    includeAll = 0;
end

sigIndex = results(:,6) < .05; %find where comparisons are significant

if ~includeAll
    results = results(sigIndex,:); %only output those significant comparisons
end

newCell = cell(size(results,1),size(results,2)); %preallocate a cell array
for i = 1:size(results,1);
    for k = 1:size(results,2);
        newCell{i,k} = results(i,k); %transfer mat values into the cell array
    end
end

nCols = size(newCell,2);

for i = 1:size(results,1); %add group labels to results output
    newCell{i,nCols+1} = groupNames{results(i,1)};
    newCell{i,nCols+2} = groupNames{results(i,2)};
end