function Scor6AxisReadCallback(ser, event)
%% ScorBot6AxisCallback returns Time, Position, Velocities, and States of
% the different joints of the simulation
%
% 
%
% D. Saiontz, 12July2016, USNA/SEAP

%% Globals for most recent Time, Positions, Velocities, and States as globals

global recentT;
global recentP;
global recentV;
global recentS;

%% Make sure that the right event type is being used, read serial port
% for data, and return data in command window

try
switch event.Type
    case 'BytesAvailable'
        if ser.BytesAvailable > 9
            data = fscanf(ser,...
                ['$T%f',...
                'P%f,%f,%f,%f,%f,%f',...
                'V%f,%f,%f,%f,%f,%f',...
                'S%d,%d,%d,%d,%d,%d'],[1,19]);
            T = data(1); % Time stamp
            P = data(2:7); % Axis positions
            V = data(8:13); % Axis velocities
            S = data(14:19); % Axis states
            recentT = T;
            recentP = P;
            recentV = V;
            recentS = S;
            fprintf('Time: %.2f\n',T)
            fprintf('Position: %.2f, %.2f, %.2f, %.2f, %.2f, %.2f\n', P);
            fprintf('Velocities: %.2f, %.2f, %.2f, %.2f, %.2f, %.2f\n', V);
            fprintf('States: %d, %d, %d, %d, %d, %d\n', S);
        end
    otherwise
        error('Unexpected event.')
end
catch
    flushinput(ser);
end