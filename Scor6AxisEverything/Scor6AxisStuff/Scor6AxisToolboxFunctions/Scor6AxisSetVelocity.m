function confirm = Scor6AxisSetVelocity(ser, dt, values)
%% SCOR6AXISWRITEPOSITION sends N number of velocities to Scor6Axis
%   simulation, where N is the number of rows in values
%
%   Example:
%       Scor6AxisWritePosition(ser, .05, rand(100, 6)
%
%   D. Saiontz, M. Kutze, 14July2016, USNA/SEAP

% ser - serial object with:
%   BaudRate - 115200
%   DataBits - 8
%   Parity - Even
%   StopBits - 1
%   Terminator - LF
%   BytesAvailableFcnMode - Terminator
%   BytesAvailableFcn - @Scor6AxisReadCallback
%   use Scor6AxisInit(COM) to set these automatically
% dt - scalar double precision floating point value specifying delta time
%   in seconds
% values - Nx6 array containing floating point joint positions in radians
%   values(1,:) - first set of joint velocities
%   values(2,:) - second set of joint velocities
%   ...
%   values(N,:) - nth set of joint velocities

%% Check inputs
narginchk(3,3);
if ~isvalid(ser)
    error('Ser must be a valid serial object');
end
if ~isnumeric(dt) || numel(dt) ~= 1
    error('Delta time must be specified as a scalar value.');
end
if ~isnumeric(values) || size(values,2) ~= 6
    error('The specified velocity values must be Nx6.');
end


% %% Create simulated message
% if used, change output to '%s' at lines 67 and 69 instead of
%   '%d,%f,%f,%f,%f,%f,%f'
% n = 100; % total number of data points
% message = rand(n,6)*3;
% 
% for i = 1:n
%     msg{i} = sprintf('%d,%f,%f,%f,%f,%f,%f\n',[i,message(i,:)]);
%     fprintf('%s\n', msg{i});
% end

%% Create message from values
for i = 1:size(values, 1)
    msg(i, 1) = i;
    msg(i, 2:7) = values(i, :);
end

%% Send data
% Check transfer status and wait for idle
while true
    switch ser.TransferStatus
        case 'idle'
            break
    end
end
% Set preamble
fprintf(ser, '!VelCMDdt%f\n', dt, 'async');
for i = 1:size(msg,1)
    while true
        switch ser.TransferStatus
            case 'idle'
                break
        end
    end
    % Print to command window
    fprintf('%d,%f,%f,%f,%f,%f,%f\n',msg(i,:));
    % Print to serial line
    fprintf(ser, '%d,%f,%f,%f,%f,%f,%f\n', msg(i,:), 'async');
end
% Check transfer status and wait for idle
while true
    switch ser.TransferStatus
        case 'idle'
            break
    end
end
% Set termination
trm = '**';
fprintf('%s\n',trm);
fprintf(ser, '%s\n', trm, 'async');
confirm = true;
end