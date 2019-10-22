function robot_diagnostics_gui
% This function is designed to create a GUI from which the line following
% robots can be tested and controlled from a straightforward graphical
% interface.
%
% This function should work relatively smoothly, but due to a MATLAB bug
% related to the Arduino (specifically that Arduino objects cannot be
% cleared from memory except by calling 'clear all'), if one Arduino is
% connected to MATLAB, disconnected, and then a 'Connect Robot' command is
% ran a second time, then the GUI interface will have to be restarted.
% Different Arduinos should connect without issue though.
%
% Things to update/fix in this code:
%
%   - Make all warnings and errors display as a dialog box since the MATLAB
%   terminal may be covered.
%
%   - Create a function that properly ends all function loops and clears
%   the workspace memory when the GUI window is closed.  Currently closing
%   the window will return an error and leave the objects in memory.
%
%   - Make the function slowly ramp up the motor speeds when turned on.
%
%   - Add a dialog box that states that the Arduino server software needs
%   to be updated and thus the connection is running slowly.
%
%   - Figure out a good way to re-connecting to the same Arduino when the
%   connection is lost.  Currently this can only be done by running a
%   'clear all' command - which isn't ideal for many reasons.
%
% Since currently closing the GUI window does not fully clear the objects
% from memory, it is recommended that the following commands are ran after
% using the diagnostic interface:
%
%   clear all;
%   close all;
%
% Not running these commands may result in MATLAB slowing down.
%
% Authors: Rod La Foy
% First Created On: 11 July 2019
% Last Edited On: 14 August 2019

% This initializes the variables and the GUI interface for controlling the
% robot; this is called as a function in the event that the Arduino
% connection is lost and has to be reconnected - which requires clearing
% all of the MATLAB variables due to a MATLAB bug
initialize_program();



function update_left_motor(event,robot_hardware_parameters)
% This function updates the left motor slider value, text box, and
% actuated speed.

% This is the maximum motor change value
motor_delta=0.05;

% This declares the left motor slider object as a global variable so that
% it can be accessed and changed in other functions
global left_motor_slider;
% This declares the left motor text box object as a global variable so 
% that it can be accessed and changed in other functions
global left_motor_text_field;
% This declares the left motor speed value as a global variable so that it
% can be accessed and changed in other functions
global left_motor_value;
% This declares the left motor on/off state as a global variable so that 
% it can be accessed and changed in other functions
global left_motor_state;

% This checks if the input value is numeric indicating that the slider was
% changed and then updates the text box and motor state appropriately;
% alternatively if the input value is a character array, this indicates
% that the text box was changes, so this then updates the slider and the
% motor
if isa(event.Value,'double')
    
    % This extracts the new motor value from the input variable rounding
    % the value to two decimal places
    left_motor_value_temp=round(event.Value,2);

    % If the updated value is less of a change than the programmed motor
    % change, then the motor value vector is just set equal to the new
    % motor value
    if ((abs(left_motor_value_temp-left_motor_value)<motor_delta)||(left_motor_state==false))
        
        % This sets the motor value vector equal to the new value
        left_motor_value_vector=left_motor_value_temp;
        
    else
        
        % This creates a vector of values to run the motor through between the
        % old and new values so that there isn't too much torque applied
        left_motor_value_vector=left_motor_value:motor_delta*sign(left_motor_value_temp-left_motor_value):left_motor_value_temp;
        % This ensures that the last value of the vector is the final intended
        % value if it isn't already
        if left_motor_value_vector(end)~=left_motor_value_temp
            % This adds a new value at the end equal to the end value
            left_motor_value_vector(end+1)=left_motor_value_temp;
        end
        
    end
    
    % This iterates through the motor values to the new value
    for motor_value_index=1:length(left_motor_value_vector)
        
        % This sets the global motor value variable equal to the current
        % iteration's motor value
        left_motor_value=left_motor_value_vector(motor_value_index);
        
        % This updates the text box with a new string rounded to two 
        % decimal points and a plus/minus sign
        left_motor_text_field.Value=num2str(left_motor_value,'%+0.2f');

        % This actuates the motor with the new speed value
        actuate_left_motor(left_motor_state,robot_hardware_parameters);
    
        % This pauses for a short period
        pause(0.01);
    
    end
    
elseif isa(event.Value,'char')
    
    % This extracts the new motor value and rounds the value to two decimal
    % places
    left_motor_value_temp=round(str2double(event.Value),2);
    
    % If the updated value is less of a change than the programmed motor
    % change, then the motor value vector is just set equal to the new
    % motor value
    if ((abs(left_motor_value_temp-left_motor_value)<motor_delta)||(left_motor_state==false))
        
        % This sets the motor value vector equal to the new value
        left_motor_value_vector=left_motor_value_temp;
        
    else
        
        % This creates a vector of values to run the motor through between the
        % old and new values so that there isn't too much torque applied
        left_motor_value_vector=left_motor_value:motor_delta*sign(left_motor_value_temp-left_motor_value):left_motor_value_temp;
        % This ensures that the last value of the vector is the final intended
        % value if it isn't already
        if left_motor_value_vector(end)~=left_motor_value_temp
            % This adds a new value at the end equal to the end value
            left_motor_value_vector(end+1)=left_motor_value_temp;
        end
        
    end
    
    % This iterates through the motor values to the new value
    for motor_value_index=1:length(left_motor_value_vector)
        
        % This sets the global motor value variable equal to the current
        % iteration's motor value
        left_motor_value=left_motor_value_vector(motor_value_index);
    
        % This updates the slider position with the new motor value
        left_motor_slider.Value=left_motor_value;
        
        % This updates the text box with a rounded version  of the value with
        % only two decimal points and a plus/minus sign
        left_motor_text_field.Value=num2str(left_motor_value,'%+0.2f');
        
        % This actuates the motor with the new speed values
        actuate_left_motor(left_motor_state,robot_hardware_parameters);
        
        % This pauses for a short period
        pause(0.01);
        
    end
    
end



function update_right_motor(event,robot_hardware_parameters)
% This function updates the right motor slider value, text box, and
% actuated speed.

% This is the maximum motor change value
motor_delta=0.05;

% This declares the right motor slider object as a global variable so that
% it can be accessed and changed in other functions
global right_motor_slider;
% This declares the right motor text box object as a global variable so 
% that it can be accessed and changed in other functions
global right_motor_text_field;
% This declares the right motor speed value as a global variable so that it
% can be accessed and changed in other functions
global right_motor_value;
% This declares the right motor on/off state as a global variable so that 
% it can be accessed and changed in other functions
global right_motor_state;

