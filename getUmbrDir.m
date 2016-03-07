function umbrellaDirectory = getUmbrDir(monkey,drugType,dosage)

switch monkey
    case 'Coppola'
        monkDir = '/Volumes/My Passport/NICK/Chang Lab 2016/doug/data/';
    case 'Lager'
        monkDir = '/Users/Doug/....';
    case ''
        monkDir = '/Users/Doug/....';
end

switch drugType
    case 'OTN'
        sm = '12 IU'; %folder names ... fill in
        md = '24 IU';
        lg = '48 IU';
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