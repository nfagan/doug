function means = descriptive_stats(values,labels,varargin)

params = struct(...
    'withinBlocks',0, ...
    'withinMonkeys',0 ...
    );

params = structInpParse(params,varargin);

monkeys = unique(labels{1});
images = unique(labels{2});
drugs = unique(labels{3});
doses = unique(labels{4});
blocks = unique(labels{5});

stp = 1;
if ~params.withinMonkeys
    monkeys = {'all'}; %average across monkeys, unless explicitly declaring otherwise
end
for l = 1:length(monkeys); %for each monkey (usually 'all') ...
    for h = 1:length(images) %for each image ...
        for i = 1:length(drugs) %for each drug ...
            for k = 1:length(doses) %for each dose ...
                if ~params.withinBlocks
                    blocks = {'all'};
                end
                for j = 1:length(blocks)
                    dist = separate_data(values,labels,'images',{images{h}},... %extract data
                        'drugs',{drugs{i}},'doses',{doses{k}},...
                        'blocks',[blocks(j)],'monkeys',{monkeys{l}});
                    
                    means(stp).mean = mean(dist); %get the mean
                    means(stp).std_deviation = std(dist); %get the std_deviation
                    means(stp).N = length(dist);
                    means(stp).monkeys = monkeys{l}; %identify the values
                    means(stp).image = images{h};
                    means(stp).drug = drugs{i};
                    means(stp).doses = doses{k};
                    means(stp).blocks = blocks(j);

                    stp = stp+1;

                end
            end
        end
    end
end