% EngE 1215 Line Following Robots
%
% This program is used to help a Line-Following Robot follow the line.  
% The first several sections set up the constants used in the communcation
% between this program and the arduino.  
% Each student will add his/her own code to the User Code section with the
% logic to follow the line.  
% Last Modified On: 29 October 2019

%{
Clears console before program runs because
having to manually clear the screen annoys me.
%}
clc;

% Run Code to Connect Robot 
Robot_Connect;

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
a.digitalWrite(BIN1,1);%stupid worthless commmand to deterimine
a.digitalWrite(BIN2,0);%the motor direction
a.digitalWrite(AIN1,1);%ridonculous
a.digitalWrite(AIN2,0);
%%
% USER CODE SECTION - Your code begins down here - Use the constants above


%read sensors
a.digitalWrite(SENSOR_PIN,1);%enable sensors
left = a.analogRead(LEFT_SENSOR_PIN);% read left
center = a.analogRead(CENTER_SENSOR_PIN);% read middle
right = a.analogRead(RIGHT_SENSOR_PIN);% read right

lmHigh = 0.0;
rmHigh = 0.0;

defaultSpeed = 0.2; 
slowerSpeed = 0.0;

% Variables for data 
leftP = [];
centerP = [];
rightP = [];

lms = []; 
rms = []; 


close all;
%%
figure 
hold on
plot (leftP)
plot (centerP)
plot(rightP)
plot([1 length(leftP)],[3 1],'k')
legend('left sensor','center sensor','right sensor')
grid
hold off
%%
figure
hold on
plot(normalize(lms),'b')
plot(normalize(rms),'r')
plot(normalize(leftP),'k')
legend('left speed','right speed','left sensor')
hold off
%%
figure
hold on
plot(lms-rms,'b')
%plot(normalize(rms),'r')
legend('left speed','right speed')
hold off
%%
figure
hold on
plot(leftP,'b')
plot(righP,'r')
plot([1 length(leftP)],[Thresh Thresh],'--k')
hold off
legend('left sensor','right sensor')
%%
correlate

while (left >= 3) || (center >= 3) || (right >= 3)
    % tuns turns left
   if right < 1
       disp("turning left");
       rmHigh = defaultSpeed;
       lmHigh = slowerSpeed;
   % tuns turns right
   elseif left < 1
       disp("turning right");
       rmHigh = slowerSpeed;
       lmHigh = defaultSpeed;
   else
       disp("straight");
       lmHigh = defaultSpeed;
       rmHigh = defaultSpeed;
   end
   
   %MAKE IT RUNNNN 
   a.analogWrite(LEFT_MOTOR,lmHigh) %output to left motor
   a.analogWrite(RIGHT_MOTOR,rmHigh) %output to the right motor

   a.digitalWrite(SENSOR_PIN,1);%enable sensors
   left = a.analogRead(LEFT_SENSOR_PIN);% read left
   center = a.analogRead(CENTER_SENSOR_PIN);% read middle
   right = a.analogRead(RIGHT_SENSOR_PIN);% read right
   
   leftP = [leftP left]; 
   righP = [rightP right]; 
   centerP = [centerP center]; 
   
   lms = [lms lmHigh]; 
   rms = [rms rmHigh]; 
   
   
end



%% The section makes sure the motor and sensors are off when the program stops.
a.analogWrite(LEFT_MOTOR,OFF) %to turn left motor off 
a.analogWrite(RIGHT_MOTOR,OFF) %to turn left motor off 
a.digitalWrite(SENSOR_PIN,0) %output to turn off sensors
