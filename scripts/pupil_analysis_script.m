global toExamine;
global region;
region = 'image';
loadIn = 1;

if loadIn;
    cd('/Volumes/My Passport/NICK/Chang Lab 2016/doug/pupil_stuff');
    load(sprintf('%s.mat',region));
end

% toExamine = 'pupilTimeCourse';
toExamine = 'pupilSize';

[storeValues,storeLabels] = extract_data(new_saveData,labels);

%% normalized
[normPupil,normLabels] = normalize_pupil(storeValues,storeLabels,1); %(...,1) if you want to include the baseline period in the plots.

%% if combining across monkeys

[normPupil,normLabels] = separate_data(normPupil,normLabels,'monkeys',{'Joda','Lager'});

%% plot

% storeLabels2 = set_all(storeLabels,'blocks',1);

% [newPupil,newLabs] = separate_data(normPupil,normLabels,'doses',{'small'},'images',{'monkeys'});

[normPupil,normLabels] = separate_data(normPupil,normLabels,'doses',{'saline'});

plot_pupil(normPupil,normLabels,'OTN','scrambled','addErrorLines',1,'limits',[.65,1.1]);
% plot_pupil(newPupil,newLabs,'OT','Lager','monkeys');