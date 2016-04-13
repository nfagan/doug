%%% norm_by.m - function for normalizing values from storeValues by 
%%% the mean values of saline, or the mean values of scrambled images.
%%% Means are taken within every condition (i.e., within drug, within dose,
%%% within block ...) UNLESS 'withinMonkeys' = 0 (see below).
%
%   Required inputs:
%       
%       values,labels - pair of values and data labels whose means (per
%          image, per monkey, per block, per dose, and per drug) are *to be 
%          normalized*
%       normBy - specify whether to normalize by doses of saline or
%           scrambled images
%
%   Optional inputs:
%
%       withinMonkeys - 1 (default) or 0 - optionally specify whether to
%           take the means within monkeys, or whether to combine data across
%           monkeys, and then take a mean
%       normMethod - 'divide' (default) or 'subtract' - specify whether to
%           a) divide the mean values by the scrambled or saline means, or
%           b) subtract the scrambled or saline means from the mean values

function [storeExtr,storeLabs] = norm_by(values,labels,normBy,varargin)

params = struct(...
    'withinMonkeys',1, ...
    'normMethod','divide', ...
    'bothMeans',0 ... % confirm this is what you want
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

step = 1; storeLabs = cell(1,6);
for i = 1:n_images;
    for k = 1:n_drugs;
        for j = 1:n_doses;
            for l = 1:n_blocks
                if params.withinMonkeys; %if averaging within monkeys ...
                    for m = 1:n_monkeys;
                        [extr,extrLabels] = separate_data(values,labels,...
                            'images',{images{i}},'drugs',{drugs{k}},...
                            'doses',{doses{j}},'blocks',blocks(l),...
                            'monkeys',{monkeys{m}});
                        
                        switch normBy
                            case 'saline'
                                sec = separate_data(values,labels,...
                                    'drugs',{drugs{k}},'doses',{'saline'},...
                                    'blocks',blocks(l),'monkeys',{monkeys{m}},...
                                    'images',{images{i}});
                            case 'scrambled'
                                sec = separate_data(values,labels,...
                                    'drugs',{drugs{k}},'doses',{doses{j}},...
                                    'blocks',blocks(l),'monkeys',{monkeys{m}},...
                                    'images',{'scrambled'});
                        end
                        if ~isempty(extr) && ~isempty(sec); %if there's data for this block...
                            if params.bothMeans;
                                primMeans = mean(extr);
                            else
                                primMeans = extr;
                            end
                            secMeans = mean(sec);

                            for n = 1:length(extrLabels);
                                if params.bothMeans;
                                    if iscell(extrLabels{n});
                                        storeLabs{n}{step,1} = extrLabels{n}{1};
                                    else
                                        storeLabs{n}(step,1) = extrLabels{n}(1);
                                    end
                                else
                                    storeLabs{n} = [storeLabs{n};extrLabels{n}];
                                end
                            end

                            if strcmp(params.normMethod,'divide');
                                storeExtr{step,1} = primMeans./secMeans;
                            elseif strcmp(params.normMethod,'subtract');
                                storeExtr{step,1} = primMeans-secMeans;
                            end
                            step = step+1;
                        end
                    end
                else %if not within monkey
                [extr,extrLabels] = separate_data(values,labels,...
                        'images',{images{i}},'drugs',{drugs{k}},...
                        'doses',{doses{j}},'blocks',blocks(l));
                    
                    switch normBy
                        case 'saline'
                            sec = separate_data(values,labels,...
                                'drugs',{drugs{k}},'doses',{'saline'},...
                                'blocks',blocks(l),'images',{images{i}});
                        case 'scrambled'
                            sec = separate_data(values,labels,...
                                'drugs',{drugs{k}},'doses',{doses{j}},...
                                'blocks',blocks(l),'images',{'scrambled'});
                    end
                    if ~isempty(extr) && ~isempty(sec); %if there's data for this block...
                        if params.bothMeans;
                            primMeans = mean(extr);
                        else
                            primMeans = extr;
                        end
                        secMeans = mean(sec);

                        for n = 1:length(extrLabels);
                            if params.bothMeans
                                if iscell(extrLabels{n});
                                    storeLabs{n}{step,1} = extrLabels{n}{1};
                                else
                                    storeLabs{n}(step,1) = extrLabels{n}(1);
                                end
                            else
                                storeLabs{n} = [storeLabs{n};extrLabels{n}];
                            end
                                
                        end
                        if strcmp(params.normMethod,'divide');
                            storeExtr{step,1} = primMeans./secMeans;
                        elseif strcmp(params.normMethod,'subtract');
                            storeExtr{step,1} = primMeans-secMeans;
                        end
                        step = step+1;
                    end
                end
                    
            end
            
        end
    end
end

storeExtr = concatenateData(storeExtr);













