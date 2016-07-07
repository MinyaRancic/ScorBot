function Pose = ScorReceivePose(udpR)
% SCORRECEIVEPose receives a Pose value from a port designated by a UDP 
% receiver object
%   Pose = ScorSendPose(udpS) receives a Pose value from a port 
%   designated by a UDP receiver object specified in udpR.
% 
%   Note: If no value is received or message contains an invalid vector,
%   this function will return an empty set.
%
% See also ScorInitSender ScorInitReceiver ScorSendPose
%
% M. Kutzer, 12Apr2016, USNA

%% Check UDP Receiver
switch class(udpR)
    case 'dsp.UDPReceiver'
        % Valid UDPReceiver
    otherwise
        error('ScorReceive:BadReceiver',...
            ['Specified UDP Receiver must be valid.',...
             '\n\t-> Use "udpR = ScorRcver(port);" with a valid port ',...
             '\n\t   number to create a valid UDP Receiver.']);
end

%% Receive message
% Receive message
dataReceived = step(udpR);
% Convert message
msg_Rsvd = char(dataReceived');
% Parse message
Pose = str2num(msg_Rsvd);

%% Check message
if ~isnumeric(Pose) || numel(Pose) ~= 16
    Pose = []; % return an empty set
end
