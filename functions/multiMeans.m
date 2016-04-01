% multiMeans.m - function for obtaining the grand mean and (SEM) of fields
% of the 'images' data struct. Usually will only be used inside
% plotting functions which take 'images' as an input.

function [GM,stdError] = multiMeans(d)

if size(d,2) == 3;
    error('Missing degrees of freedom data.');
elseif size(d,2) < 3;
    error('Missing variance or degrees of freedom data.')
end

means = d(:,1);% means are first column
vari = d(:,3); %variance is third column
n = d(:,4); %n samples is fourth column
N = sum(n); %total samples

GM = mean(means);
ESS = sum(vari.*(n-1)); %weight the variance by the sample size of each, and sum for total variance
TGSS = sum((means - GM).^2 .* n); %get the variances of each sample mean 
                                  %about the grand mean, and weight by
                                  %sample size

GV = (TGSS + ESS)/(N-1); %total variance is a sum of int. and grand-mean variances,
                         %divided by (total samples - 1)
                         
stdDev = sqrt(GV); %grand std deviation
stdError = stdDev/sqrt(N);


