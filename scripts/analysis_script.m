%% - extract data
global toExamine;
toExamine = 'fixEventDuration';
[storeValues,storeLabels] = extract_data(new_saveData,labels);

%%

joda = separate_data(storeValues,storeLabels,'monkeys',{'Joda'});
coppola = separate_data(storeValues,storeLabels,'monkeys',{'Coppola'});
lager = separate_data(storeValues,storeLabels,'monkeys',{'Lager'});

%%

joda = mean(joda);
coppola = mean(coppola);
lager = mean(lager);

%% 2 sample t-test
[n_vals,~] = separate_data(storeValues,storeLabels,'drugs',{'N'});
[ot_vals,~] = separate_data(storeValues,storeLabels,'drugs',{'OT'});

nMeans = n_vals(:,1);
otMeans = ot_vals(:,1);

[~,p,ci,stats] = ttest2(nMeans,otMeans); %two sample t-test

%% N-way Anova

[n_values,n_labels] = separate_data(storeValues,storeLabels,'drugs',{'N'},'doses',{'all'},'blocks','all');

[all_values,all_labels] = separate_data(storeValues,storeLabels,'drugs',{'all'},'doses',{'all'},'blocks','all');

monkLabels = all_labels{1};
imageLabels = all_labels{2};
drugLabels = all_labels{3};
doseLabels = all_labels{4};
blockLabels = all_labels{5};
sessLabels = all_labels{6};

%%
% [p,~,stats] = anovan(n_values(:,1),{doseLabels,imageLabels},'model','interaction','varnames',{'Dose','Image Type'});
[p,tbl,stats] = anovan(all_values(:,1),{drugLabels,doseLabels,imageLabels},'model','interaction','varnames',{'Drugs','Dose','Image Type'});
% results = multcompare(stats,'dimension',[1 2]);
