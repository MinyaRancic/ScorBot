function ScorSendXYZPR( udpS, XYZPR )
% SCORSENDXYZPR sends the current XYZPR or a specified XYZPR value
%   ScorSendXYZPR(udpS) sends the current XYZPR value from ScorBot to the
%   UDP sender specified in udpS.
%
%   ScorSendXYZPR(udpS,XYZPR) sends the specified XYZPR value to the UDP
%   sender specified in udpS.
%
% See also ScorInitSender ScorInitReceiver ScorReceiveXYZPR
%
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
XYZPR = str2num(msg_Rsvd);

%% Check message
if ~isnumeric(XYZPR) || numel(XYZPR) ~= 5
    XYZPR = []; % return an empty set
end

end

