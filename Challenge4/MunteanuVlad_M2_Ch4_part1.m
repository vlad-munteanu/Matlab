%{
Clears console before program runs because
having to manually clear the screen annoys me.
%}
clc;

%Get user input & initialize variables
prompt = "Please input the methane concentration in ppm: ";
ppm = input(prompt);
ventilation = 0;


%Conditional Statements 
if 0 <= ppm && ppm < 5000 
    ventilation = 5;
elseif 5000 <= ppm && ppm < 20000 
    ventilation = 10;
elseif 20000 <= ppm && ppm < 30000 
    ventilation = 20;
elseif 4000 <= ppm && ppm < 50000
    ventilation = 40;
elseif ppm >= 50000 
    ventilation = 80;

if ppm > 50000
    disp("Emergency evacuation warning. The methane levels indicate an explosion risk."); 
end 
end

% Output to user
fprintf("Ventilation rate is %d m^3/s \n", ventilation);
    
