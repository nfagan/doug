function toSave = getProportion(toSave,toAvg)

proportions = toSave{1}.forProportion ./ toSave{2}.forProportion;
proportions = proportions(~isnan(proportions));

switch toAvg
    case 'all values'
        
        for i = 1:2;
            toSave{i}.proportions = proportions;
        end

    case 'mean'
        
        for i = 1:2;        
            toSave{i}.proportions(:,1) = mean(proportions);
            toSave{i}.proportions(:,2) = std(proportions);
            toSave{i}.proportions(:,3) = (std(proportions)).^2;
            toSave{i}.proportions(:,4) = length(proportions);
        end
        
end