% This checks if the input value is numeric indicating that the slider was
% changed and then updates the text box and motor state appropriately;
% alternatively if the input value is a character array, this indicates
% that the text box was changes, so this then updates the slider and the
% motor
if isa(event.Value,'double')
    
    % This extracts the new motor value from the input variable rounding
    % the value to two decimal places
    right_motor_value_temp=round(event.Value,2);
    
    % If the updated value is less of a change than the programmed motor
    % change, then the motor value vector is just set equal to the new
    % motor value
    if ((abs(right_motor_value_temp-right_motor_value)<motor_delta)||(right_motor_state==false))
        
        % This sets the motor value vector equal to the new value
        right_motor_value_vector=right_motor_value_temp;
        
    else
        
        % This creates a vector of values to run the motor through between the
        % old and new values so that there isn't too much torque applied
        right_motor_value_vector=right_motor_value:motor_delta*sign(right_motor_value_temp-right_motor_value):right_motor_value_temp;
        % This ensures that the last value of the vector is the final intended
        % value if it isn't already
        if right_motor_value_vector(end)~=right_motor_value_temp
            % This adds a new value at the end equal to the end value
            right_motor_value_vector(end+1)=right_motor_value_temp;
        end
        
    end
    
    % This iterates through the motor values to the new value
    for motor_value_index=1:length(right_motor_value_vector)
        
        % This sets the global motor value variable equal to the current
        % iteration's motor value
        right_motor_value=right_motor_value_vector(motor_value_index);
        
        % This updates the text box with a new string rounded to two 
        % decimal points and a plus/minus sign
        right_motor_text_field.Value=num2str(right_motor_value,'%+0.2f');

        % This actuates the motor with the new speed value
        actuate_right_motor(right_motor_state,robot_hardware_parameters);
    
        % This pauses for a short period
        pause(0.01);
    
    end
    
elseif isa(event.Value,'char')
    
    % This extracts the new motor value and rounds the value to two decimal
    % places
    right_motor_value_temp=round(str2double(event.Value),2);
    
    % If the updated value is less of a change than the programmed motor
    % change, then the motor value vector is just set equal to the new
    % motor value
    if ((abs(right_motor_value_temp-right_motor_value)<motor_delta)||(right_motor_state==false))
        
        % This sets the motor value vector equal to the new value
        right_motor_value_vector=right_motor_value_temp;
        
    else
        
        % This creates a vector of values to run the motor through between the
        % old and new values so that there isn't too much torque applied
        right_motor_value_vector=right_motor_value:motor_delta*sign(right_motor_value_temp-right_motor_value):right_motor_value_temp;
        % This ensures that the last value of the vector is the final intended
        % value if it isn't already
        if right_motor_value_vector(end)~=right_motor_value_temp
            % This adds a new value at the end equal to the end value
            right_motor_value_vector(end+1)=right_motor_value_temp;
        end
        
    end
    
    % This iterates through the motor values to the new value
    for motor_value_index=1:length(right_motor_value_vector)
        
        % This sets the global motor value variable equal to the current
        % iteration's motor value
        right_motor_value=right_motor_value_vector(motor_value_index);
    
        % This updates the slider position with the new motor value
        right_motor_slider.Value=right_motor_value;
        
        % This updates the text box with a rounded version  of the value with
        % only two decimal points and a plus/minus sign
        right_motor_text_field.Value=num2str(right_motor_value,'%+0.2f');
        
        % This actuates the motor with the new speed values
        actuate_right_motor(right_motor_state,robot_hardware_parameters);
        
        % This pauses for a short period
        pause(0.01);
        
    end
    
end



function decrement_left_motor()
% This function decreases the value of the left motor

% This loads the left motor value as a global variable
global left_motor_value;
% This declares the robot parameters as a global variable
global robot_hardware_parameters;
% This declares the left motor slider object as a global variable so that
% it can be accessed and changed in other functions
global left_motor_slider;
% This declares the left motor text box object as a global variable so 
% that it can be accessed and changed in other functions
global left_motor_text_field;

% This decreases the left motor value by 0.01
left_motor_value=left_motor_value-0.01;

% This checks if the value is below -1 and just sets it equal to -1 if true
if left_motor_value<-1
    % This sets the motor value equal to -1
    left_motor_value=-1;
end

% This updates the slider position with the new motor value
left_motor_slider.Value=left_motor_value;

% This updates the text box with a rounded version  of the value with
% only two decimal points and a plus/minus sign
left_motor_text_field.Value=num2str(left_motor_value,'%+0.2f');

% This creates an event to pass to the update motor command
event.Value=left_motor_value;

% This updates the left motor information
update_left_motor(event,robot_hardware_parameters);



function increment_left_motor()
% This function decreases the value of the left motor

% This loads the left motor value as a global variable
global left_motor_value;
% This declares the robot parameters as a global variable
global robot_hardware_parameters;
% This declares the left motor slider object as a global variable so that
% it can be accessed and changed in other functions
global left_motor_slider;
% This declares the left motor text box object as a global variable so 
% that it can be accessed and changed in other functions
global left_motor_text_field;

% This increases the left motor value by 0.01
left_motor_value=left_motor_value+0.01;

% This checks if the value is greater than +1 and just sets it equal to +1
% if true
if left_motor_value>+1
    % This sets the motor value equal to +1
    left_motor_value=+1;
end

% This updates the slider position with the new motor value
left_motor_slider.Value=left_motor_value;

% This updates the text box with a rounded version  of the value with
% only two decimal points and a plus/minus sign
left_motor_text_field.Value=num2str(left_motor_value,'%+0.2f');

% This creates an event to pass to the update motor command
event.Value=left_motor_value;

% This updates the left motor information
update_left_motor(event,robot_hardware_parameters);



function decrement_right_motor()
% This function decreases the value of the left motor

% This loads the right motor value as a global variable
global right_motor_value;
% This declares the robot parameters as a global variable
global robot_hardware_parameters;
% This declares the right motor slider object as a global variable so that
% it can be accessed and changed in other functions
global right_motor_slider;
% This declares the right motor text box object as a global variable so 
% that it can be accessed and changed in other functions
global right_motor_text_field;

% This decreases the right motor value by 0.01
right_motor_value=right_motor_value-0.01;

