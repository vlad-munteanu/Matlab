% Intialize Variables
numOfSigs = 0; 
numOfDays = 0;
% Loop until numOfSigs equals 1000 
while numOfSigs < 1200 
    prompt = 'What is the date number? ';
    numOfDays = input(prompt);
    
    prompt2 = 'Number of collected signatures for that day? ';
    numOfSigs = numOfSigs + input(prompt2);
end 

% Print out to user
fprintf("It took %d days to collect %d signatures \n", numOfDays, numOfSigs);

