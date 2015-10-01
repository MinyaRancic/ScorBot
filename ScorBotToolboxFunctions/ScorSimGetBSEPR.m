function BSEPR = ScorSimGetBSEPR(scorSim)
% SCORSIMGETBSEPR get the current 5-element joint configuration from the 
% ScorBot visualization.
%   BSEPR = SCORSIMGETBSEPR(scorSim) get the current 5-element joint 
%   configuration "BSERP" from the ScorBot visualization specified by 
%   "scorSim". 
%
%   See also ScorSimInit ScorSimGetXYZPR
%
%   (c) M. Kutzer, 13Aug2015, USNA

% Updates
%   01Oct2015 - Updated to include error checking

%% Error checking
if nargin < 1
    error('The simulation object must be specified. Use "ScorSimGetBSEPR(scorSim)".')
end

%% Get BSEPR
for i = 1:numel(scorSim.Joints)
    H = get(scorSim.Joints(i),'Matrix');
    BSEPR(i) = atan2(H(2,1),H(1,1));
end