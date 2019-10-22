% EngE 1215 Line Following Robots
%
% This program is used to test the Line Following Robot sensors.  It uses a
% while loop to allow the user to take sensor readings a set number of
% times. This program assumes that a connection has been established to the
% arduino.  The variable 'a' must be established in the command window by
% calling the 'Robot_Connect' command.
%
% The left and right sensor pins were switched on the new robots with the 
% red aluminum bodies, so if the old robots (the acrylic body robots with 
% servo motors) are used, then change the sensor pin commands to:
%
%   SENSOR_PIN = 'D13';      % sensor control pin (all sensors)
%   LEFT_SENSOR_PIN = 'A0';  % pin to read left sensor values from
%   CENTER_SENSOR_PIN = 'A2';% pin to read center sensor values from
%   RIGHT_SENSOR_PIN = 'A4'; % pint to read right sensor values from
%
% Authors: Unknown and Rod La Foy
% Last Modified On: 14 August 2019

%% Constants for reading sensors - do not change statements in this block 

% unless there is a change to the physical robot.  The numbers represent
% the pins each sensor is connected to.
SENSOR_PIN = 'D13';     % sensor control pin (all sensors)
LEFT_SENSOR_PIN = 'A4';  % pin to read left sensor values from
CENTER_SENSOR_PIN = 'A2';% pin to read center sensor values from
RIGHT_SENSOR_PIN = 'A0'; % pint to read right sensor values from

%% Changes and Additions
% pins have digital and analog designations, ex 13 => 'D13', 2 => 'A2'
% pinMode setup
a.pinMode(SENSOR_PIN,'DigitalOutput');
a.pinMode(LEFT_SENSOR_PIN,'AnalogInput');
a.pinMode(CENTER_SENSOR_PIN,'AnalogInput');
a.pinMode(RIGHT_SENSOR_PIN,'AnalogInput');

%%  Loop to take sensor readings.

k = 1;
numReadings = input('How many sensor readings will you take?');
while k <= numReadings
    disp('Postion the robot and press enter for sensor readings')
    pause %wait for user to press any key
    a.digitalWrite(SENSOR_PIN,1) %output to turn sensors on
    left = a.analogRead(LEFT_SENSOR_PIN); %input value from each sensor one at a time.
    center = a.analogRead(CENTER_SENSOR_PIN);
    right = a.analogRead(RIGHT_SENSOR_PIN);
    a.digitalWrite(SENSOR_PIN,0) %output to turn off sensors
    sensor = [left,center,right]; %creates a vector of the sensor readings to make output easier to read
    disp('Left Center Right')
    disp(sensor)
    k=k+1;
end
