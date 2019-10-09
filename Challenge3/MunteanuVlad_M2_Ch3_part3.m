%{ 
Clears console before program runs because 
having to manually clear the screen annoys me. 
%} 
clc;

%Import csv data into table
phonetimesData = readtable('phonetime.csv');

%Divide table in individual columns 
x = phonetimesData{:,1};
y = phonetimesData{:,2};
%Plot data on scatterplot
scatter(x,y);
%Labels and Titles
title('Relationship Between Grades Attained and Time Spent on Phone');
xlabel('Time spent on phone in class (Mintutes)');
ylabel('Grades for that day?s assignment or activity');

%calculate equation 
coefficients = polyfit(x,y,1);
disp(equation);

%Create line from coefficients
xFit = linspace(0, 55);
disp(xFit);
yFit = polyval(coefficients, xFit);

hold on;
%Plot red line
plot(xFit, yFit,'color','red', 'LineWidth', 1);


