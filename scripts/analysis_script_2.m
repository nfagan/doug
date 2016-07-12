cd('/Volumes/My Passport/NICK/Chang Lab 2016/doug/pupil_stuff');

load('image_new_run.mat');

%% - extract data
global toExamine;
toExamine = 'nFixations';
[storeValues,storeLabels] = extract_data(new_saveData,labels);

%%

oldVals = storeValues;
oldLabs = storeLabels;
oldLabs = set_all(oldLabs,'blocks',[1]);
[oldNormed,oldNormLabels] = norm_by(oldVals,oldLabs,'saline');


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
[extrValues,extrLabels] = separate_data(normed,normLabels,'images',{'monkeys','people'},...
    'doses',{'small','medium','large'});

% [extrValues,extrLabels] = separate_data(storeValues,storeLabels,'images',{'monkeys','people'},...
%     'doses',{'small','medium','large'});

monkLabels = extrLabels{1};
imageLabels = extrLabels{2}; %extract individual grouping variables
drugLabels = extrLabels{3};
doseLabels = extrLabels{4};
blockLabels = extrLabels{5};

[p,tbl,stats] = anovan(extrValues,{imageLabels,drugLabels,doseLabels},...
    'model','full','varnames',{'Image','Drug','Dose'});

% results = multcompare(stats,'dimension',[2 3]);

%% separating normalized data by drug and image

[OT,OTLabels] = separate_data(normed,normLabels,'images',{'monkeys','people'},...
    'doses',{'small','medium','large'},'drugs',{'OT'});

[N,NLabels] = separate_data(normed,normLabels,'images',{'monkeys','people'},...
    'doses',{'small','medium','large'},'drugs',{'N'});

[OTN,OTNLabels] = separate_data(normed,normLabels,'images',{'monkeys','people'},...
    'doses',{'small','medium','large'},'drugs',{'OTN'});

%% subsequent anovas (after N-way non-nested ANOVA)

[pOT,tblOT,statsOT] = anovan(OT,{OTLabels{2},OTLabels{4}},... %OT ANOVA
    'model','full','varnames',{'Image','Dose'});

[pOTN,tblOTN,statsOTN] = anovan(OTN,{OTNLabels{2},OTNLabels{4}},... %OTN Anova
    'model','full','varnames',{'Image','Dose'});

[pN,tblN,statsN] = anovan(N,{NLabels{2},NLabels{4}},... %N Anova
    'model','full','varnames',{'Image','Dose'});

%% multicomparisons / visualization 

[OTresults,OTmeans,~,OTgroupNames] = multcompare(statsOT,'dimension',[1 2]); %dimension corresponds to group names in anova
[OTNresults,OTNmeans,~,OTNgroupNames] = multcompare(statsOTN,'dimension',[1 2]);
[Nresults,Nmeans,~,NgroupNames] = multcompare(statsN,'dimension',[1 2]);

%% reformat results

OTNresults2 = reformat_results(OTNresults,OTNgroupNames);






