

% EngE 1215 Line Following Robots
%
% This program is used to test the Line Following Robot motors.  It uses a
% while loop that continues as long as the user wishes allowing the user to
% change the "power-level" for each motor each time through the loop.
% This program assumes that a connection has been established to the
% arduino.  The variable 'a' must be established in the command window by
% calling the 'Robot_Connect' command.
%
% This version of the code is intended to be used with the new robots (as
% of fall 2019) with the red aluminum bodies.  This code will still run on
% the previous version of the robots (with the acrylic bodies and servo 
% motors), however negative power values sent to the motors will still
% result in a forward motion on the older robots.
%
% Authors: Unknown and Rod La Foy
% Last Modified On: 14 August 2019

%% Constants for motor control - do not change statements in this block 
% unless there is a change to the physical robot. 
LEFT_MOTOR = 'D6';      % set pin 5 as the pin to control the left motor 
RIGHT_MOTOR = 'D5';     % set pin 6 as the pin to control the right motor 
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

% This sets the enabling pins for motor A to digitial output
a.pinMode(AIN1,'DigitalOutput');
a.pinMode(AIN2,'DigitalOutput');
% This sets the enabling pins for motor B to digitial output
a.pinMode(BIN1,'DigitalOutput');
a.pinMode(BIN2,'DigitalOutput');

% This sets the enable pins for motor A (the right motor) so that the motor
% will go forward; switching the 1 and the 0 in this will switch the 
% direction to backwards; this is technically redundant, but is left in 
% here for illustrative purposes
a.digitalWrite(AIN1,1);
a.digitalWrite(AIN2,0);
% This sets the enable pins for motor B (the left motor) so that the motor 
% will go forward; switching the 1 and the 0 in this will switch the 
% direction to backwards; this is technically redundant, but is left in 
% here for illustrative purposes
a.digitalWrite(BIN1,1);
a.digitalWrite(BIN2,0);

%% This loop communicates with the motors, turning them on and off.  
% to keep your program clear and easy to understand

again = 1;  %Begin Loop
while again == 1
    
    lmHigh = input('Enter desired left motor speed level (-1.00 to +1.00): ');
    rmHigh = input('Enter desired right motor speed level (-1.00 to +1.00): ');
    
    % Depending upon whether the left motor is set to run forwards or
    % backwards, the BIN pins polarities are switched to change the
    % direction of the motor
    if (lmHigh<0)
        % This sets the left motor to run backwards
        a.digitalWrite(BIN1,0);
        a.digitalWrite(BIN2,1);
    elseif (lmHigh>0)
        % This sets the left motor to run forwards
        a.digitalWrite(BIN1,1);
        a.digitalWrite(BIN2,0);
    end
    % If a negative value is input for the left motor, this inverts the
    % value
    if (lmHigh<0)
        % This inverts the value of the left motor signal so that it is
        % positive when input into the Arduino
        lmHigh=-1*lmHigh;
    end
    
    % Depending upon whether the right motor is set to run forwards or
    % backwards, the AIN pins polarities are switched to change the
    % direction of the motor
    if (rmHigh<0)
        % This sets the right motor to run backwards
        a.digitalWrite(AIN1,0);
        a.digitalWrite(AIN2,1);
    elseif (rmHigh>0)
        % This sets the right motor to run forwards
        a.digitalWrite(AIN1,1);
        a.digitalWrite(AIN2,0);
    end
    % If a negative value is input for the right motor, this inverts the
    % value
    if (rmHigh<0)
        % This inverts the value of the right motor signal so that it is
        % positive when input into the Arduino
        rmHigh=-1*rmHigh;
    end
        
    a.analogWrite(LEFT_MOTOR,lmHigh) %output to left motor
    a.analogWrite(RIGHT_MOTOR,rmHigh) %output to the right motor

    disp('Hit any key to stop motors');
    pause %allow the robot to continue at the above "speeds" until the user types any key
    
    a.analogWrite(LEFT_MOTOR,OFF) %output to left motor to turn it off.
    a.analogWrite(RIGHT_MOTOR,OFF) %output to right motor to turn it off.

    again = input('Run again?  1 for Yes, 0 for No: ');
end
