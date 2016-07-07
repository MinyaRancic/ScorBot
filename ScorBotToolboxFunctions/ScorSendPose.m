function ScorSendPose(udpS,Pose)
% SCORSENDPose sends the current Pose or a specified Pose value
%   ScorSendPose(udpS) sends the current Pose value from ScorBot to the
%   UDP sender specified in udpS.
%
%   ScorSendPose(udpS,Pose) sends the specified Pose value to the UDP
%   sender specified in udpS.
%
% See also ScorInitSender ScorInitReceiver ScorReceivePose
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

%% Get Pose
if nargin < 2
    Pose = ScorGetPose;
end

%% Check Pose 
if ~isnumeric(Pose) || numel(Pose) ~= 16
    if isempty(inputname(1))
        txt = 'scorSim';
    else
        txt = inputname(1);
    end
    error('ScorSend:BadPose',...
        ['Pose configuration must be specified as a 4x4-element numeric array.',...
        '\n\t-> Use "%s(%s,[Joint1,Joint2,...,Joint5]);".'],mfilename,txt);
end

%% Send message
% Create message
msg_Send = sprintf('[%f,%f,%f,%f,%f]',Pose);
% Convert message
dataSend = uint8(msg_Send);
% Send message
step(udpS, dataSend);