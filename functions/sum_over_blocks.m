function [storeSum,storeLabels] = sum_over_blocks(vals,labs)

monkeys = unique(labs{1});
images = unique(labs{2});
drugs = unique(labs{3});
doses = unique(labs{4});

n_monks = length(monkeys);
n_images = length(images);
n_drugs = length(drugs);
n_doses = length(doses);

step = 1;
for h = 1:n_monks
    for i = 1:n_images
        for j = 1:n_drugs
            for k = 1:n_doses
                [~,getBlocks] = separate_data(vals,labs,...
                        'monkeys',{monkeys{h}},'drugs',{drugs{j}},...
                        'images',{images{i}},'doses',{doses{k}});
                    blocks = unique(getBlocks{5});
                	n_blocks = length(blocks);
                for l = 1:n_blocks
                    [storeBlocks(blocks(l)),label] = separate_data(vals,labs,...
                        'monkeys',{monkeys{h}},'drugs',{drugs{j}},...
                        'images',{images{i}},'doses',{doses{k}},...
                        'blocks',blocks(l));
                end
                storeSum(step,1) = sum(storeBlocks);
                for ll = 1:length(label);
                    if iscell(label{ll});
                        storeLabels{ll}{step,1} = char(label{ll});
                    else
                        storeLabels{ll}(step,1) = label{ll};
                    end
                end
                step = step+1;
            end
        end
    end
end

                    