% reformatData.m - function for reformatting and plotting M data generated
% by genTable.m.
% 
%   With this function, you can specify what each line of the line graph
%   corresponds to, and what's on the x-axis. All possible inputs are:
%
%       'lineType'
%           'per stim' -- plots with each line as a type of image
%               OR
%           'per drug' -- plots with each line as a type of drug
%       'xAxis'
%           'dose' -- each x coordinate is a dosage of drug
%           'time' -- each x coordinate is a block number
%       'limis'
%           [a b] -- specify a two element vectory where a < b. This
%           adjusts the y limits of the plots
%


function outputM = reformatData(M,varargin)

% --------------------------------
% define default parameters
% --------------------------------

global drugTypes;
global dosages;
global allTrialTypes
global toExamine;

if ~iscell(M);
    error(['M must be a cell array generated from getSaveData.m. If you''d' ...
        , ' like, make M{1} = M, but understand that something has probably' ...
        , ' gone wrong.']);
end

params = struct(... %default values of params struct
    'lineType','per stim', ...
    'xAxis','dose',...
    'limits',[], ...
    'wantedStimulus','scrambled', ...
    'lookPerBlock',0);    

paramNames = fieldnames(params);

switch toExamine
    case 'average duration'
        toYLabel = 'Average Duration of Fixation Event (ms)';
    case 'proportion'
        toYLabel = 'Proportion of Fixations ROI : Whole Face';
    case 'raw counts'
        toYLabel = 'Number of Fixations';
    case 'n images'
        toYLabel = 'Number of Images Seen';
end

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
% check validity of inputs and clean up as necessary
% --------------------------------

if params.lookPerBlock > 0 && strcmp(params.xAxis,'time');
    error('You can only specify a block number when looking at dosage.');
end

if strcmp(params.lineType,'per drug') && strcmp(params.xAxis,'time') && ...
        size(M,2) > 1;
    warning(['M contains multiple dosages, and what''s plotted will be an' ...
        , ' average across these! Confirm that you didn''t intend to plot' ...
        , ' with ''xAxis'' as ''dose'' or with ''lineType'' as ''per stim''.']);
    
    for j = 1:size(M,1);
        d = [];
        for k = 1:size(M,2);
            if k == 1;
                d = M{j,k};
            else
                d = d + M{j,k};
            end
        end
        d = d/size(M,2);
        M2{j,1} = d;
    end
    M = M2;
    
end

if strcmp(params.lineType,'per drug') && strcmp(params.xAxis,'dose');
    for j = 1:size(M,1);
        for k = 1:size(M,2);
            if params.lookPerBlock == 0;
                M{j,k} = mean(M{j,k});
            else
                blockN = params.lookPerBlock;
                M{j,k} = M{j,k}(blockN,:);
            end
        end
    end
end

if strcmp(params.xAxis,'dose') && size(M,2) == 1;
    warning(['M contains only one dosage. Confirm you didn''t intend to' ...
        , ' plot with time on the x axis.']);
end

if strcmp(params.xAxis,'dose') && strcmp(params.lineType,'per stim') && size(M,1) > 1;
    warning(['M contains multiple drugs'' worth of data; what''s plotted will' ...
        , ' be an average across drugs!']);
    for j = 1:size(M,2);
        d = [];
        for k = 1:size(M,1);
            if k == 1;
                d = M{k,j};
            else
                d = d + M{k,j};
            end
        end
        d = d ./ size(M,1);
        M2{1,j} = mean(d);
        
    end
    M = M2;
end

if strcmp(params.lineType,'per drug') && size(M,1) == 1;
    warning(['M contains only one drug type, and will default to plotting' ...
        , ' scrambled images. This likely isn''t what you''re looking for.' ...
        , 'make sure you didn''t mean to make ''lineType'', ''per stim''']);
end

if strcmp(params.lineType,'per stim') && strcmp(params.xAxis,'time') && ...
        size(M,1) > 1;
    warning('M contains multiple drugs. What''s plotted will be an average across these.');
    for j = 1:size(M,2);
        d = [];
        for k = 1:size(M,1);
            if k == 1;
                d = M{k,j};
            else
                d = d + M{k,j};
            end
        end
        d = d./size(M,1);
    m2{j} = d;
    end
    M = m2;
end        

if strcmp(params.lineType,'per stim') && strcmp(params.xAxis,'time') && ...
        size(M,2) > 1;
    warning('M contains multiple dosages. What''s plotted will be an average across these.');
    m2 = [];
    for j = 1:size(M,1);
        d = [];
        for k = 1:size(M,2);
            if k == 1;
                d = M{j,k};
            else
                d = d + M{j,k};
            end
        end
        d = d./size(M,2);
    m2{j} = d;
    end
    M = m2;
    
end
outputM = M;

% --------------------------------
% plot
% --------------------------------
hold on;

if strcmp(params.lineType,'per stim') && strcmp(params.xAxis,'time');
    plot(M{1});
    xlabel('Block Number');
    ylabel(toYLabel);
    
    if ~isempty(params.limits);
        ylim(params.limits);
    end
    legend(allTrialTypes);
end

if strcmp(params.lineType,'per stim') && strcmp(params.xAxis,'dose');
    for i = 2:length(M);        
        M2{1}(i,:) = M{i};
    end
    M = M2;
    plot(M{1});
    set(gca,'XTick',(1:size(M,2)));
    set(gca,'XTickLabel',{'small','medium','large'});
    xlabel('Dosage');
    ylabel(toYLabel);
    
    if ~isempty(params.limits);
        ylim(params.limits);
    end
    legend(allTrialTypes);
end

if strcmp(params.lineType,'per drug') && strcmp(params.xAxis,'time'); 
    for i = 1:size(M{1},2);
    oneImage = zeros(size(M,1),size(M{1},1));
    for j = 1:size(M,1);
        oneImage(j,:) = M{j}(:,i);
    end    
    subplot(size(M{1},2),1,i);
    plot(oneImage');
    
    title(char(allTrialTypes{i}));
    if i == round(size(M{1},2)/2);
        ylabel(toYLabel);    
    end

    if ~isempty(params.limits);
        ylim(params.limits);
    end      

end
legend(drugTypes);

xlabel('Block Number');
end

if strcmp(params.lineType,'per drug') && strcmp(params.xAxis,'dose');
    for i = 1:size(M{1},2);
        oneImage = zeros(size(M,1),size(M,2));
        for j = 1:size(M,1);
            for k = 1:size(M,2);
                oneImage(j,k) = M{j,k}(:,i);
            end
        end
        subplot(size(M{1},2),1,i);
        plot(oneImage');        
        title(char(allTrialTypes{i}));
        set(gca,'XTick',(1:size(M,2)));
        if i == round(size(M{1},2)/2);
            ylabel(toYLabel);    
        end
        
        if ~isempty(params.limits);
            ylim(params.limits);
        end        
        
    end
legend(drugTypes);
xlabel('Dosage');
set(gca,'XTickLabel',{'small','medium','large'});
end                        
        
hold off;
    
    

    
        
        
        
        



