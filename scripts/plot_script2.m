%% optionally load in data - only necessary if changing the roi
global region;
global toExamine;
region = 'image';
loadIn = 0;
if loadIn;
%     cd('/Volumes/My Passport/for_doug/for_doug'); %%%change this
    cd('/Volumes/My Passport/NICK/Chang Lab 2016/doug/pupil_stuff');
%     load(sprintf('%s.mat',region));
    load('testLager.mat');
end

%% extract data from loaded variables
toExamine = 'fixEventDuration';
[storeValues,storeLabels] = extract_data(new_saveData,labels);

%% ONLY FOR nImages: if wanting to look over the full session

[storeValues2,storeLabels2] = sum_over_blocks(storeValues,storeLabels);

fixedLabels = set_all(storeLabels2,'blocks',1); %if wanting to look at whole session
[normed,normedLabels] = norm_by(storeValues2,fixedLabels,'scrambled'); %normalize nImages by scrambled image data
[normed,normedLabels] = separate_data(normed,normedLabels,...
    'images',{'people','monkeys','outdoors','animals'}); %don't plot scrambled images

plot_doses(normed,normedLabels,'ylabel','FILL IN'); %plot normalized data
%% FOR EVERTHING ELSE: run if wanting to look at whole session

fixedLabels = set_all(storeLabels,'blocks',1); %if wanting to look at whole session
[normed,normedLabels] = norm_by(storeValues,fixedLabels,'scrambled','bothMeans',0);

%%
[normed,normedLabels] = separate_data(normed,normedLabels,'monkeys',{'all'},...
    'images',{'people','monkeys','outdoors','animals'});

plot_doses(normed,normedLabels,'addFit',0);
%% run if wanting to plot over TIME -- removes coppola's data

[normed,normedLabels] = norm_by(storeValues,storeLabels,'scrambled','normMethod','subtract'); % 'normMethod','subtract'
[normed,normedLabels] = separate_data(normed,normedLabels,'monkeys',...
    {'Joda','Lager'},'images',{'people','monkeys','outdoors','animals'});

%%
plot_time(normed,normedLabels,'OT','addFit',1,'ylabel','SICK');  % ...,'ylabel','FILL IN YLABEL')
% plot_time(normed,normedLabels,'N'); 
% plot_time(normed,normedLabels,'OTN');





