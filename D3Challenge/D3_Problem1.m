%{ 
Header
%} 

% clears console and workspace
clear;
clc;

batchSize = input("Enter desired batch size (kg): ");
TIME = 1:0.5:60;

substanceOneRate = TIME/30;
substanceTwoRate = TIME*(batchSize + 10)/325;

combinedVec = [TIME;substanceOneRate;substanceTwoRate];

csvwrite("D3_yourPID_SubstanceRates.csv", combinedVec);

disp("Csv file has been created, named: D3_yourPID_SubstanceRates.csv");