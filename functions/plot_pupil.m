function [storeMean,storeSem] = plot_pupil(normPupil,storeLabels,drug,image,varargin)

doses = unique(storeLabels{4});

params = struct(...
    'addErrorLines',[0],...
    'addStartLines',[1],...
    'limits',[],...
    'save',0, ...
    'monkNames',[], ...
    'binSize',50 ...
    );

params = structInpParse(params,varargin);

baseline = 200 / params.binSize;

startXCoords = [baseline;baseline];
startYCoords = [.5 1.5];

% figure('Visible','off');
figure;
hold on;
stp = 1;
for k = 1:length(doses);
    dose = doses{k};

    dist = separate_data(normPupil,storeLabels,'drugs',{drug},...
        'monkeys',{'all'},'doses',{dose},'images',{image});
    
    if k == 1;
        fprintf('\n\nNumber of data points for %s: %d',dose,size(dist,1));
    else
        fprintf('\nNumber of data points for %s: %d',dose,size(dist,1));
    end
    
    if size(dist,1) > 1;
    
        meanPupil = nanmean(dist);
%         semPupil = [meanPupil + nanSEM(dist);meanPupil - nanSEM(dist)];
        semPupil = [meanPupil + std(dist);meanPupil - std(dist)];
        doseLegend{stp} = dose;
        
    elseif size(dist,1) == 1
        
        meanPupil = dist;
        semPupil = [zeros(1,length(dist));zeros(1,length(dist))];
        doseLegend{stp} = dose;
        
    else
        
        meanPupil = []; semPupil = [];
        
    end
    
    storeMean{k} = meanPupil;
    storeSem{k} = semPupil;
    
    xCoords = [1:size(meanPupil,2);1:size(meanPupil,2)];
    plot(meanPupil,'DisplayName',doseLegend{stp});
    
    stp = stp+1;

    if params.addErrorLines
        if ~isempty(semPupil);
%                 plot(xCoords(j,:),semPupil(j,:),'k','Linewidth',.1,'DisplayName','.');
            plot(xCoords',semPupil','k','Linewidth',.1,'DisplayName','.');
        end
    end

    titleStr = sprintf('%s - %s',drug,image);
    title(titleStr);        
end

% legend(doseLegend);
h = legend('-DynamicLegend');
set(h,'Location','North');

if params.addStartLines;
    plot(startXCoords,startYCoords,'k','DisplayName','.');
end

if ~isempty(params.limits);
    ylim(params.limits);
end

if params.save
    cd('/Volumes/My Passport/NICK/Chang Lab 2016/doug/plots/fixed_plots');
    if ~isempty(params.monkNames)
        saveStr = sprintf('%s_%s_%s',params.monkNames,drug,image);
    else
        saveStr = sprintf('%s_%s',drug,image);
    end
    saveas(gcf,saveStr,'jpg');
end


    

        
        
        
        
        