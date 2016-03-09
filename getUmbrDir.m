function [umbrellaDirectory,varargout] = getUmbrDir(monkey,drugType,dosage)

switch monkey
    case 'Coppola'
        monkDir = '/Users/dougstreat/Google Drive/PSYC Thesis/Raw Data/Coppola';
%         monkDir = '/Volumes/My Passport/NICK/Chang Lab 2016/doug/data/';
%         monkDir = 'C:\Users\changLab\doug\data';
    case 'Lager'
        monkDir = '/Users/dougstreat/Google Drive/PSYC Thesis/Raw Data/Lager';
    case 'Joda'
        monkDir = '/Users/dougstreat/Google Drive/PSYC Thesis/Raw Data/Joda';
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