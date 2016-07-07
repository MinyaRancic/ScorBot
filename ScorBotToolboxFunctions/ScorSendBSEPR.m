function ScorSendBSEPR(udpS,BSEPR)
% SCORSENDBSEPR sends the current BSEPR or a specified BSEPR value
%   ScorSendBSEPR(udpS) sends the current BSEPR value from ScorBot to the
%   UDP sender specified in udpS.
%
%   ScorSendBSEPR(udpS,BSEPR) sends the specified BSEPR value to the UDP
%   sender specified in udpS.
%
% See also ScorInitSender ScorInitReceiver ScorReceiveBSEPR
%
% M. Kutzer, 12Apr2016, USNA

%% Check UDP Sender
switch class(udpS)
    case 'dsp.UDPSender'
        % Valid UDPSender
    otherwise
        error('ScorSend:BadSender',...
            ['Specified UDP Sender must be valid.',...
             '\n\t-> Use "udpS = ScorSnder(port);" with a valid port ',...
             '\n\t   number to create a valid UDP Sender.']);
end

%% Get BSEPR
if nargin < 2
    BSEPR = ScorGetBSEPR;
end

%% Check BSEPR 
if ~isnumeric(BSEPR) || numel(BSEPR) ~= 5
    if isempty(inputname(1))
        txt = 'scorSim';
    else
        txt = inputname(1);
    end
    error('ScorSend:BadBSEPR',...
        ['Joint configuration must be specified as a 5-element numeric array.',...
        '\n\t-> Use "%s(%s,[Joint1,Joint2,...,Joint5]);".'],mfilename,txt);
end

%% Send message
% Create message
msg_Send = sprintf('[%f,%f,%f,%f,%f]',BSEPR);
% Convert message
dataSend = uint8(msg_Send);
% Send message
step(udpS, dataSend);