% This checks if the value is below -1 and just sets it equal to -1 if true
if right_motor_value<-1
    % This sets the motor value equal to -1
    right_motor_value=-1;
end

% This updates the slider position with the new motor value
right_motor_slider.Value=right_motor_value;

% This updates the text box with a rounded version  of the value with
% only two decimal points and a plus/minus sign
right_motor_text_field.Value=num2str(right_motor_value,'%+0.2f');

% This creates an event to pass to the update motor command
event.Value=right_motor_value;

% This updates the right motor information
update_right_motor(event,robot_hardware_parameters);



function increment_right_motor()
% This function decreases the value of the left motor

% This loads the right motor value as a global variable
global right_motor_value;
% This declares the robot parameters as a global variable
global robot_hardware_parameters;
% This declares the right motor slider object as a global variable so that
% it can be accessed and changed in other functions
global right_motor_slider;
% This declares the right motor text box object as a global variable so 
% that it can be accessed and changed in other functions
global right_motor_text_field;

% This increases the right motor value by 0.01
right_motor_value=right_motor_value+0.01;

% This checks if the value is greater than +1 and just sets it equal to +1
% if true
if right_motor_value>+1
    % This sets the motor value equal to +1
    right_motor_value=+1;
end

% This updates the slider position with the new motor value
right_motor_slider.Value=right_motor_value;

% This updates the text box with a rounded version  of the value with
% only two decimal points and a plus/minus sign
right_motor_text_field.Value=num2str(right_motor_value,'%+0.2f');

% This creates an event to pass to the update motor command
event.Value=right_motor_value;

% This updates the right motor information
update_right_motor(event,robot_hardware_parameters);



function left_motor_button_pressed(robot_hardware_parameters)
% This function updates the status of the motor based upon the whether the
% button was clicked into an on or off state.

% This loads the both motors button as a global variable
global both_motors_button;
% This loads the left motor button as a global variable
global left_motor_button;
% This loads the left motor state as a global variable
global left_motor_state;
% This loads the right motor state as a global variable
global right_motor_state;

% This extracts the current state of the left motor button
left_motor_state=left_motor_button.Value;

% This ensures that if both motors are on, then the both motors on button
% is turned on; otherwise the button is turned off
if ((left_motor_state)&&(right_motor_state))
    % This turns on the both motors are on button
    both_motors_button.Value=true;
else
    % This turns off the both motors are on button
    both_motors_button.Value=false;
end;

% This actuates the motor with the current on/off state
actuate_left_motor(left_motor_state,robot_hardware_parameters);



function right_motor_button_pressed(robot_hardware_parameters)
% This function updates the status of the motor based upon the whether the
% button was clicked into an on or off state.

% This loads the both motors button as a global variable
global both_motors_button;
% This loads the right motor button as a global variable
global right_motor_button;
% This loads the left motor state as a global variable
global left_motor_state;
% This loads the right motor state as a global variable
global right_motor_state;

% This extracts the current state of the right motor button
right_motor_state=right_motor_button.Value;

% This ensures that if both motors are on, then the both motors on button
% is turned on; otherwise the button is turned off
if ((left_motor_state)&&(right_motor_state))
    % This turns on the both motors are on button
    both_motors_button.Value=true;
else
    % This turns off the both motors are on button
    both_motors_button.Value=false;
end;

% This actuates the motor with the current on/off state
actuate_right_motor(right_motor_state,robot_hardware_parameters);



function both_motors_button_pressed(robot_hardware_parameters)
% This function updates the status of the motor based upon the whether the
% button was clicked into an on or off state.

% This loads the both motors button as a global variable
global both_motors_button;
% This loads the left motor button as a global variable
global left_motor_button;
% This loads the right motor button as a global variable
global right_motor_button;
% This loads the left motor state as a global variable
global left_motor_state;
% This loads the right motor state as a global variable
global right_motor_state;

% This extracts the current state of the motors button
left_motor_state=both_motors_button.Value;
right_motor_state=both_motors_button.Value;

% This sets the state of the left motor button
left_motor_button.Value=both_motors_button.Value;
% This sets the state of the right motor button
right_motor_button.Value=both_motors_button.Value;

% This actuates the motor with the current on/off state
actuate_left_motor(left_motor_state,robot_hardware_parameters);
actuate_right_motor(right_motor_state,robot_hardware_parameters);



function actuate_left_motor(left_motor_state,robot_hardware_parameters)
% This function runs the left motor with the value given by the input value
% 'left_motor_value' that lies in the range [-1,+1].

% This creates the arduino connection variable as a global variable
global arduino_connection;
% This declares the left motor value as a global variable
global left_motor_value;

% If the arduino object is empty, then this likely means that the robot has
% not been connected yet, so this prints a warning saying to connect the
% arduino first and then exits this function; otherwise this updates the
% arduino motor actuation
if isempty(arduino_connection)
    
    % This prints a warning stating that the robot is not connected
    warning('The robot is not connected and thus the motors will not actuate.');
    
else

    % This extracts the left motor PWM pin number from the robot hardware
    % parameters object
    left_motor_pwm_pin=robot_hardware_parameters.motors.left_motor_pwm_pin;
    
    % This extracts the left motor enabling pin numbers from the robot hardware
    % parameters object; one of these must be high and one must be low -
    % switching which one is which will reverse the direction of the motors
    left_motor_enable_pin_1=robot_hardware_parameters.motors.left_motor_enable_pin_1;
    left_motor_enable_pin_2=robot_hardware_parameters.motors.left_motor_enable_pin_2;
    
    % This ensures that the enable pins are configred for digital output
    configurePin(arduino_connection,left_motor_enable_pin_1,'DigitalOutput');
    configurePin(arduino_connection,left_motor_enable_pin_2,'DigitalOutput');
    
    % If the left motor value is negative, this sets the enable pins for
    % reverse direction; if the left motor value is zero or positive, this sets
    % the enable pins for forward direction
    if ((-1<=left_motor_value)&&(left_motor_value<0))
        
        % This sets the enable pins for a reverse direction
        writeDigitalPin(arduino_connection,left_motor_enable_pin_1,0);
        writeDigitalPin(arduino_connection,left_motor_enable_pin_2,1);
        
    elseif ((0<=left_motor_value)&&(left_motor_value<=1))
        
        % This sets the enable pins to a forward direction
        writeDigitalPin(arduino_connection,left_motor_enable_pin_1,1);
        writeDigitalPin(arduino_connection,left_motor_enable_pin_2,0);

    end
    
    % If the motor state is on, then this turns on the motor with the defined
    % value; otherwise this turns off the motor
    if left_motor_state==true
        
        % This sets the motor pwm pin to output the absolute value of the current
        % left motor value
        writePWMVoltage(arduino_connection,left_motor_pwm_pin,abs(5*left_motor_value));
        
    elseif left_motor_state==false
        
        % This sets the motor pwm pin to output the absolute value of the current
        % left motor value
        writePWMVoltage(arduino_connection,left_motor_pwm_pin,0);
        
    end
    
