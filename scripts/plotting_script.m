global toExamine;
toExamine = 'nImages';
[storeValues,storeLabels] = extract_data(new_saveData,labels);

%%
% [coppVals,coppLabels]= separate_data(storeValues,storeLabels,'monkeys',{'Coppola'});
fixedLabels = set_all(storeLabels,'blocks',1);
% plot_doses(storeValues,storeLabels,'limits',[]);
plot_time(storeValues,storeLabels,'OT','limits',[]);

%% combining across monkeys, then normalizing, and plotting single values (no errorbars)

[normed,normLabs] = norm_prop(storeValues,storeLabels,'scrambled'); %normalize storeValues by values for scrambled images
% [normed,normLabs] = separate_data(normed,normLabs,'images',{'people','animals','monkeys'}); %only pull out normalized people, animal, and monkey data

plot_doses(normed,normLabs); %plot the extracted subset of data

%% normalize by image

%first input = what is normalized (numerator); second input = denominator
[animalImages,animalImageLabels] = separate_data(storeValues,storeLabels,'images',{'animals','people','monkeys'});
[monkeyImages,monkeyImageLabels] = separate_data(storeValues,storeLabels,'images',{'monkeys'});

[newExtr,newLabs] = norm_images(animalImages,animalImageLabels,monkeyImages,monkeyImageLabels); 

plot_doses(newExtr,newLabs);


%% normalizing within monkey, then plotting means across monkeys
[joda,jodaLabs] = separate_data(storeValues,storeLabels,'monkeys',{'Joda'});
[lager,lagerLabs] = separate_data(storeValues,storeLabels,'monkeys',{'Lager'});

[jodaNorm,jodaNormLabels] = norm_prop(joda,jodaLabs,'scrambled');
[lagerNorm,lagerNormLabels] = norm_prop(lager,lagerLabs,'scrambled');

[normed,normLabs] = combine_data({jodaNorm,lagerNorm},{jodaNormLabels,lagerNormLabels});
plot_doses(normed,normLabs,'limits',[.75 1.25]);


%%
allValues = {joda,lager};
allLabels = {jodaLabs,lagerLabs};

[storeVals,storeLabs] = combine_data(allValues,allLabels);



