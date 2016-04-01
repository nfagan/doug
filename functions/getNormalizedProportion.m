% getNormalizedProportion.m - function for normalizing image data by
% scrambled image or saline data. 
%
%       Should work with any toExamine input, with the caveat that, for
%       vector inputs (e.g., 'proportions', where there are, by default,
%       proportion values *per image*), the resulting proportions will be
%       normalized by the *mean* of the normalization vector.

function images = getNormalizedProportion(images,normalizeBy,varargin)

global allBlockStarts;
global allTrialTypes;
global dosages;
global drugTypes;

params = struct(...
    'normMethod','divide' ...
    );
params = structInpParse(params,varargin);

possNormBy = {'saline','scrambled'};

% -- check input validity

if sum(strcmp(normalizeBy,possNormBy)) ~= 1;
    for i = 1:length(possNormBy);
        fprintf('%s\n',possNormBy{i});
    end
    error(['%s is not a recognized parameter by which to normalize. See above' ...
        , ' for possible inputs.'],normalizeBy)
end

if sum(strcmp(dosages,'saline')) ~= 1 && strcmp(normalizeBy,'saline')
    error(['The current data struct doesn''t include saline files. Re-run the script' ...
    , ' with saline as a dose']);
elseif sum(strcmp(allTrialTypes,'scrambled')) ~= 1 && strcmp(normalizeBy,'scrambled')
    error(['The current data struct doesn''t include scrambled image data. Re-run the script' ...
    , ' with scrambled images included.']);
end

% -- normalize

nBlocks = length(allBlockStarts);
for i = 1:length(allTrialTypes);
    trial = char(allTrialTypes{i});
    for j = 1:length(drugTypes);
        drug = char(drugTypes{j});
        for k = 1:length(dosages);
            dose = char(dosages{k});
            switch normalizeBy
                case 'saline'
                    for h = 1:nBlocks;
                        salVals = images.(trial).(drug)(h).('saline');
                        toNorm = images.(trial).(drug)(h).(dose);
                        if strcmp(params.normMethod,'divide');
                            images.(trial).(drug)(h).(dose) = toNorm;
                            images.(trial).(drug)(h).(dose)(:,1) = ...
                                toNorm(:,1) ./ salVals(:,1);
                        elseif strcmp(params.normMethod,'subtract');
                            images.(trial).(drug)(h).(dose) = toNorm;
                            images.(trial).(drug)(h).(dose)(:,1) = ...
                                toNorm(:,1) - salVals(:,1);
                        end
                    end
                case 'scrambled'
                    for h = 1:nBlocks;
                        scrambledVals = images.('scrambled').(drug)(h).(dose);
                        toNorm = images.(trial).(drug)(h).(dose);
                        if strcmp(params.normMethod,'divide');
                            images.(trial).(drug)(h).(dose) = toNorm;
                            images.(trial).(drug)(h).(dose)(:,1) = ... 
                                toNorm(:,1) ./ scrambledVals(:,1);
                        elseif strcmp(params.normMethod,'subtract');
                            images.(trial).(drug)(h).(dose) = toNorm;
                            images.(trial).(drug)(h).(dose)(:,1) = ...
                                toNorm(:,1) - scrambledVals(:,1);
                        end
                    end
            end
        end
    end
end
            
        
