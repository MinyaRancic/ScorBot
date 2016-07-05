function udpR = ScorInitReceiver(port)
% SCORINITRECEIVER defines a UDP client for receiving ScorBot information
% from to a remote server
%   udpR = ScorInitReceiver(port) initializes a UDP Receiver tied to the 
%   designated port (suggested ports 31000 - 32000)
%
% See also ScorInitSender ScorSendBSEPR ScorReceiveBSEPR
%
% M. Kutzer, 12Apr2016, USNA

%% Check inputs
% TODO - check port range
% TODO - check for valid IP

%% Create UDP receiver
udpR = dsp.UDPReceiver('LocalIPPort',port);