function plot_doses(values,labels,varargin)

global toExamine;

params = struct(...
    'limits',[],...
    'ylabel',[],...
    'withinMonkeys',0, ...
    'addFit',0,...
    'fitResolution',.25 ...
    );
params = structInpParse(params,varargin);

blocks = unique(labels{5});

if length(blocks) > 1;
    error(['There are multiple blocks in the input values. Rerun the analysis script'...
        , ' with one block (the whole session), or use separate_data() to create a new'...
        , ' input data-set with only one block''s worth of data.']);
end

monkeys = unique(labels{1});
images = unique(labels{2});
drugs = unique(labels{3});
doses = unique(labels{4});

n_monks = length(monkeys);
n_images = length(images);
n_drugs = length(drugs);
n_doses = length(doses);

if n_drugs == 3; %always have drugs show up in this order, if plotting all drugs
    drugs = {'OT','N','OTN'};
end

if n_doses == 4; %always have doses show up in this order, if plotting all doses
    doses = {'saline','small','medium','large'};
end

if n_images == 4; %always have images show up in this order, if plotting these 4 images
    images = {'monkeys','people','animals','outdoors'};
end

if n_monks > 1;
    fprintf('\nNOTE: the plotted means include multiple monkeys');
end

scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(2) scrsz(3)/4 scrsz(4)]);
for i = 1:n_images;
    subplot(n_images,1,i);
    for j = 1:n_drugs;
        means = zeros(1,n_doses); sems = zeros(1,n_doses);
        for k = 1:n_doses;
            if params.withinMonkeys %if averaging per-monkey, then plotting
                monkMeans = zeros(n_monks,4);
                for m = 1:n_monks;
                    extr_vals = separate_data(values,labels,...
                        'drugs',{drugs{j}},'images',{images{i}},...
                        'doses',{doses{k}},'monkeys',{monkeys{m}});
                    monkMeans(m,1:2) = [mean(extr_vals) std(extr_vals)]; %std deviation
                    monkMeans(m,3:4) = [std(extr_vals)^2 length(extr_vals)]; %variance and N samples
                end 
                [multMeans,multError] = multiMeans(monkMeans);
                means(k) = multMeans; sems(k) = multError;
            else %if combining across monkeys, then averaging
                extr_vals = separate_data(values,labels,...
                    'drugs',{drugs{j}},'images',{images{i}},'doses',{doses{k}});

                if strcmp(toExamine,'nImages') %special case -- sum nImages, if there're multiple blocks
                    extr_vals = sum(extr_vals);
                end

                means(k) = mean(extr_vals);
                sems(k) = SEM(extr_vals);
            end
        end
        
        % plot the real data first, then optionally add fit
        errorbar(1:k,means,sems,'DisplayName',drugs{j}); %plot
        hold on;
        if i == n_images
            legend('-DynamicLegend');
        end
        %do a fit
        if params.addFit
            amt = params.fitResolution;
            p = polyfit(1:k,means,2);
            y = p(1).*(1:amt:k).^2 + p(2).*(1:amt:k) + p(3).*(1:amt:k).^0;
            plot(1:amt:k,y,'k-','linewidth',.2,'DisplayName','.'); hold on;
        end
    end
    
    if ~isempty(params.limits);
        ylim(params.limits);
    end
    
    if i == round(n_images/2); %only add ylabels to mid-point of subplot
        if isempty(params.ylabel)
            yLabel = yLabeler;
            ylabel(yLabel);
        else
            ylabel(params.ylabel);
        end
    end
    
    title(images{i});
    
    set(gca,'xtick',1:n_doses);
    set(gca,'xticklabel',doses);
    
end
% legend(drugs);
    

