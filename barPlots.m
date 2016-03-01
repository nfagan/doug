function barPlots(M,varargin)

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

switch whatToPlot
    case 'all'   
        allTrialTypes = varargin{2};
        
        for j = 1:length(allTrialTypes);
            if j == 1;
                wholeStr = allTrialTypes{j};
            else
                toAdd = allTrialTypes{j};
                wholeStr = sprintf('%s, %s',wholeStr,toAdd);
            end
        end
        
        toXLabel = strcat('Block Number | Images : ',wholeStr);
        
        bar(M);
        xlabel(toXLabel);
    
    case 'per stimulus'
        
        wantedImage = varargin{2};
        allTrialTypes = varargin{3};
        inds = 1:length(allTrialTypes);
        d = strcmp(wantedImage,allTrialTypes);
        
        if ~any(d);
            error('Confirm that the desired stimulus is spelled correctly & is included in allTrialTypes');
        end
        
        wantedImage(1) = upper(wantedImage(1));
        
        ind = inds(d);
        bar(M(:,ind));        
        toXLabel = sprintf('Blocks of %s Images',wantedImage);        
        xlabel(toXLabel);
        
    case 'per block'
        
        blockNumber = varargin{2};
        allTrialTypes = varargin{3};        
        bar(M(blockNumber,:));
        set(gca,'xticklabel',allTrialTypes);
        
        toTitle = sprintf('Block Number %d',blockNumber);
        
        title(toTitle);
        xlabel('Stimulus Type');
end

lastInput = varargin{end};

if isa(lastInput,'double') && length(lastInput) == 2;
    ylim(lastInput);
end
    

% ylabel('Number of Fixations');


        