% EngE 1215 Line Following Robots
%
% This script creates an Arduino MATLAB object that can be used to
% interface between MATLAB and the Arduino on the line following robots.
%
% Authors: Unknown
% Last Modified On: Unknown

classdef arduino_new < handle
    
%% December 14 Log
% This a wrapper class for the newer versions of arduino package
% Unlike previous version, this is not a standalone solution and requires
% installation of arduino hardware package. HOME > ADD-ON > Get HW Package
% The rest of the interface remained unchanged

    properties (SetAccess=private,GetAccess=private)
       board % arduino object 
    end
    
%     properties (Hidden=true)
%         chks = false;  % Checks serial connection before every operation
%         chkp = true;   % Checks parameters before every operation
%     end
    
    methods
        
        % constructor, connects to the board and creates an arduino object
        function a=arduino_new(comPort)
            
            a.board = arduino(comPort, 'Uno');
            
        end % arduino
        
        function pinMode(a,pin,str)
            
            configurePin(a.board,pin,str);
            
        end % pinmode
        
        % digital write
        function digitalWrite(a,pin,val)
            
            % a.digitalWrite(pin,val); performs digital output on a given pin.
            % The first argument before the function name, a, is the arduino object.
            % The second argument, pin, is the number of the digital pin (2 to 69)
            % where the digital output needs to be performed.
            % The third argument, val, is the value (either 0 or 1) for the output
            % On the Arduino Uno  the digital pins from 0 to 13 are located
            % on the upper right part of the board, while the digital pins
            % from 14 to 19 are better known as "analog input" pins and are
            % located in the lower right corner of the board.
            %
            % Examples:
            % a.digitalWrite(13,1); % sets pin #13 high
            % a.digitalWrite(13,0); % sets pin #13 low
            %
            
            writeDigitalPin(a.board,pin,val);
            
        end % digitalwrite
        
        % analog read
        function val=analogRead(a,pin)
            
            % val=a.analogRead(pin); Performs analog input on a given arduino pin.
            % The first argument before the function name, a, is the arduino object.
            % The second argument, pin, is the number of the analog input pin (0 to 15)
            % where the analog input needs to be performed. The returned value, val,
            % ranges from 0 to 1023, with 0 corresponding to an input voltage of 0 volts,
            % and 1023 to a reference value that is typically 5 volts (this voltage can
            % be set up by the analogReference function). Therefore, assuming a range
            % from 0 to 5 V the resolution is .0049 volts (4.9 mV) per unit.
            % Note that in the Arduino Uno board the analog input pins 0 to 5 are also
            % the digital pins from 14 to 19, and are located on the lower right corner.
            % Specifically, analog input pin 0 corresponds to digital pin 14, and analog
            % input pin 5 corresponds to digital pin 19. Performing analog input does
            % not affect the digital state (high, low, digital input) of the pin.
            %
            % Example:
            % val=a.analogRead(0); % reads analog input pin # 0
            %
            
            val = readVoltage(a.board,pin);
            
        end % analogread
        
        % function analog write
        function analogWrite(a,pin,val)
            
            % a.analogWrite(pin,val); Performs analog output on a given arduino pin.
            % The first argument before the function name, a, is the arduino object.
            % The first argument, pin, is the number of the DIGITAL pin where the analog
            % (PWM) output needs to be performed. Allowed pins for AO on the Mega board
            % are 2 to 13 and 44 to 46, (3,5,6,9,10,11 on the Uno Board).
            % The second argument, val, is the value from 0 to 255 for the level of
            % analog output. Note that the digital pins from 0 to 13 are located on the
            % upper right part of the board.
            %
            % Examples:
            % a.analogWrite(11,90); % sets pin #11 to 90/255
            % a.analogWrite(3,10); % sets pin #3 to 10/255
            %
            
            writePWMDutyCycle(a.board,pin,val);
            
        end % analogwrite
        
        
    end % methods
    
end % class def