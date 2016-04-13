function BSEPR = ScorReceiveBSEPR(udpR)
% SCORRECEIVEBSEPR receives a BSEPR value from a port designated by a UDP 
% receiver object
%   BSEPR = ScorSendBSEPR(udpS) receives a BSEPR value from a port 
%   designated by a UDP receiver object specified in udpR.
% 
%   Note: If no value is received or message contains an invalid vector,
%   this function will return an empty set.
%
% See also ScorInitSender ScorInitReceiver ScorSendBSEPR
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
BSEPR = str2num(msg_Rsvd);

%% Check message
if ~isnumeric(BSEPR) || numel(BSEPR) ~= 5
    BSEPR = []; % return an empty set
end
