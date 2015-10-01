function XYZPR = ScorSimGetXYZPR(scorSim)
% SCORSIMGETXYZPR get the current 5-element task configuration from the 
% ScorBot visualization.
%   XYZPR = SCORSIMGETXYZPR(scorSim) get the current 5-element task 
%   configuration "XYZPR" from the ScorBot visualization specified by 
%   "scorSim". 
%
%   See also ScorSimInit ScorSimGetBSEPR
%
%   (c) M. Kutzer, 14Aug2015, USNA

% Updates
%   01Oct2015 - Updated to include error checking

%% Error checking
if nargin < 1
    error('The simulation object must be specified. Use "ScorSimGetXYZPR(scorSim)".')
end

%% Get XYZPR
BSEPR = ScorSimGetBSEPR(scorSim);
XYZPR = ScorBSEPR2XYZPR(BSEPR);