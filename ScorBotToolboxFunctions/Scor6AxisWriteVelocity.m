function Scor6AxisWriteVelocity(COM, dt, values)
%% Setup serial
inst = instrfind('Port',COM);
if isempty(inst)
    % Create new serial object if port is free
    s = serial(COM);
else
    % Use existing object if port is already declared
    s = inst;
    fclose(s); % close the existing connection (to reopen later)
end

set(s,'BaudRate',115200);
set(s,'DataBits',8);
set(s,'Parity','even');
set(s,'StopBits',1);
set(s,'Terminator','LF');
set(s,'BytesAvailableFcnMode','Terminator');
set(s,'BytesAvailableFcn',@Scor6AxisReadCallback);
fopen(s);

% %% Create simulated message
% n = 100; % total number of data points
% message = rand(n,6)*3;
% 
% for i = 1:size(message,1)
%     msg{i} = sprintf('%d,%f,%f,%f,%f,%f,%f\n',[i,message(i,:)]);
% end
% fprintf('%s', 'Past simulated message');

%% Send data
% Check transfer status and wait for idle
while true
    switch s.TransferStatus
        case 'idle'
            break
    end
end
% Set preamble
fprintf(s, '!VelCMDdt%f\n', dt, 'async');
for i = 1:size(values)
    while true
        switch s.TransferStatus
            case 'idle'
                break
        end
    end
    % Print to command window
    fprintf('%s',values(i));
    % Print to serial line
    fprintf(s, '%s', values(i), 'async');
end
% Check transfer status and wait for idle
while true
    switch s.TransferStatus
        case 'idle'
            break
    end
end
% Set termination
trm = '**\n';
fprintf('%s',trm);
fprintf(s, '%s', trm, 'async');
end