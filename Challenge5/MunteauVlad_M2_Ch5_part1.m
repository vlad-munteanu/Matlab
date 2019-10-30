%{
Clears console before program runs because
having to manually clear the screen annoys me.
%}
clc;

% Intialize Variables
donationCount = 0; 
dayCount = 0;
% Loop until donations equal $1000 
while donationCount < 1000 
    prompt = 'What is the date number? ';
    dayCount = input(prompt);
    
    prompt2 = 'How much money did you raise today? ';
    donationCount = donationCount + input(prompt2);
end 

% Displays to user

fprintf("You met your goal of $1000 on the %d th day \n", dayCount);
fprintf("You raised a total of  $%d \n", donationCount);