end



function actuate_right_motor(right_motor_state,robot_hardware_parameters)
% This function runs the right motor with the value given by the input value
% 'right_motor_value' that lies in the range [-1,+1].

% This creates the arduino connection variable as a global variable
global arduino_connection;
% This declares the right motor value as a global variable
global right_motor_value;

% If the arduino object is empty, then this likely means that the robot has
% not been connected yet, so this prints a warning saying to connect the
% arduino first and then exits this function; otherwise this updates the
% arduino motor actuation
if isempty(arduino_connection)
    
    % This prints a warning stating that the robot is not connected
    warning('The robot is not connected and thus the motors will not actuate.');
    
else

    % This extracts the right motor PWM pin number from the robot hardware
    % parameters object
    right_motor_pwm_pin=robot_hardware_parameters.motors.right_motor_pwm_pin;
    
    % This extracts the right motor enabling pin numbers from the robot hardware
    % parameters object; one of these must be high and one must be low -
    % switching which one is which will reverse the direction of the motors
    right_motor_enable_pin_1=robot_hardware_parameters.motors.right_motor_enable_pin_1;
    right_motor_enable_pin_2=robot_hardware_parameters.motors.right_motor_enable_pin_2;
    
    % This ensures that the enable pins are configred for digital output
    configurePin(arduino_connection,right_motor_enable_pin_1,'DigitalOutput');
    configurePin(arduino_connection,right_motor_enable_pin_2,'DigitalOutput');
    
    % If the right motor value is negative, this sets the enable pins for
    % reverse direction; if the right motor value is zero or positive, this sets
    % the enable pins for forward direction
    if ((-1<=right_motor_value)&&(right_motor_value<0))
        
        % This sets the enable pins for a reverse direction
        writeDigitalPin(arduino_connection,right_motor_enable_pin_1,0);
        writeDigitalPin(arduino_connection,right_motor_enable_pin_2,1);
  
    elseif ((0<=right_motor_value)&&(right_motor_value<=1))
        
        % This sets the enable pins to a forward direction
        writeDigitalPin(arduino_connection,right_motor_enable_pin_1,1);
        writeDigitalPin(arduino_connection,right_motor_enable_pin_2,0);
        
    end
    
    % If the motor state is on, then this turns on the motor with the defined
    % value; otherwise this turns off the motor
    if right_motor_state==true
        
        % This sets the motor pwm pin to output the absolute value of the current
        % left motor value
        writePWMVoltage(arduino_connection,right_motor_pwm_pin,abs(5*right_motor_value));
        
    elseif right_motor_state==false
        
        % This sets the motor pwm pin to output the absolute value of the current
        % left motor value
        writePWMVoltage(arduino_connection,right_motor_pwm_pin,0);
        
    end
    
end



function single_sensor_reading_button_pressed(robot_hardware_parameters)
% This function updates the status of the motor based upon the whether the
% button was clicked into an on or off state.

% This declares the left sensor text field objects as a global variable
global left_sensor_text_field;
% This declares the center sensor text field objects as a global variable
global center_sensor_text_field;
% This declares the right sensor text field objects as a global variable
global right_sensor_text_field;

% This declares the left sensor panel object as a global variable
global left_sensor_panel;
% This declares the center sensor panel object as a global variable
global center_sensor_panel;
% This declares the right sensor panel object as a global variable
global right_sensor_panel;

% This collects a single reading from the optical sensor
[left_sensor_value,center_sensor_value,right_sensor_value]=collect_sensor_reading(robot_hardware_parameters);

% This updates the left sensor text box with a new string rounded to four
% decimal points
left_sensor_text_field.Value=num2str(left_sensor_value,'%0.4f');
% This updates the center sensor text box with a new string rounded to four
% decimal points
center_sensor_text_field.Value=num2str(center_sensor_value,'%0.4f');
% This updates the right sensor text box with a new string rounded to four
% decimal points
right_sensor_text_field.Value=num2str(right_sensor_value,'%0.4f');

% This updates the left panel bar "graph" size
left_sensor_panel.Position(3)=round((240+80)*left_sensor_value/5);
% This updates the center panel bar "graph" size
center_sensor_panel.Position(3)=round((240+80)*center_sensor_value/5);
% This updates the right panel bar "graph" size
right_sensor_panel.Position(3)=round((240+80)*right_sensor_value/5);



function continous_sensor_reading_button_pressed(robot_hardware_parameters)
% This function updates the status of the motor based upon the whether the
% button was clicked into an on or off state.

% This declares the continous sensor button object as a global variable
global continuous_sensor_reading_button;

% This declares the left sensor text field objects as a global variable
global left_sensor_text_field;
% This declares the center sensor text field objects as a global variable
global center_sensor_text_field;
% This declares the right sensor text field objects as a global variable
global right_sensor_text_field;

% This declares the left sensor panel object as a global variable
global left_sensor_panel;
% This declares the center sensor panel object as a global variable
global center_sensor_panel;
% This declares the right sensor panel object as a global variable
global right_sensor_panel;

% This continously updates the sensor readings until the button is
% unclicked
while continuous_sensor_reading_button.Value

    % This collects a single reading from the optical sensor
    [left_sensor_value,center_sensor_value,right_sensor_value]=collect_sensor_reading(robot_hardware_parameters);
    
    % This updates the left sensor text box with a new string rounded to four
    % decimal points
    left_sensor_text_field.Value=num2str(left_sensor_value,'%0.4f');
    % This updates the center sensor text box with a new string rounded to four
    % decimal points
    center_sensor_text_field.Value=num2str(center_sensor_value,'%0.4f');
    % This updates the right sensor text box with a new string rounded to four
    % decimal points
    right_sensor_text_field.Value=num2str(right_sensor_value,'%0.4f');
    
    % This updates the left panel bar "graph" size
    left_sensor_panel.Position(3)=round((240+80)*left_sensor_value/5);
    % This updates the center panel bar "graph" size
    center_sensor_panel.Position(3)=round((240+80)*center_sensor_value/5);
    % This updates the right panel bar "graph" size
    right_sensor_panel.Position(3)=round((240+80)*right_sensor_value/5);
    
    % This pauses for a short time
    pause(0.3);
    
