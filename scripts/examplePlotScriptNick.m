%% extract data from analysis script variable new_saveData

global toExamine;
toExamine = 'nImages';
[storeValues,storeLabels] = extract_data(new_saveData,labels);

%% normalize proportions and plot | after setting toExamine = 'proportions'

% ---- first do the normalization

[props,propLabels]=norm_prop(storeValues,storeLabels,'saline');

% ---- then plot

% plot_time(props,propLabels,'OT'); %if plotting per-block
plot_doses(props,propLabels); %if plotting whole session

%% "normalize" anything else | after setting toExamine = anything else

% ---- what kind of images are we normalizing (numerator)?

[toNorm,toNormLabels] = separate_data(storeValues,storeLabels,...
    'images',{'monkeys','people','outdoors','animals'});

% ---- what images are we normalizing by?

[normBy,normByLabels] = separate_data(storeValues,storeLabels,...
    'images',{'scrambled'});

% ---- do the normalization

[lookingDur,lookingDurLabels] = norm_images(...
    toNorm,toNormLabels,normBy,normByLabels);

% ---- then pot

% plot_time(lookingDur,lookingDurLabels,'OT','ylabel','Normalized Looking Duration');
plot_doses(lookingDur,lookingDurLabels,'ylabel','Normalized Looking Duration'); % if using whole session;


%% plot per dose or per block (basic)

% plot_time(storeValues,storeLabels,'OT');

% newLabs = set_all(storeLabels,'blocks',1); %if running exampleScript for multiple blocks, use set_all to set all block tags to 1
% storeLabels2 = set_all(storeLabels,'blocks',1);
[lagVals,lagLabels] = separate_data(storeValues,storeLabels,'monkeys',{'Lager'});
plot_doses(lagVals,lagLabels,'withinMonkeys',1);

%% get total images

[d2,d2labs] = separate_data(storeValues,storeLabels,...
    'monkeys',{'Joda'},'images',{'animals'},'doses',{'small'},'drugs',{'OT'});
z2 = sum(d);

d2labs = set_all(d2labs,'blocks',1);

plot_doses(d2,d2labs);






