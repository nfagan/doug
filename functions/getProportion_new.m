function toSave = getProportion_new(toSave,toAvg)

if ~isempty(toSave{1}.forProportion) && ~isempty(toSave{1}.forProportion);

proportions(:,1) = toSave{1}.forProportion(:,1) ./ toSave{2}.forProportion(:,1);
proportions(:,2) = toSave{1}.forProportion(:,2);

proportions = proportions(~isnan(proportions(:,1)),:);

else
    
    proportions = [];
end

switch toAvg
    case 'all values'
        
        for i = 1:2;
            toSave{i}.proportions = proportions;
        end

    case 'mean'
        
        for i = 1:2;        
            toSave{i}.proportions(:,1) = mean(proportions(:,1));
            toSave{i}.proportions(:,2) = std(proportions(:,1));
            toSave{i}.proportions(:,3) = (std(proportions(:,1))).^2;
            toSave{i}.proportions(:,4) = length(proportions(:,1));
        end
        
end

