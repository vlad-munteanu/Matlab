%{ 
Clears console before program runs because 
having to manually clear the screen annoys me. 
%} 
clc;

%Get user input
prompt = "What is the desired batch size in kg? ";  
batchSize = input(prompt);

%Create time vector
timeVector = 1:30;

%Generate substance 1 rate vector in kg/min
rateVector1 = (timeVector)/30;

%Generate substance 2 rate vector in kg/min
rateVector2 = (timeVector * (batchSize + 5))/(200);

%combine vectors 
finalArray = [timeVector.' rateVector1.' rateVector2.'];

%Write to csv file
csvwrite('91071_MunteanuVlad_SubstanceRates.csv',finalArray);

%Notify user
disp('.csv file created, named 91071_MunteanuVlad_SubstanceRates.csv');
