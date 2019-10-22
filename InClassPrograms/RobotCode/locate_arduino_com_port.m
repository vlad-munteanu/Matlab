function com_ports=locate_arduino_com_port;
% EngE 1215 Line Following Robots
%
% This function returns a cell array of com ports of any Arduinos that are
% connected to the computer. To connect an Arduino using the 'arduino_new'
% command call
%
%     arduino_new(com_ports{1})
%
% if size(com_ports)==[1,1].
%
% This function should work on Windows, Mac, and Linux computers, but has
% not been fully tested on multiple operating systems and hardwares.
%
% Authors: Rod La Foy
% Last Modified On: 16 July 2018

% This determines whether this is a Windows, Mac or a UNIX based system
% and finds the COM port the Arduino is attached to appropriately
if ispc;

    % This creates a windows command prompt string for searching for any
    % connected Arduino boards
    command_string='wmic path Win32_SerialPort Where "Caption LIKE ''%Arduino%''" Get DeviceID';
    
    % This scans the communication ports using a windows command string and
    % returns the results of this command
    [~,console_text]=system(command_string);
    
    % This returns any COM ports listed in the 'console_text' string
    com_ports=regexp(console_text,'COM[0-9]+','match');
    
elseif ismac;
    
    % This creates the first of two OSX command prompt strings for 
    % searching for the Arduino COM port
    command_string_1='ls /dev/tty.usbmodem*';
    % This creates the second of two OSX command prompt strings for 
    % searching for the Arduino COM port
    command_string_2='ls /dev/tty.usbserial*';
    
    % This runs the first command which will either returns ports or an
    % error stating that there is 'No such file or directory'
    [~,console_text_1]=system(command_string_1);
    % This runs the second command which will either returns ports or an
    % error stating that there is 'No such file or directory'
    [~,console_text_2]=system(command_string_2);
    
    % This returns any COM ports listed in the 'console_text_1' string
    com_ports_1=regexp(console_text_1,'/dev/tty.usbmodem[0-9]+','match');
    % This returns any COM ports listed in the 'console_text_2' string
    com_ports_2=regexp(console_text_2,'/dev/tty.usbserial[0-9]+','match');
    
    % This concatenates the two COM port regular expression returns
    % together for the output
    if not(isempty(com_ports_1))&&isempty(com_ports_2);
        
        % This sets the output cell array equal to the first com port
        com_ports=com_ports_1;
        
    elseif isempty(com_ports_1)&&not(isempty(com_ports_2));
        
        % This sets the output cell array equal to the second com port
        com_ports=com_ports_2;
        
    elseif not(isempty(com_ports_1))&&not(isempty(com_ports_2));
        
        % This initializes a 2 x 1 cell array to store the non-empty ports
        com_ports=cell(1,length(com_ports_1)+length(com_ports_2));
        % This copies the first com port array into the output array
        com_ports(1,1:length(com_ports_1))=com_ports_1;
        % This copies the second com port array into the output array
        com_ports(1,(length(com_ports_1)+1):(length(com_ports_1)+length(com_ports_2)))=com_ports_2;
        
    else isempty(com_ports_1)&&isempty(com_ports_2);
        
        % This sets the output array to an empty cell array
        com_ports=cell(0,0);
        
    end;
    
elseif isunix;
    
    % This creates the first of two UNIX command prompt strings for 
    % searching for the Arduino COM port
    command_string_1='ls /dev/ttyUSB*';
    % This creates the second of two UNIX command prompt strings for 
    % searching for the Arduino COM port
    command_string_2='ls /dev/ttyACM*';
    
    % This runs the first command which will either returns ports or an
    % error stating that there is 'No such file or directory'
    [~,console_text_1]=system(command_string_1);
    % This runs the second command which will either returns ports or an
    % error stating that there is 'No such file or directory'
    [~,console_text_2]=system(command_string_2);
    
    % This returns any COM ports listed in the 'console_text_1' string
    com_ports_1=regexp(console_text_1,'/dev/ttyUSB[0-9]+','match');
    % This returns any COM ports listed in the 'console_text_2' string
    com_ports_2=regexp(console_text_2,'/dev/ttyACM[0-9]+','match');
    
    % This concatenates the two COM port regular expression returns
    % together for the output
    if not(isempty(com_ports_1))&&isempty(com_ports_2);
        
        % This sets the output cell array equal to the first com port
        com_ports=com_ports_1;
        
    elseif isempty(com_ports_1)&&not(isempty(com_ports_2));
        
        % This sets the output cell array equal to the second com port
        com_ports=com_ports_2;
        
    elseif not(isempty(com_ports_1))&&not(isempty(com_ports_2));
        
        % This initializes a 2 x 1 cell array to store the non-empty ports
        com_ports=cell(1,length(com_ports_1)+length(com_ports_2));
        % This copies the first com port array into the output array
        com_ports(1,1:length(com_ports_1))=com_ports_1;
        % This copies the second com port array into the output array
        com_ports(1,(length(com_ports_1)+1):(length(com_ports_1)+length(com_ports_2)))=com_ports_2;
        
    else isempty(com_ports_1)&&isempty(com_ports_2);
        
        % This sets the output array to an empty cell array
        com_ports=cell(0,0);
        
    end;
    
else;
    
    % This displays an error stating that MATLAB was unable to determine
    % the operating system
    error('Unable to determine operating system.  Arduino COM port must be manually identified.');
    
end;