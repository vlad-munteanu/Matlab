%{
Clears console before program runs because
having to manually clear the screen annoys me.
%}
clc;

%Get user input & initialize variables
prompt = "Please input your blood glucose level in mg/Dl: ";
glucoseLevel1 = input(prompt);

prompt2 = "Please input your second reading of blood glucose level in mg/Dl: ";
glucoseLevel2 = input(prompt2);

bglChange = glucoseLevel2 - glucoseLevel1;

%Conditional Statements 
if bglChange >= 10
    disp("There is a significant increase in blood glucose level"); 
elseif bglChange <= -10
    disp("There is a significant decrease in blood glucose level"); 
else 
    disp("There is no significant change in blood glucose level"); 
end 

if glucoseLevel2 > 250 
    disp('Blood glucose level is unsafely high for exercise.');
elseif glucoseLevel2 < 70 
    disp('Blood glucose level is unsafely low for exercise.');
end 

