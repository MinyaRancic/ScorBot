%% CCC
clear all;
close all;
clc;

%% Setup serial
COM = 'COM8';
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
fopen(s);

%% Create simulated message
% message(1, 1) = 1;
% for j = 1:100
%     for i = 1:6
%         message(j, i+1) = rand()*3;
%         message(j, 1) = j;
%     end
%     x(j, 1) = num2str(message(j, 2));
% end
% for i = 1:100
%     msg(i, :) = char(x(i, :));
% end

n = 100; % total number of data points
message = rand(n,6);

for i = 1:size(message,1)
    msg{i} = sprintf('%d,%f,%f,%f,%f,%f,%f\n',[i,message(i,:)]);
end

%% Set dt and send message
dt = .05;
% Check transfer status and wait for idle
while true
    switch s.TransferStatus
        case 'idle'
            break
    end
end
% Set preamble
fprintf(s, '!PosCMDdt%f\n', dt, 'async');
for i = 1:numel(msg)
    while true
        switch s.TransferStatus
            case 'idle'
                break
        end
    end
    % Print to command window
    fprintf('%s',msg{i});
    % Print to serial line
    fprintf(s, '%s', msg{i}, 'async');
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