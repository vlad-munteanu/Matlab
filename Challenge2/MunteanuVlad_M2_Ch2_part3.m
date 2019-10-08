% Intial variables
gpa = 0.0;
gpaCalcNumerator = 0.0;
gpaCalcDenominator = 0.0;



% Loop through classes
for classNum = 1:4
    % prompt user for input 
    fprintf('How many credit hours is class #%d? \n', classNum);
    prompt2 = "";
    credits = input(prompt2);
    
    fprintf('What is your excepted grade for class #%d on the 4.0 scale? \n', classNum);
    prompt1 = "";
    grade = input(prompt1);
    
    
    
    gpaCalcNumerator = gpaCalcNumerator + (grade * credits);
    gpaCalcDenominator = gpaCalcDenominator + credits;
end

gpa = gpaCalcNumerator/gpaCalcDenominator;
% Output to user 
disp("Your GPA for this semester is: " + gpa);