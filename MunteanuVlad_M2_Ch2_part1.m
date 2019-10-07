% prompt user for input 
prompt = 'What is your measurment in ancient Roman Cubits:';
romanCubits = input(prompt);

% convert to meters and feet
meters = romanCubits * 0.444;
feet = meters * 3.28084;

% Output to user 
disp("Measurments in meters: " + meters);
disp("Measurments in feet: " + feet);


