function [normed,storeLabs] = norm_prop(values,labels,normBy)

images = unique(labels{2});
drugs = unique(labels{3});
doses = unique(labels{4});
blocks = unique(labels{5});

n_images = length(images);
n_drugs = length(drugs);
n_doses = length(doses);
n_blocks = length(blocks);

step = 1;
for i = 1:n_images
    for j = 1:n_drugs
        for k = 1:n_doses
            for l = 1:n_blocks
                switch normBy
                    case 'saline'
                        sal = separate_data(values,labels,...
                            'images',{images{i}},'drugs',{drugs{j}},...
                            'doses',{'saline'},'blocks',blocks(l));
                    case 'scrambled'
                        sal = separate_data(values,labels,...
                            'images',{'scrambled'},'drugs',{drugs{j}},...
                            'doses',{doses{k}},'blocks',blocks(l));
                end
                [extr,labs] = separate_data(values,labels,...
                    'images',{images{i}},'drugs',{drugs{j}},...
                    'doses',{doses{k}},'blocks',[blocks(l)]);
                for n = 1:length(labs);
                    if iscell(labs{n});
                        storeLabs{n}{step,1} = labs{n}{1};
                    else
                        storeLabs{n}(step,1) = labs{n}(1);
                    end
                end
                normed(step,1) = mean(extr)/mean(sal);
                step = step+1;
            end
        end
    end
end
