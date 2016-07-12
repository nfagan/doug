global toExamine;
global region;
region = 'eyes';
loadIn = 0;

if loadIn;
    cd('/Volumes/My Passport/NICK/Chang Lab 2016/doug/pupil_stuff');
    load(sprintf('%s.mat',region));
end
load('eyes_fix_events.mat');
% toExamine = 'pupilTimeCourse';
% toExamine = 'pupilSize';
toExamine = 'pupilPSTH';

[storeValues,storeLabels] = extract_data(new_saveData,labels);

%% if doing pupil PSTH



%% normalized
% [normPupil,normLabels] = normalize_pupil(storeValues,storeLabels,1); %(...,1) if you want to include the baseline period in the plots.
[normPupil,normLabels] = normalize_pupil2(storeValues,storeLabels,50);

%% if plotting one monkey

[normPupil,normLabels] = separate_data(normPupil,normLabels,'monkeys',{'Lager'});

%% plot -- change figure visiblity to 'On' later

% storeLabels2 = set_all(storeLabels,'blocks',1);

% [newPupil,newLabs] = separate_data(normPupil,normLabels,'doses',{'small'},'images',{'monkeys'});

% [normPupil,normLabels] = separate_data(normPupil,normLabels,'monkeys',{'Joda','Lager'},'doses',{'all'});
plot_pupil(normPupil,normLabels,'N','people','addErrorLines',0,'limits',[.65,1.1],'binSize',50);
%% save plots
[normPupil,normLabels] = separate_data(normPupil,normLabels,'monkeys',{'Joda','Lager'});
drugs = unique(normLabels{3});
images = unique(normLabels{2});
for i = 1:length(drugs);
    for k = 1:length(images);
        plot_pupil(normPupil,normLabels,drugs{i},images{k},'addErrorLines',1,'limits',[.65,1.1],'save',1,'monkNames','lager_joda');
    end
end
% plot_pupil(newPupil,newLabs,'OT','Lager','monkeys');