function plot_time(values,labels,drug,varargin)

params = struct(...
    'stringent',1,...
    'limits',[],...
    'ylabel',[],...
    'withinMonkeys',0, ...
    'addFit',0,...
    'fitResolution',.25 ...
    );
params = structInpParse(params,varargin);

blocks = unique(labels{5});
n_blocks = length(blocks);

if n_blocks == 1;
    error(['There is only one block''s worth (i.e., the full session''s worth) of data'...
        , ' in the input values. Rerun the analysis script to include multiple blocks.']);
end

monkeys = unique(labels{1});
images = unique(labels{2});
drugs = unique(labels{3});
doses = unique(labels{4});

n_monks = length(monkeys);
n_images = length(images);
n_doses = length(doses);

if n_doses == 4; %always have doses show up in this order, if plotting all doses
    doses = {'saline','medium','large','small'};
end

if n_images == 4; %always have images show up in this order, if plotting these 4 images
    images = {'monkeys','people','animals','outdoors'};
end

if n_monks > 1;
    fprintf('\nNOTE: the plotted means include multiple monkeys');
end

if sum(strcmp(drug,drugs)) == 0
    error(['The specified drug ''%s'' is not present in the input values.'...
        , ' Regenerate the input values using separate_data, or rerun the analysis'...
        , ' script with ''%s'' as a drugType.']);
end

% - check whether each monkey has sufficient data to run a block-level
%   analysis; can optionally bypass this with params.stringent = 0;

if params.stringent
    for i = 1:n_monks
        for k = 1:n_images;
            for j = 1:n_doses
                [~,testLabs] = separate_data(values,labels,...
                    'monkeys',{monkeys{i}},'drugs',{drug},...
                    'doses',{doses{j}},'images',{images{k}});
                if length(unique(testLabs{5})) < n_blocks
                    error(['Monkey ''%s'' does not have sufficient data with'...
                        , ' which to run a block-level analysis with the current'...
                        , ' number of blocks (%d). Rerun the analysis script'...
                        , ' with fewer blocks, or specify plot_time(...,''stringent'',0)'...
                        , ' to ignore the requirement that each monkey have the same'...
                        , ' number of blocks. Alternatively, try excluding ''%s'''...
                        , ' images.'],monkeys{i},n_blocks,images{k});
                end
            end
        end
    end
end

% - if sufficient data, then plot
scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(2) scrsz(3)/4 scrsz(4)]);
for i = 1:n_images
    subplot(n_images,1,i);
    for k = 1:n_doses
        means = zeros(1,n_blocks); sems = zeros(1,n_blocks);
        for j = 1:n_blocks
            if ~params.withinMonkeys %if combining across monkeys, then averaging (non-default)
                extr_vals = separate_data(values,labels,...
                    'drugs',{drug},'images',{images{i}},'doses',{doses{k}},...
                    'blocks',[blocks(j)]);
                means(j) = mean(extr_vals);
                sems(j) = SEM(extr_vals);
            else %if averaging within monkey, then averaging across monkeys (default)
                monkMeans = zeros(n_monks,4);
                for m = 1:n_monks;
                    extr_vals = separate_data(values,labels,...
                    'drugs',{drug},'images',{images{i}},'doses',{doses{k}},...
                    'blocks',[blocks(j)],'monkeys',{monkeys{m}});
                    monkMeans(m,1:2) = [mean(extr_vals) std(extr_vals)]; %std deviation
                    monkMeans(m,3:4) = [std(extr_vals)^2 length(extr_vals)]; %variance and N samples
                end
                [multMeans,multError] = multiMeans(monkMeans);
                means(j) = multMeans; sems(j) = multError;
            end
        end
        % plot error-barred means
        errorbar(1:j,means,sems,'DisplayName',doses{k}); hold on;
        if i == n_images; %only add legend to last plot
            legend('-DynamicLegend');
        end        
        % optionally add fit
        if params.addFit
            amt = params.fitResolution;
            p = polyfit(1:j,means,2);
            y = p(1).*(1:amt:j).^2 + p(2).*(1:amt:j) + p(3).*(1:amt:j).^0;
            plot(1:amt:j,y,'k-','linewidth',.2,'DisplayName','.'); hold on;
        end
        if ~isempty(params.limits)
            ylim(params.limits);
        end        
        if i == 1; %display the drug name alongside the image-name, if plotting the first subplot
            titleStr = sprintf('%s - %s',drug,images{i});
            title(titleStr);
        else %otherwise, just title the subplot the image name
            title(images{i});
        end
    end
    
    if n_blocks == 4; %if appropriate number of blocks, add block ids
        xTickLabels = {'','1','','2','','3','','4'};
        set(gca,'xticklabel',xTickLabels);
    end
    
    if i == round(n_images/2); %only add ylabels to mid-point of subplot
        if isempty(params.ylabel)
            yLabel = yLabeler;
            ylabel(yLabel);
        else
            ylabel(params.ylabel);
        end
    end
    
end

xlabel('Block Number');