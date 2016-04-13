function [storeExtr,storeLabs] = sums_within_condition(values,labels)

monkeys = unique(labels{1});
images = unique(labels{2});
drugs = unique(labels{3});
doses = unique(labels{4});
blocks = unique(labels{5});

n_monks = length(monkeys);
n_images = length(images);
n_drugs = length(drugs);
n_doses = length(doses);
n_blocks = length(blocks);

step = 1;
for h = 1:n_monks
    for i = 1:n_images
        for j = 1:n_drugs
            for k = 1:n_doses
                [extr,labs] = separate_data(values,labels,...
                    'monkeys',{monkeys{h}},'images',{images{i}},...
                    'drugs',{drugs{j}},'doses',{doses{k}});
                extr = sum(extr);
                for n = 1:length(labs);
                    if iscell(labs{n});
                        storeLabs{n}{step,1} = labs{n}{1};
                    else
                        storeLabs{n}(step,1) = labs{n}(1);
                    end
                end
                storeExtr(step,1) = extr;
                step = step+1;
            end
        end
    end
end