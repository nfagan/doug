function label = yLabeler

global toExamine;
global region;

switch toExamine;
    case 'proportions'
        switch region
            case 'eyes'
                label = 'Mean Proportion of Fixations Eyes : Whole Face';
            case 'image'
                label = 'Mean Proportion of Fixations Whole Image : Whole Screen';
            case 'screen'
                label = 'Mean Proportion of Fixations Whole Image : Whole Screen';
        end
    case 'lookingDuration'
        label = 'Mean Looking Time (ms)';
    case 'fixEventDuration'
        label = 'Mean Duration of a Fixation Event (ms)';
    case 'meanLookingDuration'
        label = 'Mean Looking Time (ms)';
    case 'meanFixEventDuration'
        label = 'Mean Duration of a Fixation Event (ms)';
    case 'nImages'
        label = 'Mean Number of Images Seen';
    case 'nFixations'
        label = 'Mean Number of Fixations to an Image';
    case 'pupilSize'
        switch region
            case 'eyes'
                label = 'Mean Pupil Size During Fixations to Eyes';
            case 'image'
                label = 'Mean Pupil Size During Fixations to Image';
        end
end


