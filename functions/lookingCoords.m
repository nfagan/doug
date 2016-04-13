function coordinates = lookingCoords()

global region;


if ~strcmp(region,'eyes') && ~strcmp(region,'image') && ~strcmp(region,'screen');
    error('''%s'' is not a recognized region. Possible inputs are:\n''%s''\n''%s''\n ''%s''',...
        region,'eyes','image','screen')
end
    

switch region
    case 'eyes'
        
        roiPos.minX = 620;
        roiPos.maxX = 980;
        roiPos.minY = 345;
        roiPos.maxY = 495;

        wholePos.minX = 600;
        wholePos.maxX = 1000;
        wholePos.minY = 250;
        wholePos.maxY = 650;
        
    case 'image'
        
        roiPos.minX = 600;
        roiPos.maxX = 1000;
        roiPos.minY = 250;
        roiPos.maxY = 650;

        wholePos.minX = 0;
        wholePos.maxX = 1600;
        wholePos.minY = 0;
        wholePos.maxY = 900;
        
    case 'screen'
        
        roiPos.minX = 600;
        roiPos.maxX = 1000;
        roiPos.minY = 250;
        roiPos.maxY = 650;

        wholePos.minX = 0;
        wholePos.maxX = 1600;
        wholePos.minY = 0;
        wholePos.maxY = 900;
        
        
end

coordinates = {roiPos,wholePos};
        
        


