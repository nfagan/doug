cd('/Volumes/My Passport/NICK/Chang Lab 2016/doug/pupil_stuff');

load('image.mat');

%% - extract data
global toExamine;
toExamine = 'lookingDuration';
[storeValues,storeLabels] = extract_data(new_saveData,labels);

%% optionally extract one monkey

[storeValues,storeLabels] = separate_data(storeValues,storeLabels,'monkeys',{'Lager'});

%% normalize

[normed,normLabels] = norm_by(storeValues,storeLabels,'saline');

%% N-way nested ANOVA

[normed,normLabels] = separate_data(normed,normLabels,'images',{'people','monkeys','scrambled'});

monkLabels = normLabels{1};
imageLabels = normLabels{2}; %extract individual grouping variables
drugLabels = normLabels{3};
doseLabels = normLabels{4};
blockLabels = normLabels{5};

nestingMatrix(1,:) = [0,0,0]; %don't nest FIRST grouping variable in anything
nestingMatrix(2,:) = [1,0,0]; %nest SECOND grouping variable in first, only
nestingMatrix(3,:) = [1,1,0]; %nest THIRD grouping variable in first AND second

[p,tbl,stats] = anovan(normed,{imageLabels,drugLabels,doseLabels},... %add grouping variables here
    'model','interaction','varnames',{'Image','Drug','Dose'},'nested',nestingMatrix); %change variable names here

results = multcompare(stats);

%% N-way non-nested ANOVA

% [extrValues,extrLabels] = separate_data(normed,normLabels,'images',{'people'});
[extrValues,extrLabels] = separate_data(storeValues,storeLabels,'images',{'people'});

monkLabels = extrLabels{1};
imageLabels = extrLabels{2}; %extract individual grouping variables
drugLabels = extrLabels{3};
doseLabels = extrLabels{4};
blockLabels = all_labels{5};

[p,tbl,stats] = anovan(extrValues,{drugLabels,doseLabels},...
    'model','interaction','varnames',{'Drug','Dose'});

results = multcompare(stats,'dimension',[1,2]);