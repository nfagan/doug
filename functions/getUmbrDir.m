function [umbrellaDirectory,varargout] = getUmbrDir(monkey,drugType,dosage)

global compName; compName = lower(compName);

if ~isempty(compName)
    switch compName;
        case 'doug'
            baseDir = '/Users/dougstreat/Google Drive/PSYC Thesis/Raw Data/';
        case 'nick'
            if strcmp(computer,'MACI64');
%                 baseDir = '/Volumes/My Passport/NICK/Chang Lab 2016/doug/';
                baseDir = '/Volumes/My Passport/NICK/Chang Lab 2016/doug/Raw Data';
    
            else
                baseDir = 'C:\Users\changLab\doug\';
            end
    end
else
    baseDir = '/Users/dougstreat/Google Drive/PSYC Thesis/Raw Data/';
end    

switch monkey
    case 'Coppola'
        monkDir = fullfile(baseDir,'Coppola');
    case 'Lager'
        monkDir = fullfile(baseDir,'Lager');
    case 'Joda'
        monkDir = fullfile(baseDir,'Joda');
end

switch drugType
    case 'OTN_2'
        sm = '12 IU'; %folder names ... fill in
        md = '24 IU';
        lg = '48 IU';
        sal = 'Saline';
    case 'OTN'
        sm = '12 IU_0.5 mg';
        md = '24 IU_1 mg';
        lg = '48 IU_2 mg';
        sal = 'Saline';
    case 'OT'
        sm = '12 IU';
        md = '24 IU';
        lg = '48 IU';
        sal = 'Saline';
    case 'N'
        sm = '0.5 mg';
        md = '1 mg';
        lg = '2 mg';
        sal = 'Saline';
    case 'saline'
        sm = ''; % make the same for each dosage
        md = '';
        lg = '';
    case 'OT_test'
        sm = '12 IU'; %folder names ... fill in
        md = '24 IU';
        lg = '48 IU';
end

switch dosage
    case 'all'
        umbrellaDirectory = fullfile(monkDir,drugType,'all');
        doseName = 'all';
    case 'small'
        umbrellaDirectory = fullfile(monkDir,drugType,sm);
        doseName = sm;
    case 'medium'
        umbrellaDirectory = fullfile(monkDir,drugType,md);
        doseName = md;
    case 'large'
        umbrellaDirectory = fullfile(monkDir,drugType,lg);
        doseName = lg;
    case 'saline'
        umbrellaDirectory = fullfile(monkDir,drugType,sal);
        doseName = sal;
end

if nargout > 1;
    varargout{1} = doseName;
end