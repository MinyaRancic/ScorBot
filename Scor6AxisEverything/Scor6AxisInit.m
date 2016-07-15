function ser = Scor6AxisInit(COM)
%% SCOR6AXISINIT(COM) creates a serial object at port COM with parameters
%   for communicating with Scor6AxisSim

% COM - string specifying serial port (e.g. 'COM5')
% ser - Serial object output by function

%% Check inputs
if ~ischar(COM)
    error('COM port must be specified as a sting.');
end

%% Setup serial
% Check if there is a serial object already made with the serial port
inst = instrfind('Port',COM);
if isempty(inst)
    % Create new serial object if port is free
    ser = serial(COM);
else
    % Use existing object if port is already declared
    ser = inst;
    fclose(ser); % close the existing connection (to reopen later)
end

% Set different parameters for serial port
set(ser,'BaudRate',115200);
set(ser,'DataBits',8);
set(ser,'Parity','even');
set(ser,'StopBits',1);
set(ser,'Terminator','LF');
set(ser,'BytesAvailableFcnMode','Terminator');
set(ser,'BytesAvailableFcn',@Scor6AxisReadCallback);
fopen(ser);
end