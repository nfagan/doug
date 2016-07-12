%% Load In
toExamine = 'fixDurTimeCourse'; % fixDurTimeCourse
[fix_durs,fix_durs_labels] = extract_data(new_saveData,orig_labels);

%%

cd('/Volumes/My Passport/NICK/Chang Lab 2016/doug/fix_counts_and_gaze_dur_over_time');

load('fix_counts_and_gaze_dur_over_time.mat');



%% loop 3 drugs - plot fix counts over time and fix event duration over time

% drugs = {'OT','N','OTN'};
doses = {'small','medium','large'};
drug = {'OTN'};
images = {'people'};

means = []; stds = []; binned = [];
for i = 1:length(doses);
    fix_counts_by_drug = separate_data(fix_counts,fix_counts_labels,...
        'doses',{doses{i}},'drugs',drug,'images',images);
    
    fix_durs_by_drug = separate_data(fix_durs,fix_durs_labels,...
        'doses',{doses{i}},'drugs',drug,'images',images);
    
    [means(:,i),stds(:,i)] = get_binned_fix_dur(fix_durs_by_drug,100);
    binned(:,i) = get_binned_fix_counts(fix_counts_by_drug,100,'showPlot',0);
    binned(:,i) = binned(:,i)/size(fix_counts_by_drug,1);
end
figure;

plot(means); legend(doses); title(images); ylabel('Mean Fix Event Duration');

figure;
plot(binned); legend(doses); title(images); ylabel('Number of Fixations');

%%
binned = get_binned_fix_counts(fix_counts,100);
[means,stds] = get_binned_fix_dur(fix_durs,100);


%%

[means,stds] = get_binned_fix_dur(fix_durs,100);
to_plot_means = [means];
to_plot_stds = [means+stds;means-stds];

figure;
plot(to_plot_means'); hold on; 

plot(to_plot_stds(1,:)','k');
plot(to_plot_stds(2,:)','k');

xlim([0 size(to_plot_means,2)]);

