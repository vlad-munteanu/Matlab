% EngE 1215 Line Following Robots
%
% This script identifies the port that the robot is connected to,
% establishes a connection to the robot, and updates the server code on the
% Arduino if necessary.  This script will generate a single variable (upon
% success) named 'a' that contains the MATLAB Arduino object.
%
% If no Arduinos are connected to the computer or no Arduinos can be
% identified for some reason, this script will produce an error.
% Additionally if more than one Arduino is connected to the computer, this
% will also result in an error.
%
% This code should automatically connect MATLAB to the Arduinos on Windows,
% OSX, and Linux - that said, this has not be fully tested on multiple on
% multiple different operating systems and computer hardwares.
%
% Author: Rod La Foy
% Last Modified On: 14 August 2019

% This clears all variables from the workspace (which is only necessary
% since there is a MATLAB bug where clearing an Arduino object from the
% workspace does not fully remove it from the memory)
clear all;

% This scans the computer ports for any connected Arduinos
com_ports=locate_arduino_com_port;

% If com_ports is non-empty and has a size of 1, this connects to the
% listed port.  If com_ports has a size greater than 1, an error is
% returned.  And if com_ports is empty, an error is returned.
if not(isempty(com_ports));

    % If there is exactly one Arduino listed on the computer, this connects
    % to it
    if all(size(com_ports)==[1,1]);
        
        % This connects the arduino to the computer (possibly updating the
        % Arduino server code if necessary)
        a = arduino_new(com_ports{1});
        
    else;
        
        % This returns an error stating that more than one Arduino is
        % connected to the computer
        error('More than one Arduino is listed in the COM ports. Please disconnect any excess Arduinos.');
        
    end;
    
else;
    
    % This displays an error stating that no Arduinos can be identified on
    % the computer
    error('No Arduino boards were identified by the computer.  Please check the USB connections.');
    
end;
        
