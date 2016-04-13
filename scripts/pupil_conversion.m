monkeys = {'coppola','joda','lager'};
drugs = {'N','OT','OTN'};
startDir = '/Volumes/My Passport/NICK/Chang Lab 2016/edf2mat';

for k = 1:length(monkeys);
    fprintf('\n%s',monkeys{k});
    for j = 1:length(drugs);
        fprintf('\n\t%s',drugs{j});
        edfDir = fullfile(startDir,monkeys{k},drugs{j});
        cd(edfDir);

        d = dir('*.edf');
        matDir = dir('*.mat');
        
        if isempty(matDir)

            for i = 1:length(d);

                fileName = d(i).name;
                
                fprintf('\n\t\t%s',fileName);

                edf = Edf2Mat(fileName);

                pupil = [edf.Samples.time edf.Samples.pupilSize];

                rev = fliplr(fileName);
                rev = fliplr(rev(5:end));
                
                lowerFile = lower(rev);
                if strncmpi(lowerFile,'img',3);
                    cols = 1:length(lowerFile);
                    underScoreInd = min(cols(lowerFile == '_'));
                    
                    id = rev(underScoreInd+1:end);
                    
                    rev = sprintf('pupil %s.mat',id);
                else
                    
                    rev = sprintf('pupil %s.mat',rev);
                    
                end                   
                
                save(rev,'pupil');
            end
        end
    end 
end