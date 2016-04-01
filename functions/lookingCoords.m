function coordinates = lookingCoords(proportionType)

firstType = 'roi to whole face';
secondType = 'whole picture to whole screen';

if ~strcmp(proportionType,firstType) && ~strcmp(proportionType,secondType);
    error('''%s'' is not a recognized proportion type. Possible inputs are:\n''%s''\n''%s''',...
        proportionType,firstType,secondType)
end
    

switch proportionType
    case 'roi to whole face'
        
        roiPos.minX = 620;
        roiPos.maxX = 980;
        roiPos.minY = 345;
        roiPos.maxY = 495;

        wholePos.minX = 600;
        wholePos.maxX = 1000;
        wholePos.minY = 250;
        wholePos.maxY = 650;
        
    case 'whole picture to whole screen'
        
        roiPos.minX = 620;
        roiPos.maxX = 980;
        roiPos.minY = 345;
        roiPos.maxY = 495;

        wholePos.minX = 600;
        wholePos.maxX = 1000;
        wholePos.minY = 250;
        wholePos.maxY = 650;
end

coordinates = {roiPos,wholePos};
        
        


