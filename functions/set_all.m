function fixedLabels = set_all(labels,varargin)

params = struct(...
    'monkeys',[],...
    'images',[],...
    'drugs',[],...
    'doses',[],...
    'blocks',[]...
    );

params = structInpParse(params,varargin);

fields = fieldnames(params);

for i = 1:length(fields);
    if (~isempty(params.(fields{i}))) && (~iscell(params.(fields{i}))) && ...
            (~strcmp(fields{i},'blocks'));
        params.(fields{i}) = {params.(fields{i})};
    end
end
    
N = length(labels{1});

fixedLabels = labels;

if ~isempty(params.monkeys);
    fixedLabels{1} = repmat(params.monkeys,N,1);
end

if ~isempty(params.images);
    fixedLabels{2} = repmat(params.images,N,1);
end

if ~isempty(params.drugs);
    fixedLabels{3} = repmat(params.drugs,N,1);
end

if ~isempty(params.doses);
    fixedLabels{4} = repmat(params.doses,N,1);
end

if ~isempty(params.blocks);
    fixedLabels{5} = repmat(params.blocks,N,1);
end



    







    