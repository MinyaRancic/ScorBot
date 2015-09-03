function H = ScorSimGetPose(scorSim)
% SCORSIMGETPOSE get the current end-effector pose from the ScorBot
% visualization.
%   H = SCORSIMGETPOSE(scorSim) get the current end-effector pose "H"
%   from the ScorBot visualization specified by "scorSim". 
%
%   See also ScorSimInit ScorSimGetBSEPR ScorSimGetXYZPR 
%
%   (c) M. Kutzer, 13Aug2015, USNA

BSEPR = ScorSimGetBSEPR(scorSim);
ScorSimSetBSEPR(BSEPR);