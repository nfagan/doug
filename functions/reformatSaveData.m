function images = reformatSaveData(saveData)

possibleInputs = ['nImages' '\n' 'proportions' '\n' 'nFixations' '\n' 'meanLookingDuration' ...
    'meanFixEventDuration'];

global allTrialTypes;
global drugTypes;
global dosages;
global toExamine;
global region;

switch region
    case 'roi'
        rg = 1;
    case 'whole face'
        rg = 2;
    otherwise
        error('%s is not a recognized region type. region can be ''roi'' or ''whole face''',region);
end

switch toExamine;
    case 'nImages'
        wantedField = 'nImages';
    case 'proportions'
        wantedField = 'proportions';
    case 'nFixations'
        wantedField = 'nFixationsPerImage';
    case 'meanLookingDuration'
        wantedField = 'meanLookingDuration';
    case 'meanFixEventDuration'
        wantedField = 'meanDurationFixEvent';
    otherwise
        fprintf(possibleInputs);
        error(['\n ''%s'' is not a recognized output of getDur2. See above for possible' ...
            , ' values of toExamine'],toExamine);
end 


for i = 1:length(allTrialTypes);
    for j = 1:length(drugTypes);
        for k = 1:length(dosages);
            for h = 1:length(saveData{1}{1}) % per block
                images.(char(allTrialTypes{i})).(char(drugTypes{j}))(h).(char(dosages{k})) ...
                    = saveData{i}{j,k}{h}{rg}.(wantedField);
            end
        end
    end
end



