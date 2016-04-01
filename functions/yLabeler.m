function label = yLabeler

global toExamine;

switch toExamine;
    case 'proportions'
        label = 'Mean Proportion of Fixations ROI : Whole Face';
    case 'meanLookingDuration'
        label = 'Mean Looking Time (ms)';
    case 'meanFixEventDuration'
        label = 'Mean Duration of a Fixation Event (ms)';
    case 'nImages'
        label = 'Mean Number of Images Seen';
    case 'nFixations'
        label = 'Mean Number of Fixations to an Image';
end


