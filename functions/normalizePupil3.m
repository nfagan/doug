% [normalized,normLabels] = normalize_pupil3(storeValues,storeLabels,baselineAmt,binSize)

baseline = storeValues(:,1:baselineAmt); %get baseline non-normalized pupil size
from0 = storeValues(:,baselineAmt+1:end); %get pupil size from t = 0

nBins = round(size(storeValues,2)/binSize); %calculate number of bins

normalizeBy = mean(baseline,2);

for i = 1:nBins
    binned = from0(:,1+stp:i*binSize); %extract a time bin from from0
    binned = mean(binned,2); %get the row-mean of the bin
    intNormalized = binned ./ normalizeBy; %normalize the row-mean 
    normalized(:,1+stp:i*binSize) = intNormalized; %store the normalized values
end

    




    
    
