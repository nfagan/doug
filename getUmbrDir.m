function umbrellaDirectory = getUmbrDir(monkey,drugType,dosage)

switch monkey
    case 'Kuro'
        monkDir = '/Users/Doug/....';
    case 'Lager'
        monkDir = '/Users/Doug/....';
    case ''
        monkDir = '/Users/Doug/....';
end

umbrellaDirectory = fullfile(monkDir,drugType,dosage);

% 
% 
% 
% 
% 
% switch drugType
%     case 'OTN'
%         switch dosage
%             case '.5N'
%                 umbrellaDirectory = fullfile(monkDir,'folderName');
%             case '1N'
%                 umbrellaDirectory = fullfile(monkDir,'folderName');
%             case 'all'
%                 umbrellaDirectory = fullfile(monkDir,'folderName');
%         end
%                 
%     case 'N'
%         switch dosage
%             case 'd'
%                 umbrellaDirectory = fullfile(monkDir,'folderName');
%             case 'd'
%                 umbrellaDirectory = fullfile(monkDir,'folderName');
%             case 'all'
%                 umbrellaDirectory = fullfile(monkDir,'folderName');
%         end
%     case 'Saline'
%         switch dosage
%             case 'd'
%                 umbrellaDirectory = fullfile(monkDir,'folderName');
%             case 'd'
%                 umbrellaDirectory = fullfile(monkDir,'folderName');
%             case 'all'
%                 umbrellaDirectory = fullfile(monkDir,'folderName');
%         end
% end