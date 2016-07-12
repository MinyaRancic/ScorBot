function ScorSim6AxisReadSerial(COM)
%% Declare global variables for most recent data point
global recentT;
global recentP;
global recentV;
global recentS;
%% Check if requested serial port already exists
inst = instrfind('Port',COM);
if isempty(inst)
    % Create new serial object if port is free
    s = serial(COM);
else
    % Use existing object if port is already declared
    s = inst;
    fclose(s); % close the existing connection (to reopen later)
end

%% Initialize serial object
    s = serial(COM);
    set(s,'BaudRate',115200);
    set(s,'DataBits',8);
    set(s,'Parity','even');
    set(s,'StopBits',1);
    set(s,'Terminator','LF');
    set(s, 'BytesAvailableFcnMode', 'Terminator');
    set(s, 'BytesAvailableFcn', @scorBot6AxisCallback);
    fopen(s);


    %% Read serial object
    flushinput(s);
end

function scorBot6AxisCallback(s, event)
global recentT;
global recentP;
global recentV;
global recentS;
    if s.BytesAvailable > 9
        data = fscanf(s,...
            ['$T%f,',...
            'P%f,%f,%f,%f,%f,%f,',...
            'V%f,%f,%f,%f,%f,%f,',...
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
end

% splitStr = zeros(20);
% out = zeros(2);
% A = zeros(20);
% B = zeros(20);
% for i = 1:20
%     fopen(s);
%     out = (fscanf(s));
%     splitStr = regexp(out,',','split');
%     while size(splitStr) ~= 19
%         out = fscanf(s);
%         splitStr = regexp(out, ',', 'split');
%     end
%     A = cell2table(splitStr);
%     B = table2array(A);
%     for j = 1:19
%         data(i,j) = str2double(B(1,j));
%     end
%     T = data(1); % Time stamp
%     P = data(2:7); % Axis positions
%     V = data(8:13); % Axis velocities
%     S = data(14:19); % Axis states
%     fclose(s);
% end