%{
Clears console before program runs because
having to manually clear the screen annoys me.
%}
clear; clc; close all; 

% Import DAT data 
toyStoryData = readtable('toystory.csv');

% Put into Local Variables
year = toyStoryData.Year;
month = toyStoryData.Month;
searchInterest = toyStoryData.SearchInterest;

sortedYear = zeros(15,12);

% Places Year and Search Interest in Matrix 
counter = 1; 
for x = 1:16
    for y = 1:12 
        if x ~= 16 
            sortedYear(x,y) = searchInterest(counter);
        elseif y <= 10 
            sortedYear(x,y) = searchInterest(counter);
        else 
           sortedYear(x,y) = 0;     
        end 
        counter = counter + 1;
    end 
end 


% Lets Plot a Bar Graph! 
x = [2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019]; 
y = sortedYear; 
bar(x, y); 
xlabel('Years')
ylabel('Search Interest')
title('Search Interest for every month over 15 years');

% Calculations 
meanSearchInterest = mean(searchInterest); 
% Calculate IQR 
% We only care about positive here since we're looking for peaks
outlierTreshold = iqr(searchInterest) * 1.5; 

maxInterest = 0; 

% Find Max
for x = 1:size(searchInterest)
    if searchInterest(x) > outlierTreshold 
        if searchInterest(x) > maxInterest 
            maxInterest = searchInterest(x); 
        end 
    end 
end 

inputNum = 1; 
% User Input
while inputNum ~= 0
    
    % Prompt User 
    prompt = 'Enter Year you want to gain info on (Enter 0 to exit program):';
    inputNum = input(prompt);
    
    % Adjust year to index 
    calculatedIndex = 16 - (2019 - inputNum); 
    maxInterestThatYear = 0;
    outlierCount = 0; 
    
    for z = 1:12 
        if sortedYear(calculatedIndex, z) == maxInterestThatYear 
            maxInterestThatYear = 1;
        end 
        if sortedYear(calculatedIndex, z) > outlierTreshold 
            outlierCount = outlierCount + 1;
        end 
    end 
    
    % Output 
    if maxInterestThatYear == 1 
        fprintf("The maximum amount of interest of any month occured this year with %d searches in one month\n", maxInterest);
    else 
        disp("The maximum amount of interest of any month did not occured this year.");
    end
    fprintf("There were a total of %d outliers\n",outlierCount);
end 






