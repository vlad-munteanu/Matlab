% Intialize Variables with user input
prompt = 'Enter fish weights in kg as a vector: ';
fishWeights = input(prompt);

sGradeCount = zeros(1,2); 
aGradeCount = zeros(1,2);
bGradeCount = zeros(1,2);
cGradeCount = zeros(1,2);
dGradeCount = zeros(1,2); 
nGradeCount = 0; 


% First for loops to enter weights  
for i=1:length(fishWeights)
    if 30 < fishWeights(i) 
        sGradeCount(1) = sGradeCount(1) + 1; 
        sGradeCount(2) = sGradeCount(2) + fishWeights(i);
    elseif 16 < fishWeights(i) && fishWeights(i) <= 30 
        aGradeCount(1) = aGradeCount(1) + 1; 
        aGradeCount(2) = aGradeCount(2) + fishWeights(i);
    elseif 8 < fishWeights(i) && fishWeights(i) <= 16 
        bGradeCount(1) = bGradeCount(1) + 1; 
        bGradeCount(2) = bGradeCount(2) + fishWeights(i);
    elseif 3 < fishWeights(i) && fishWeights(i) <= 8 
        cGradeCount(1) = cGradeCount(1) + 1; 
        cGradeCount(2) = cGradeCount(2) + fishWeights(i);
    elseif 1 <= fishWeights(i) && fishWeights(i) <= 3 
        dGradeCount(1) = dGradeCount(1) + 1; 
        dGradeCount(2) = dGradeCount(2) + fishWeights(i);
    elseif fishWeights(i) < 1  
        nGradeCount = nGradeCount + 1;
    end 
end

sGradeIncome = (sGradeCount(1)*22);
% Second for loop to caculate invoice 
fprintf("S Grade: \nTotal number of fish: %d; \nTotal weight: %d, \nTotal Income: $%.2f \n\n", sGradeCount(1),sGradeCount(2),(sGradeCount(2)*22));
fprintf("A Grade: \nTotal number of fish: %d; \nTotal weight: %d, \nTotal Income: $%.2f \n\n", aGradeCount(1),aGradeCount(2),(aGradeCount(2)*15.6));
fprintf("B Grade: \nTotal number of fish: %d; \nTotal weight: %d, \nTotal Income: $%.2f \n\n", bGradeCount(1),bGradeCount(2),(bGradeCount(2)*6.3));
fprintf("C Grade: \nTotal number of fish: %d; \nTotal weight: %d, \nTotal Income: $%.2f \n\n", cGradeCount(1),cGradeCount(2),(cGradeCount(2)*3.7));
fprintf("D Grade: \nTotal number of fish: %d; \nTotal weight: %d, \nTotal Income: $%.2f \n\n", dGradeCount(1),dGradeCount(2),(dGradeCount(2)*1.2));
fprintf("You caught %d fish that need to be released \n", nGradeCount);

totalIncome = (sGradeCount(2)*22) + (aGradeCount(2)*15.6) + (bGradeCount(2)*6.3) + (cGradeCount(2)*3.7) + (dGradeCount(2)*1.2);

fprintf("Total Income (for all grades): $%.2f\n", totalIncome);

