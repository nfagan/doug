function meanSaveData = acrossMonkeys(saveData)

    for i = 1:length(saveData{1});
        for j = 1:size(saveData{1}{1},1);
            for k = 1:size(saveData{1}{1},2);                
                for ik = 1:length(saveData{1}{1}{1,1});
                    for ij = 1:length(saveData{1}{1}{1,1}{1});                        
                        fieldNames = fieldnames(saveData{1}{1}{1,1}{1}{1});                        
                        for il = 1:length(fieldNames);
                            storeCurrent = [];
                            for ii = 1:length(saveData);
                                if ii == 1;
                                    storeCurrent = saveData{ii}{i}{j,k}{ik}{ij}.(fieldNames{il});
                                else
                                    update = saveData{ii}{i}{j,k}{ik}{ij}.(fieldNames{il});
                                    storeCurrent = vertcat(storeCurrent,update);
                                end
                            end
                            
%                             if strcmp(fieldNames{il},'nImages') % if looking at the number of images, add number of images
%                                 storeCurrent = sum(storeCurrent);
%                             end
                            meanSaveData{1,i}{j,k}{ik,1}{1,ij}.(fieldNames{il}) = storeCurrent;
                        end
                    end
                end
            end
        end
    end
