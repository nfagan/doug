%%% norm_images.m - function for normalizing values from storeValues by 
%%% the mean values associated with one or more image types (usually,
%%% scrambled, only).
%
%   Required inputs:
%       
%       values,labels - pair of values and data labels whose means (per
%          image, per monkey, per block, per dose, and per drug) are *to be 
%          normalized*
%
%       values2,labels2 - pair of values and data labels whose means will
%           do the normalization (are the denominator)
%
%   Optional inputs:
%
%       withinMonkeys - 1 (default) or 0 - optionally specify whether to
%           take the means within monkeys, or whether to combine data across
%           monkeys, and then take a mean

function [storeExtr,storeLabs] = norm_images(values,labels,values2,labels2,varargin)

params = struct(...
    'withinMonkeys',1 ...
);
params = structInpParse(params,varargin);

monkeys = unique(labels{1});
images = unique(labels{2});
drugs = unique(labels{3});
doses = unique(labels{4});
blocks = unique(labels{5});

n_monkeys = length(monkeys);
n_images = length(images);
n_drugs = length(drugs);
n_doses = length(doses);
n_blocks = length(blocks);

step = 1;
for i = 1:n_images;
    for k = 1:n_drugs;
        for j = 1:n_doses;
            for l = 1:n_blocks
                if params.withinMonkeys;
                    for m = 1:n_monkeys;
                        [extr,extrLabels] = separate_data(values,labels,...
                            'images',{images{i}},'drugs',{drugs{k}},...
                            'doses',{doses{j}},'blocks',blocks(l),...
                            'monkeys',{monkeys{m}});

                        sec = separate_data(values2,labels2,...
                            'drugs',{drugs{k}},'doses',{doses{j}},...
                            'blocks',blocks(l),'monkeys',{monkeys{m}});

                        primMeans = mean(extr);
                        secMeans = mean(sec);

                        for n = 1:length(extrLabels);
                            if iscell(extrLabels{n});
                                storeLabs{n}{step,1} = extrLabels{n}{1};
                            else
                                storeLabs{n}(step,1) = extrLabels{n}(1);
                            end
                        end
                        storeExtr(step,1) = primMeans/secMeans;
                        step = step+1;
                    end
                else
                [extr,extrLabels] = separate_data(values,labels,...
                        'images',{images{i}},'drugs',{drugs{k}},...
                        'doses',{doses{j}},'blocks',blocks(l));

                    sec = separate_data(values2,labels2,...
                        'drugs',{drugs{k}},'doses',{doses{j}},'blocks',blocks(l));

                    primMeans = mean(extr);
                    secMeans = mean(sec);

                    for n = 1:length(extrLabels);
                        if iscell(extrLabels{n});
                            storeLabs{n}{step,1} = extrLabels{n}{1};
                        else
                            storeLabs{n}(step,1) = extrLabels{n}(1);
                        end
                    end
                    storeExtr(step,1) = primMeans/secMeans;
                    step = step+1;
                end
                    
            end
            
        end
    end
end













