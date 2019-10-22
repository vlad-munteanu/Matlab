% EngE 1215 Line Following Robots
%
% This program is used to help a Line-Following Robot follow the line.  
% The first several sections set up the constants used in the communcation
% between this program and the arduino.  
% Each student will add his/her own code to the User Code section with the
% logic to follow the line.  

% This program assumes that a connection has been established to the
% arduino using the program Robot_Connect. 
% The variable 'a' must be established in the command window using the
% 'Robot_Connect' command.
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
% Additionally, in the new robots the motor direction must be enabled by
% sending signals to the AIN1 and AIN2 pins for the right motor and BIN1 
% and BIN2 pins for the left motor.  One pin must be set high and one pin
% must be set low; reversing the polarity will result in the motors
% switching directions.
%
% Authors: Unknown and Rod La Foy
% Last Modified On: 14 August 2019

%% Constants for reading sensors - do not change statements in this block 
% unless there is a change to the physical robot
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

%% Constants for motor control - Change lmHigh and rmHigh based on testing
%your robot.  Do not change other statements in this block 
% unless there is a change to the physical robot
LEFT_MOTOR = 'D6';      % set pin 6 as the pin to control the left motor 
RIGHT_MOTOR = 'D5';     % set pin 5 as the pin to control the right motor 
OFF = 0;            % motor speed of 0, 0 is off
lmHigh = 1;       % left motor speed, range of acceptable values 0-1
rmHigh = 1;       % right motor speed, range of acceptable values 0-1

% These are the enabling pins for motor A, ie the right motor; one of these
% must be high and one must be low - switching which one is which will
% reverse the direction of the motors
AIN1 = 'D11';
AIN2 = 'D12';
% These are the enabling pins for motor B, ie the left motor; one of these
% must be high and one must be low - switching which one is which will
% reverse the direction of the motors
BIN1 = 'D9';
BIN2 = 'D8';

%% USER CODE SECTION - Your code begins down here - Use the constants above
% to keep your program clear and easy to understand.  Use: 

% % This enables the sensors for reading, ie turns on the infrared LEDs
% a.digitalWrite(SENSOR_PIN,1) 
% % This takes a reading from the left optical sensor; similar commands can
% % be used for the center and right sensors
% left = a.analogRead(LEFT_SENSOR_PIN);
% % This disables the sensors, ie turns off the infrared LEDs
% a.digitalWrite(SENSOR_PIN,0)
% 
% % This sets the enable pins for motor B (the left motor) so that the motor 
% % will go forward; switching the 1 and the 0 in this will switch the 
% % direction to backwards; similar commands can be used for motor A (the
% % right motor)
% a.digitalWrite(BIN1,1);
% a.digitalWrite(BIN2,0);
% % This turns the left motor on; a similar command can be used to turn on
% % the right motor
% a.analogWrite(LEFT_MOTOR,lmHigh)
% % This turns the left motor off; a similar command can be used to turn off
% % the right motor
% a.analogWrite(LEFT_MOTOR,OFF) 

%% The section makes sure the motor and sensors are off when the program stops.
a.analogWrite(LEFT_MOTOR,OFF) %to turn left motor off 
a.analogWrite(RIGHT_MOTOR,OFF) %to turn left motor off 
a.digitalWrite(SENSOR_PIN,0) %output to turn off sensors