end



function [left_sensor_value,center_sensor_value,right_sensor_value]=collect_sensor_reading(robot_hardware_parameters)
% This function takes a single sensor reading from the robot optical
% sensors.

% This creates the arduino connection variable as a global variable
global arduino_connection;

% This extracts the sensor enable pin from the data structure
sensor_enable_pin=robot_hardware_parameters.sensors.sensor_enable_pin;
% This extracts the left sensor analog read pin from the data structure
left_sensor_pin=robot_hardware_parameters.sensors.left_sensor_pin;
% This extracts the center sensor analog read pin from the data structure
center_sensor_pin=robot_hardware_parameters.sensors.center_sensor_pin;
% This extracts the right sensor analog read pin from the data structure
right_sensor_pin=robot_hardware_parameters.sensors.right_sensor_pin;

% This sets the sensor enable pin to a digital output mode
configurePin(arduino_connection,sensor_enable_pin,'DigitalOutput');

% This sets the sensor analog pins to analog input mode
configurePin(arduino_connection,left_sensor_pin,'AnalogInput');
configurePin(arduino_connection,center_sensor_pin,'AnalogInput');
configurePin(arduino_connection,right_sensor_pin,'AnalogInput');

% This enables the sensor for reading
writeDigitalPin(arduino_connection,sensor_enable_pin,1);

% This collects a reading from the left sensor
left_sensor_value=readVoltage(arduino_connection,left_sensor_pin);
% This collects a reading from the center sensor
center_sensor_value=readVoltage(arduino_connection,center_sensor_pin);
% This collects a reading from the right sensor
right_sensor_value=readVoltage(arduino_connection,right_sensor_pin);

% This disables the sensor for reading
writeDigitalPin(arduino_connection,sensor_enable_pin,0);



function connect_to_robot()
% This function establishes a connection to the robot

% This declares the diagnostics figure as a global variable in case it
% needs to be closed and the GUI restarted
global diagnostics_figure;
% This declares the robot parameters as a global variable
global robot_hardware_parameters;

% This sets the arduino connection variable to be global
global arduino_connection;

% This sets the arduino connection status radio button as a global variable
global connection_status_true;

% This scans the computer ports for any connected Arduinos
com_ports=locate_arduino_com_port;

% If com_ports is non-empty and has a size of 1, this connects to the
% listed port.  If com_ports has a size greater than 1, an error is
% returned.  And if com_ports is empty, an error is returned.
if not(isempty(com_ports))

    % If there is exactly one Arduino listed on the computer, this connects
    % to it
    if all(size(com_ports)==[1,1])
        
        % This tries connecting to the Arduino; if there has not already
        % been an Arduino connected, this creates the connection object;
        % otherwise all variables have to be cleared from memory and the
        % GUI has to be restarted due to a MATLAB bug
        try
        
            % This connects the arduino to the computer (possibly updating the
            % Arduino server code if necessary)
            arduino_connection=arduino(com_ports{1},'uno');
        
        catch arduino_connection_error
            
            % This tests if the reason that the connection cannot be made
            % is if this particular Arduino has already been connected; in
            % which case the GUI interface is restarted; 
            if strcmp(arduino_connection_error.identifier,'MATLAB:arduinoio:general:connectionExists')
 
                % THis displays a dialog box saying that the robot
                % diagnostic interface has to be restarted
                restarting_gui_dialog_box=msgbox('Reconnecting the Arduino requires restarting the GUI interface.  This may take a few seconds . . . ',...
                                                 'Restarting Line Following Robot Diagnostics');
                % This pauses for a short period to ensure that the message
                % appears before the GUI window is closed
                pause(0.3);
                
                % This closes the GUI window so that a new window can be
                % opened
                close(diagnostics_figure);
                
                % This re-initializes the program
                initialize_program();

                % This declares the diagnostics figure as a global variable
                % since it was cleared and the GUI restarted; MATLAB
                % produces a warning here since the variable was declared
                % global twice - please ignore this warning
                global diagnostics_figure;
                % This declares the robot parameters as a global variable;
                % MATLAB produces a warning here since the variable was 
                % declared global twice - please ignore this warning
                global robot_hardware_parameters;
                
                % This sets the arduino connection variable to be global;
                % MATLAB produces a warning here since the variable was 
                % declared global twice - please ignore this warning
                global arduino_connection;
                
                % This sets the arduino connection status radio button as a
                % global variable; MATLAB produces a warning here since the
                % variable was declared global twice - please ignore this 
                % warning
                global connection_status_true;
                
                % This scans the computer ports for any connected Arduinos
                com_ports=locate_arduino_com_port;
                
                % This connects the arduino to the computer (possibly updating the
                % Arduino server code if necessary)
                arduino_connection=arduino(com_ports{1},'uno');

                % This sets the connection status radio button to true since
                % the Arduino is still connected
                connection_status_true.Value=true;
            
            end
            
        end
        
    else
        
        % This returns an error stating that more than one Arduino is
        % connected to the computer
        error('More than one Arduino is listed in the COM ports. Please disconnect any excess Arduinos.');
        
    end
    
else
    
    % This displays an error stating that no Arduinos can be identified on
    % the computer
    error('No Arduino boards were identified by the computer.  Please check the USB connections.');
    
end

% This sets the connection status radio button to true
connection_status_true.Value=true;

% This enables the robot controls
enable_controls(true);

