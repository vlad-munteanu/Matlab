% prompt user for input 
prompt = 'What is your diameter of the hemisphere: ';
diameter = input(prompt);

% save calculations in variables
volume = ((4/3) * (pi) * (diameter/2)^3)/2;
surfaceArea = 3 * (pi) * (diameter/2)^2;

copperDensity = 8960;

copperMass = copperDensity/volume;
disp(copperMass);
goldMass = surfaceArea * 0.0185; 
disp(goldMass);

totalMass = copperMass + goldMass;
% calculate cost 
cost = (copperMass*6) + (goldMass*40000);

% Output to user 
disp("Cost (in $) of hemisphere " + cost);
disp("Mass (in kg) of hemisphere " + totalMass);
