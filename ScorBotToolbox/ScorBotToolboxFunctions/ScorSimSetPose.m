function ScorSimSetPose(scorSim,H)
% SCORSIMSETPOSE set the current end-effector pose of the ScorBot
% visualization.
%   H = SCORSIMSETPOSE(scorSim) set the current end-effector pose "H"
%   of the ScorBot visualization specified by "scorSim". 
%
%   See also ScorSimInit ScorSimSetBSEPR ScorSimSetXYZPR 
%
%   (c) M. Kutzer, 14Aug2015, USNA

BSEPR = ScorPose2BSEPR(H);
if ~isempty(BSEPR)
    ScorSimSetBSEPR(scorSim,BSEPR);
else
    warning('Specified pose may be unreachable.');
end