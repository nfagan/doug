function umbrellaDirectory = getUmbrDir(monkey,drugType,dosage)

switch monkey
    case 'Kurosawa'
        monkDir = '/Users/Doug/....'; %path to monkey directory
    case 'Lager'
        monkDir = '/Users/Doug/....';
    case ''
        monkDir = '/Users/Doug/....';
end

switch drugType
    case 'OTN'
        sm = '.5'; %folder names ... fill in
        md = '.1';
        lg = '1';
    case 'OT'
        sm = '';
        md = '';
        lg = '';
    case 'N'
        sm = '';
        md = '';
        lg = '';
    case 'saline'
        sm = ''; % make the same for each dosage
        md = '';
        lg = '';
end

switch dosage
    case 'all'
        umbrellaDirectory = fullfile(monkDir,drugType,'all');
    case 'small'
        umbrellaDirectory = fullfile(monkDir,drugType,sm);
    case 'medium'
        umbrellaDirectory = fullfile(monkDir,drugType,md);
    case 'large'
        umbrellaDirectory = fullfile(monkDir,drugType,lg);
end
        
        



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