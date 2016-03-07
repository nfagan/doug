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
    case 'OT_test'
        sm = '12 IU'; %folder names ... fill in
        md = '24 IU';
        lg = '48 IU';
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