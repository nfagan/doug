% barPlots.m - function for generating a bar plot, intended to be run
% after function genTable.m
%
%       Takes as input data matrix M, where M is expected to be a Block by
%       Stimulus matrix (i.e., blocks are rows, stimuli are columns). Then
%       specify whether to plot all stimuli for each block ('all'); 
%       one stimulus for each block ('per stimulus'); or all stimuli for 
%       one block ('per block');
%
%       If plotting 'all' stimuli, the third input must be the image
%           labels (usually, allTrialTypes). 
%       If plotting 'per stimulus', the third input must be the desired
%           stimulus, and the fourth input the image labels (again,
%           usually, allTrialTypes).
%       If plotting 'per block', the third input must be the block number,
%           and the fourth input the image labels.
%
%       You can, at any time, define the y limits by adding a final array
%           input with two values ([ymin ymax]).

function barPlots(M,varargin)

% --------------------------------
% define global variables and ensure inputs are valid
% --------------------------------

global toExamine;

cases = {'per stimulus','per block','all'};

whatToPlot = varargin{1};

checkCorrectSyntax = zeros(3);
for i = 1:length(cases);
    toCmp = cases{i};
    if strcmp(toCmp,whatToPlot);
        checkCorrectSyntax(i) = 1;
    end
end

if ~any(checkCorrectSyntax);
    error('Wrong input format. Possible ways of plotting are: ''all'', ''per stimulus'', or ''per block''');
end

if ~strcmp(whatToPlot,'per stimulus')

    if strcmp(whatToPlot,'per block') && length(varargin) < 3
        error('If examining things per block, add a block number and image labels');
    else
        if strcmp(whatToPlot,'per block') && ~isa(varargin{2},'double')
            error('If examining things per block, the third input must be an integer block number');
        end
    end

    if ~iscell(varargin{2}) && strcmp(whatToPlot,'all');
        error('If examining all blocks, third input must be image labels');
    end
    
else
    if length(varargin) < 3;
        error('If examining things per stimulus, the third input must be the desired image, and the fourth must be all possible images');
    else
        if ~(isstr(varargin{2}) && iscell(varargin{3}))
            error('If examining things per stimulus, the third input must be the desired image, and the fourth must be all possible images');
        end
    end
end

% --------------------------------
% get rid of scrambled images if plotting normalized proportion
% --------------------------------

if strcmp(toExamine,'normalized proportion');
    M = M(:,2:end);
end

% --------------------------------
% parse inputs and plot accordingly
% --------------------------------

switch whatToPlot
    case 'all'   
        allTrialTypes = varargin{2};
        
        if strcmp(toExamine,'normalized proportion');
            allTrialTypes{1} = [];
            allTrialTypes = remEmpty(allTrialTypes);
        end
        
        toXLabel = 'Block Number';
        
        bar(M);
        xlabel(toXLabel);
        legend(allTrialTypes);
    
    case 'per stimulus'
        
        wantedImage = varargin{2};
        allTrialTypes = varargin{3};
        
        if strcmp(toExamine,'normalized proportion');
            allTrialTypes{1} = [];
            allTrialTypes = remEmpty(allTrialTypes);
        end
        
        inds = 1:length(allTrialTypes);
        d = strcmp(wantedImage,allTrialTypes);
        
        if ~any(d);
            error('Confirm that the desired stimulus is spelled correctly & is included in allTrialTypes');
        end
        
        wantedImage(1) = upper(wantedImage(1));
        
        ind = inds(d);
        bar(M(:,ind),'k');        
        toXLabel = sprintf('Blocks of %s Images',wantedImage);        
        xlabel(toXLabel);
        
    case 'per block'
        
        blockNumber = varargin{2};
        allTrialTypes = varargin{3};   
        
        if strcmp(toExamine,'normalized proportion');
            allTrialTypes{1} = [];
            allTrialTypes = remEmpty(allTrialTypes);
        end
        
        bar(M(blockNumber,:),'k');
        set(gca,'xticklabel',allTrialTypes);
        
        toTitle = sprintf('Block Number %d',blockNumber);
        
        title(toTitle);
        xlabel('Stimulus Type');
end

% --------------------------------
% optionally define y limits, if the input is specified
% --------------------------------

lastInput = varargin{end};

if isa(lastInput,'double') && length(lastInput) == 2;
    ylim(lastInput);
end

% --------------------------------
% label y axis according to global variable toExamine
% --------------------------------

switch toExamine
    case 'average duration'
        ylabel('Average Duration of Fixation Event (ms)');
    case 'proportion'
        ylabel('Proportion of Fixations ROI : Whole Face');
    case 'raw counts'
        ylabel('Number of Fixations');
    case 'n images'
        ylabel('Number of Images Seen');
end


        