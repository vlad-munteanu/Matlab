%{ 
Header
%} 

% clears console and workspace
clear;
clc;

iceCreamFile = csvread("IceCreamSales.csv");
temperature = iceCreamFile(:,1);
iceCreamSales = iceCreamFile(:,2);
scatter(temperature,iceCreamSales,'o');

title("Relationship between Ice Cream Sales and Average Monthly Noontime Outdoor Temperature")
xlabel("Temperature (T, in degrees Fahrenheit)");
ylabel("Ice Cream Sales (S, in U.S. dollars)");

polyfitLine = polyfit(temperature,iceCreamSales,1);

xVal = min(temperature)-2:.01:max(temperature)+2;
hold on;
plot(xVal,polyval(polyfitLine,xVal));

fprintf('Equation: Ice cream sales (U.S. Dollars) = %.0f * Outdoor temperature (ºF) + %.0f\n',polyfitLine);