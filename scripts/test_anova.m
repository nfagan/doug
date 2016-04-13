%%% storeLabels{1} = drug
%%% storeLabels{2} = dose
%%% storeLabels{3} = blockN
%%% storeLabels{4} = imageType

%%% include as many of the 4 factors into the anova as you want, in any order
%%% following this syntax:
%%% anovan(storeValues,{storeLabels{1},storeLabels{2}}
%%% You'll have to change the varnames to match the factors that you're
%%% including

[storeLabels,storeValues] = format_anova(images,1);

varnames = {'Drug','Dose','Image Type'};
[~,~,stats] = anovan(storeValues,{storeLabels{1},storeLabels{2},storeLabels{4}},'model','interaction','varnames',varnames);
results = multcompare(stats);