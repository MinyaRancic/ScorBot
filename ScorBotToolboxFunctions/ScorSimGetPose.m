function H = ScorSimGetPose(scorSim)
% SCORSIMGETPOSE get the current end-effector pose from the ScorBot
% visualization.
%   H = SCORSIMGETPOSE(scorSim) get the current end-effector pose "H"
%   from the ScorBot visualization specified by "scorSim". 
%
%   See also ScorSimInit ScorSimGetBSEPR ScorSimGetXYZPR 
%
%   (c) M. Kutzer, 13Aug2015, USNA
%
% Updates 
%   29Sep2015 - Updated to correct correct BSEPR2Pose

% Updates
%   01Oct2015 - Updated to include error checking

%% Error checking
if nargin < 1
    error('The simulation object must be specified. Use "ScorSimGetPose(scorSim)".')
end

%% Get pose
BSEPR = ScorSimGetBSEPR(scorSim);
H = ScorBSEPR2Pose(BSEPR);