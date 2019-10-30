%{
Clears console before program runs because
having to manually clear the screen annoys me.
%}
clc;

% Intializes Variables with user input
prompt = 'Please enter a vector containing the haul weights: ';
fishWeights = input(prompt);


% Intializes zero vectors for fish data
sGradeCount = zeros(1,2); 
aGradeCount = zeros(1,2);
bGradeCount = zeros(1,2);
cGradeCount = zeros(1,2);
dGradeCount = zeros(1,2); 


% Enter weights and sort
for i=1:length(fishWeights)
    if 30 < fishWeights(i) 
        sGradeCount(1) = sGradeCount(1) + 1; 
        sGradeCount(2) = sGradeCount(2) + fishWeights(i);
    elseif 20 < fishWeights(i) && fishWeights(i) <= 30 
        aGradeCount(1) = aGradeCount(1) + 1; 
        aGradeCount(2) = aGradeCount(2) + fishWeights(i);
    elseif 10 < fishWeights(i) && fishWeights(i) <= 20 
        bGradeCount(1) = bGradeCount(1) + 1; 
        bGradeCount(2) = bGradeCount(2) + fishWeights(i);
    elseif 5 < fishWeights(i) && fishWeights(i) <= 10 
        cGradeCount(1) = cGradeCount(1) + 1; 
        cGradeCount(2) = cGradeCount(2) + fishWeights(i);
    elseif 0 <= fishWeights(i) && fishWeights(i) <= 5 
        dGradeCount(1) = dGradeCount(1) + 1; 
        dGradeCount(2) = dGradeCount(2) + fishWeights(i);
    end 
end

% Calculate Income
wholeFishIncome = (sGradeCount(2)*20);
filletIncome = (aGradeCount(2)*15);
canningIncome = (bGradeCount(2)*6);
petFoodIncome = (cGradeCount(2)*4);
fishExtractsIncome = (dGradeCount(2)); 

% Display to user
fprintf("You caught %d kg of fish for Whole Fish, to be sold for $%.0f \n",sGradeCount(2),wholeFishIncome);
fprintf("You caught %d kg of fish for Fillet, to be sold for $%.0f \n", aGradeCount(2),filletIncome);
fprintf("You caught %d kg of fish for Canning, to be sold for $%.0f \n", bGradeCount(2),canningIncome);
fprintf("You caught %d kg of fish for Pet Food, to be sold for $%.0f \n", cGradeCount(2),petFoodIncome);
fprintf("You caught %d kg of fish for Fish Extracts, to be sold for $%.0f \n", dGradeCount(2),fishExtractsIncome);

totalIncome = wholeFishIncome + filletIncome + canningIncome + petFoodIncome + fishExtractsIncome;

fprintf("Your total income for this haul is $%.0f\n", totalIncome);

