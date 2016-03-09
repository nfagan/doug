function plotStim(M,varargin)

% --------------------------------
% define default parameters
% --------------------------------

global drugTypes;
global dosages;
global allTrialTypes
global toExamine;

if ~iscell(M);
    M{1} = M;
end

params = struct(... %default values of params struct
    'lineType','per stim', ...
    'xAxis','dose',...
    'limits',[], ...
    'wantedStimulus','scrambled' ...
    );    

paramNames = fieldnames(params);

addLeg = 1;

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

if strcmp(params.xAxis,'dose') && length(M) == 1;
    warning(['Only one dose is being plotted! This may lead to an' ...
        ' inappropriate plotting format. Try plotting with ''xAxis'' as ''time''']);
    addLeg = 0;
end

if ~isempty(params.limits) && length(params.limits) ~= 2;
    error('Limits must be a two element vector');
end      
    
if strcmp(params.lineType,'per drug') && size(M,1) == 1 && size(M,2) > 1;
    msg = ['M only has one drug''s worth of data.',...
        ' This means that plotted values will be averaged across doses.', ...
        ' Confirm that you didn''t', ...
        ' mean to plot with ''lineType'',''per stim'''];
    warning(msg);
end

if strcmp(params.lineType,'per stim') && size(M,1) > 1;
    warning(['M has more than one drug''s worth of data, so a mean', ...
        ' across drugs will be plotted. Confirm that you didn''t mean to',...
        ' plot with ''lineType'',''per drug''']);
end

% --------------------------------
% extract based on inputs
% --------------------------------

indMatrix = ones(size(M{1},1),size(M{1},2));
if ~strcmp(params.lineType,'per stim')    
    checkImageCol = strcmp(allTrialTypes,params.wantedStimulus);
    indMatrix(:,checkImageCol) = 0; indMatrix = ~indMatrix;    
    toMakeLegend = allTrialTypes{checkImageCol};    
else
    indMatrix = logical(indMatrix); toMakeLegend = allTrialTypes;
end

% --------------------------------
% plot
% --------------------------------

hold on;
    
% --------------------------------
% plot each drug for one stimulus, or optionally a subplot of all
% stimuli
% --------------------------------

switch params.xAxis;
    
    case 'dose'
        
        

% --------------------------------
% add legend
% --------------------------------

if addLeg
    legend(toMakeLegend);
end

% --------------------------------
% optionally add limits
% --------------------------------

if ~isempty(params.limits);
    ylim(params.limits);
end

% --------------------------------
% add appropriate y labels
% --------------------------------
    
switch toExamine
    case 'average duration'
        ylabel('Average Duration of Fixation Event (ms)');
    case 'normalized proportion'
        ylabel('Normalized Proportion of Fixations ROI : Whole Face');
    case 'proportion'
        ylabel('Proportion of Fixations ROI : Whole Face');
    case 'raw counts'
        ylabel('Number of Fixations');
    case 'n images'
        ylabel('Number of Images Seen');
end


            
    



