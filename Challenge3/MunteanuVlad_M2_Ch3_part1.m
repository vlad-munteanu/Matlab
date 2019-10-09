
%Output to user using disp
disp("This program outputs the solution to 22/7 in several ways"); 
disp("The solution output with disp is: ");
disp(22/7); 

%Output to user using fprintf with fixed-point notation
fprintf('Output with fprintf: %f \n',22/7);

%Output to user using fprintf with three decimal points
fprintf('Output with fprintf and three decimal points: %.3f \n',22/7);

%Output to user using fprintf with one decimal point
fprintf('Output with fprintf and one decimal point: %.1f \n',22/7);

%Output to user using fprintf with exponential notation
fprintf('Output with fprintf and exponential notation: %e \n',22/7);




