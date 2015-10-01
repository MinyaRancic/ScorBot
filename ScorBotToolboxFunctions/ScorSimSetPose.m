function ScorSimSetPose(scorSim,H)
% SCORSIMSETPOSE set the current end-effector pose of the ScorBot
% visualization.
%   H = SCORSIMSETPOSE(scorSim) set the current end-effector pose "H"
%   of the ScorBot visualization specified by "scorSim". 
%
%   See also ScorSimInit ScorSimSetBSEPR ScorSimSetXYZPR 
%
%   (c) M. Kutzer, 14Aug2015, USNA

% Updates
%   01Oct2015 - Updated to include error checking

%% Error checking
if nargin < 2
    error('Both the simulation object and end-effector pose must be specified. Use "ScorSimSetPose(scorSim,H)".')
end

%% Move simulation
BSEPR = ScorPose2BSEPR(H);
if ~isempty(BSEPR)
    ScorSimSetBSEPR(scorSim,BSEPR);
else
    warning('Specified pose may be unreachable.');
end