% This initializes a loop to periodically test if an Arduino is connected;
% if the connection is lost, this updates the radio status buttons and
% exits the loop
while true
    
    % This attempts to connect to an Arduino device; either the current
    % device is still connected which will return an error stating that a
    % connection exists or an error will be returned saying that an Arduino
    % isn't detected; if an Arduino isn't detected, the radio status button
    % is updated and the infinite loop is exited
    try
    
        % This tests if an Arduino can be connected to (which generally
        % should not be possible)
        [~]=arduino;
        
    catch arduino_connection_error
        
        % This tests if the error that is returned says that a connection
        % already exists and if so updates the radio button appropriately
        % (although in practice this shouldn't actually change anything);
        % otherwise this tests if an Arduino board is not detected
        if strcmp(arduino_connection_error.identifier,'MATLAB:arduinoio:general:connectionExists')
            
            % This sets the connection status radio button to true since
            % the Arduino is still connected
            connection_status_true.Value=true;
        
        elseif strcmp(arduino_connection_error.identifier,'MATLAB:arduinoio:general:boardNotDetected')
            
            % This sets the connection status radio button to false since
            % the Arduino is disconnected
            connection_status_true.Value=false;
            
            % This disables the robot controls
            enable_controls(false);
            
            % This breaks the infinite for loop since the Arduino will have
            % to be reconnected
            break;
            
        end
        
    end
    
    % This pauses for short period before testing the Arduino connection
    % status again
    pause(0.3);
    
end



function enable_controls(connection_status)
% This function enables or disables all controls when the robot is
% connected or disconnected.

% This decleares the left motor increment and decrement buttons as global
% variables
global left_motor_decrement_button;
global left_motor_increment_button;
% This decleares the right motor increment and decrement buttons as global
% variables
global right_motor_decrement_button;
global right_motor_increment_button;

% This declares the left motor slider object as a global variable
global left_motor_slider;
% This declares the right motor slider object as a global variable
global right_motor_slider;

% This declares the left motor text field object as a global variable
global left_motor_text_field;
% This declares the right motor text field object as a global variable
global right_motor_text_field;

% This declares the left motor button object as a global variable
global left_motor_button;
% This declares the right motor button object as a global variable
global right_motor_button;
% This declares the both motors button object as a global variable
global both_motors_button;

% This declares the continous sensor button object as a global variable
global continuous_sensor_reading_button;
% This declares the single sensor button object as a global variable
global single_sensor_reading_button;

% This declares the left sensor title panel object as a global variable
global left_sensor_title_panel;
% This declares the center sensor title panel object as a global variable
global center_sensor_title_panel;
% This declares the right sensor title panel object as a global variable
global right_sensor_title_panel;

% This declares the left sensor text field objects as a global variable
global left_sensor_text_field;
% This declares the center sensor text field objects as a global variable
global center_sensor_text_field;
% This declares the right sensor text field objects as a global variable
global right_sensor_text_field;

% This declares the left sensor panel object as a global variable
global left_sensor_panel;
% This declares the center sensor panel object as a global variable
global center_sensor_panel;
% This declares the right sensor panel object as a global variable
global right_sensor_panel;

% This either enables or disables the robot controls
if connection_status==true
    
    % This enables the motor decrement buttons
    left_motor_decrement_button.Enable='on';
    right_motor_decrement_button.Enable='on';
    % This enables the motor increment buttons
    left_motor_increment_button.Enable='on';
    right_motor_increment_button.Enable='on';
    
    % This enables the motor value sliders
    left_motor_slider.Enable='on';
    right_motor_slider.Enable='on';
    
    % This enables the motor value text boxes
    left_motor_text_field.Enable='on';
    right_motor_text_field.Enable='on';
    
    % This enables the motor on/off buttons
    left_motor_button.Enable='on';
    right_motor_button.Enable='on';
    both_motors_button.Enable='on';
    
    % This enables the sensor reading buttons
    continuous_sensor_reading_button.Enable='on';
    single_sensor_reading_button.Enable='on';
    
    % This sets the sensor title panel font colors to black
    left_sensor_title_panel.ForegroundColor=[0,0,0];
    center_sensor_title_panel.ForegroundColor=[0,0,0];
    right_sensor_title_panel.ForegroundColor=[0,0,0];
    
    % This enables the sensor text fields
    left_sensor_text_field.Enable='on';
    center_sensor_text_field.Enable='on';
    right_sensor_text_field.Enable='on';
    
    % This sets the sensor panel magnitude graphs to a dark grey
    right_sensor_panel.BackgroundColor=[0.5,0.5,0.5];
    center_sensor_panel.BackgroundColor=[0.5,0.5,0.5];
    left_sensor_panel.BackgroundColor=[0.5,0.5,0.5];
    
elseif connection_status==false
    
    % This disables the motor decrement buttons
    left_motor_decrement_button.Enable='off';
    right_motor_decrement_button.Enable='off';
    % This disables the motor increment buttons
    left_motor_increment_button.Enable='off';
    right_motor_increment_button.Enable='off';
    
    % This disables the motor value sliders
    left_motor_slider.Enable='off';
    right_motor_slider.Enable='off';
    
    % This disables the motor value text boxes
    left_motor_text_field.Enable='off';
    right_motor_text_field.Enable='off';
    
    % This disables the motor on/off buttons
    left_motor_button.Enable='off';
    right_motor_button.Enable='off';
    both_motors_button.Enable='off';
    
    % This disables the sensor reading buttons
    continuous_sensor_reading_button.Enable='off';
    single_sensor_reading_button.Enable='off';
    
    % This sets the sensor title panel font colors to grey
    left_sensor_title_panel.ForegroundColor=[0.7,0.7,0.7];
    center_sensor_title_panel.ForegroundColor=[0.7,0.7,0.7];
    right_sensor_title_panel.ForegroundColor=[0.7,0.7,0.7];
    
    % This disables the sensor text fields
    left_sensor_text_field.Enable='off';
    center_sensor_text_field.Enable='off';
    right_sensor_text_field.Enable='off';
    
    % This sets the sensor panel magnitude graphs to a light grey
    right_sensor_panel.BackgroundColor=[0.8,0.8,0.8];
    center_sensor_panel.BackgroundColor=[0.8,0.8,0.8];
    left_sensor_panel.BackgroundColor=[0.8,0.8,0.8];
    
end



function initialize_program()
% This function initializes all the variables as well as the GUI interface
% for controlling the robot.

% This clears the workspace variables from memory since an Arduino 
% connection cannot be cleared any other way currently
clear all;

% This declares the GUI figure window as a global variable
global diagnostics_figure;

% This sets the arduino connection status radio button as a global variable
global connection_status_false;
global connection_status_true;

% This declares the left motor speed values as global variable
global left_motor_value;
% This declares the right motor speed values as global variable
global right_motor_value;

% This declares the left motor state as global variable
global left_motor_state;
% This declares the right motor state as global variable
global right_motor_state;

% This decleares the left motor increment and decrement buttons as global
% variables
global left_motor_decrement_button;
global left_motor_increment_button;
% This decleares the right motor increment and decrement buttons as global
% variables
global right_motor_decrement_button;
global right_motor_increment_button;

% This declares the left motor slider object as a global variable
global left_motor_slider;
% This declares the right motor slider object as a global variable
global right_motor_slider;

% This declares the left motor text field object as a global variable
global left_motor_text_field;
% This declares the right motor text field object as a global variable
global right_motor_text_field;

% This declares the left motor button object as a global variable
global left_motor_button;
% This declares the right motor button object as a global variable
global right_motor_button;
% This declares the both motors button object as a global variable
global both_motors_button;

% This declares the continous sensor button object as a global variable
global continuous_sensor_reading_button;
% This declares the single sensor button object as a global variable
global single_sensor_reading_button;

% This declares the left sensor title panel object as a global variable
global left_sensor_title_panel;
% This declares the center sensor title panel object as a global variable
global center_sensor_title_panel;
% This declares the right sensor title panel object as a global variable
global right_sensor_title_panel;

% This declares the left sensor text field objects as a global variable
global left_sensor_text_field;
% This declares the center sensor text field objects as a global variable
global center_sensor_text_field;
% This declares the right sensor text field objects as a global variable
global right_sensor_text_field;

% This declares the left sensor panel object as a global variable
global left_sensor_panel;
% This declares the center sensor panel object as a global variable
global center_sensor_panel;
% This declares the right sensor panel object as a global variable
global right_sensor_panel;

% This declares the robot hardware parameters as a global variable
global robot_hardware_parameters;

% This creates the robot hardward parameters data structure
robot_hardware_parameters=struct();
% This creates the motors structure within the hardward parameters
robot_hardware_parameters.motors=struct();

% This adds the left motor PWM pin to the data structure
robot_hardware_parameters.motors.left_motor_pwm_pin='D6';
% This adds the left motor enable pins to the data structure
robot_hardware_parameters.motors.left_motor_enable_pin_1='D9';
robot_hardware_parameters.motors.left_motor_enable_pin_2='D8';

% This adds the right motor PWM pin to the data structure
robot_hardware_parameters.motors.right_motor_pwm_pin='D5';
% This adds the right motor enable pins to the data structure
robot_hardware_parameters.motors.right_motor_enable_pin_1='D11';
robot_hardware_parameters.motors.right_motor_enable_pin_2='D12';

% This adds the sensor enable pin to the data structure
robot_hardware_parameters.sensors.sensor_enable_pin='D13';
% This adds the left sensor analog read pin to the data structure
robot_hardware_parameters.sensors.left_sensor_pin='A4';
% This adds the center sensor analog read pin to the data structure
robot_hardware_parameters.sensors.center_sensor_pin='A2';
% This adds the right sensor analog read pin to the data structure
robot_hardware_parameters.sensors.right_sensor_pin='A0';

% This initializes the left motor value initially to zero
left_motor_value=0;
% This initializes the right motor value initially to zero
right_motor_value=0;

% This initializes the left motor state initially to false
left_motor_state=false;
% This initializes the right motor state initially to false
right_motor_state=false;

% This creates the diagnostics figure
diagnostics_figure=uifigure('Name','Line Following Robot Diagnostics',...
                            'Position',[100,100,890,580]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Robot Connection Panel                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This creates a panel in the figure for controlling the connection to the
% robot
connection_panel=uipanel(diagnostics_figure,...
                         'Position',[30,30,830,100]);

% This adds a button to the panel for connecting the robot
[~]=uibutton(connection_panel,'push',...
                           'Position',[30,30,300,40],...
                           'Text','Connect to Robot',...
                           'FontSize',14,...
                           'ButtonPushedFcn',@(source,event)connect_to_robot());
                       
% This creates a connection status button group panel
connection_status_button_group=uibuttongroup(connection_panel,...
                                             'Position',[360,30,440,40]);
                       
% This creates a radio button that will show that the robot is connected
connection_status_true=uiradiobutton(connection_status_button_group,...
                                     'Enable','off',...
                                     'Text','Robot Connected',...
                                     'FontSize',14,...
                                     'Position',[70,10,160,20]);
% This creates a radio button that will show that the robot is not 
% connected
connection_status_false=uiradiobutton(connection_status_button_group,...
                                      'Enable','off',...
                                      'Text','Robot Disconnected',...
                                      'FontSize',14,...
                                      'Position',[230,10,160,20]);
% This sets that the robot is initially disconnected
connection_status_false.Value=true;
           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Motor Control Panel                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                       
% This creates a panel in the figure for controlling the motors
motor_panel=uipanel(diagnostics_figure,...
                         'Position',[30,160,830,150]);

%This creates a slider for the value of the left motor             
left_motor_slider=uislider(motor_panel,...
                           'Enable','off',...
                           'Limits',[-1,+1],...
                           'ValueChangedFcn',@(sld,event)update_left_motor(event,robot_hardware_parameters),...
                           'Position',[70,50,250,3]);

% This creates a button to decrease the value of the left motor
left_motor_decrement_button=uibutton(motor_panel,'push',...
                           'Enable','off',...
                           'Text','-',...
                           'FontSize',14,...
                           'ButtonPushedFcn',@(btn,event)decrement_left_motor(),...
                           'Position',[30,25,30,30]);
                       
% This creates a button to increase the value of the left motor
left_motor_increment_button=uibutton(motor_panel,'push',...
                           'Enable','off',...
                           'Text','+',...
                           'FontSize',14,...
                           'ButtonPushedFcn',@(btn,event)increment_left_motor(),...
                           'Position',[330,25,30,30]);

% This creates a text box for the left motor                            
left_motor_text_field=uieditfield(motor_panel,...
                           'Enable','off',...
                                  'FontSize',14,...
                                  'ValueChangedFcn',@(txt,event)update_left_motor(event,robot_hardware_parameters),...
                                  'Position',[390,25,50,30]);                             
% This sets the default value of the text field to zero
left_motor_text_field.Value='0.00';

% This creates a button to turn the left motor on or off
left_motor_button=uibutton(motor_panel,'state',...
                           'Enable','off',...
                           'Text','Left Motor On/Off',...
                           'FontSize',14,...
                           'ValueChangedFcn',@(btn,event)left_motor_button_pressed(robot_hardware_parameters),...
                           'Position',[470,25,150,30]);
                       
                       
% This initializes the left motor button as false
left_motor_button.Value=false;
        
% This creates a slider for the value of the right motor
right_motor_slider=uislider(motor_panel,...
                           'Enable','off',...
                           'Limits',[-1,+1],...
                           'ValueChangedFcn',@(sld,event)update_right_motor(event,robot_hardware_parameters),...
                           'Position',[70,110,250,3]);
                       
% This creates a button to decrease the value of the right motor
right_motor_decrement_button=uibutton(motor_panel,'push',...
                           'Enable','off',...
                           'Text','-',...
                           'FontSize',14,...
                           'ButtonPushedFcn',@(btn,event)decrement_right_motor(),...
                           'Position',[30,85,30,30]);
                       
% This creates a button to increase the value of the right motor
right_motor_increment_button=uibutton(motor_panel,'push',...
                           'Enable','off',...
                           'Text','+',...
                           'FontSize',14,...
                           'ButtonPushedFcn',@(btn,event)increment_right_motor(),...
                           'Position',[330,85,30,30]);

% This creates a text box for the right motor
right_motor_text_field=uieditfield(motor_panel,...
                           'Enable','off',...
                                  'FontSize',14,...
                                  'ValueChangedFcn',@(sld,event)update_right_motor(event,robot_hardware_parameters),...
                                  'Position',[390,85,50,30]);
% This sets the default value of the text field to zero
right_motor_text_field.Value='0.00';                              
                              
% This creates a button to turn the right motor on or off
right_motor_button=uibutton(motor_panel,'state',...
                           'Enable','off',...
                           'Text','Right Motor On/Off',...
                           'FontSize',14,...
                           'ValueChangedFcn',@(btn,event)right_motor_button_pressed(robot_hardware_parameters),...
                           'Position',[470,85,150,30]);
                       
                       
% This initializes the right motor button as false
right_motor_button.Value=false;
        
% This creates a button to turn both motors on or off
both_motors_button=uibutton(motor_panel,'state',...
                           'Enable','off',...
                            'Text','Both Motors On/Off',...
                            'FontSize',14,...
                            'ValueChangedFcn',@(btn,event)both_motors_button_pressed(robot_hardware_parameters),...
                            'Position',[650,25,150,90]);
                       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sensor Control Panel                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This creates a panel in the figure for controlling the sensors
sensor_panel=uipanel(diagnostics_figure,...
                         'Position',[30,340,830,210]);
                     
% This creates a button to collect a single sensor reading
single_sensor_reading_button=uibutton(sensor_panel,'push',...
                           'Enable','off',...
                                      'Text','Single Sensor Reading',...
                                      'FontSize',14,...
                                      'ButtonPushedFcn',@(btn,event)single_sensor_reading_button_pressed(robot_hardware_parameters),...
                                      'Position',[30,30,200,60]);
                                  
% This creates a button to collect continuous sensor readings
continuous_sensor_reading_button=uibutton(sensor_panel,'state',...
                           'Enable','off',...
                                          'Text','Continuous Sensor Reading',...
                                          'FontSize',14,...
                                          'ValueChangedFcn',@(btn,event)continous_sensor_reading_button_pressed(robot_hardware_parameters),...
                                          'Position',[30,115,200,60]);

% This creates a panel to show text indicating that the left sensor
% information is being displayed
left_sensor_title_panel=uipanel(sensor_panel,...
                                'BorderType','none',...
                                'FontSize',14,...
                                'Title','Left Sensor',...
                                'Position',[260,145,100,30]);
% This sets the sensor title panel font color to grey
left_sensor_title_panel.ForegroundColor=[0.7,0.7,0.7];
                                      
% This creates a text box for the left sensor value
left_sensor_text_field=uieditfield(sensor_panel,...
                           'Enable','off',...
                                   'FontSize',14,...
                                   'Position',[390,150,60,30]);
% This sets the default value of the text field to zero
left_sensor_text_field.Value='5.0000';

% This creates a box to put the left sensor panel within
left_sensor_panel_box=uipanel(sensor_panel,...
                              'Position',[480,150,320,30]);
% This creates a panel in the figure for displaying the left sensor
% magnitude
left_sensor_panel=uipanel(left_sensor_panel_box,...
                          'BackgroundColor',[0.94,0.94,0.94],...
                          'Position',[2,2,320-4,30-4]);
                      
% This creates a panel to show text indicating that the center sensor
% information is being displayed                            
center_sensor_title_panel=uipanel(sensor_panel,...
                                  'BorderType','none',...
                                  'FontSize',14,...
                                  'Title','Center Sensor',...
                                  'Position',[260,85,100,30]);
% This sets the sensor title panel font color to grey
center_sensor_title_panel.ForegroundColor=[0.7,0.7,0.7];

% This creates a text box for the center sensor value
center_sensor_text_field=uieditfield(sensor_panel,...
                           'Enable','off',...
                                     'FontSize',14,...
                                     'Position',[390,90,60,30]);
% This sets the default value of the text field to zero
center_sensor_text_field.Value='5.0000';

% This creates a box to put the center sensor panel within
center_sensor_panel_box=uipanel(sensor_panel,...
                               'Position',[480,90,320,30]);
% This creates a panel in the figure for displaying the center sensor
% magnitude
center_sensor_panel=uipanel(center_sensor_panel_box,...
                            'BackgroundColor',[0.94,0.94,0.94],...
                            'Position',[2,2,320-4,30-4]);
                        
% This creates a panel to show text indicating that the right sensor
% information is being displayed                              
right_sensor_title_panel=uipanel(sensor_panel,...
                                 'BorderType','none',...
                                 'FontSize',14,...
                                 'Title','Right Sensor',...
                                 'Position',[260,25,100,30]);
% This sets the sensor title panel font color to grey
right_sensor_title_panel.ForegroundColor=[0.7,0.7,0.7];

% This creates a text box for the right sensor value
right_sensor_text_field=uieditfield(sensor_panel,...
                           'Enable','off',...
                                     'FontSize',14,...
                                     'Position',[390,30,60,30]);
% This sets the default value of the text field to zero
right_sensor_text_field.Value='5.0000';

% This creates a box to put the right sensor panel within
right_sensor_panel_box=uipanel(sensor_panel,...
                               'Position',[480,30,320,30]);
% This creates a panel in the figure for displaying the right sensor
% magnitude
right_sensor_panel=uipanel(right_sensor_panel_box,...
                           'BackgroundColor',[0.94,0.94,0.94],...
                            'Position',[2,2,320-4,30-4]);







        