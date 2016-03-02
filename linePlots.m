function linePlots(M,varargin)

% --------------------------------
% define default parameters
% --------------------------------

global allTrialTypes

if ~iscell(M);
    M{1} = M;
end

params = struct(...
    'xAxis','dose',...
    'lineType','per stimulus',...
    'subPlot',1, ...
    'allStimuli',0, ...
    'wantedStimulus','scrambled');

paramNames = fieldnames(params);

% --------------------------------
% overwrite defaults with specified inputs
% --------------------------------

nArgs = length(varargin);
if round(nArgs/2)~=nArgs/2
   error('Name-value pairs are incomplete!')
end

for pair = reshape(varargin,2,[])
   inpName = pair{1};
   if any(strcmp(inpName,paramNames))
      params.(inpName) = pair{2};
   else
      error('%s is not a recognized parameter name',inpName)
   end
end

% --------------------------------
% check validity of inputs
% --------------------------------

if strcmp(params.xAxis,'time') && params.allStimuli == 1;
    d = 1;
end

% --------------------------------
% switch based on inputs and clean up data matrix M
% --------------------------------

cols = 1:length(allTrialTypes);
checkImageCol = strcmp(allTrialTypes,params.wantedStimulus);
ind = cols(checkImageCol);

if strcmp(params.xAxis,'dose');
    for i = 1:length(M);
        M{i} = mean(M{i})';
    end  
end

switch params.lineType
%     case 'per stimulus'
        
    case 'per drug'
        if params.allStimuli == 0;
            for i = 1:length(M);
                M{i} = M{i}(:,ind);
            end
        end
end

% --------------------------------
% plot
% --------------------------------

hold on;
for k = 1:length(M);       
    plot(M{k});
end




        