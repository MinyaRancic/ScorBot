function ScorSimSetDeltaBSEPR(scorSim,dBSEPR)
% SCORSIMSETDELTABSEPR set the ScorBot visualization by increments 
%   specified in the 5-element joint configuration.
%   SCORSIMSETDELTABSEPR(scorSim,BSEPR) set the ScorBot visualization 
%   specified in "scorSim" by increments specified in the 5-element joint 
%   configuration "BSEPR".
%
%   See also ScorSimInit ScorSimSetBSEPR ScorSimSetDeltaXYZPR
%
%   (c) M. Kutzer, 25Sep2015, USNA

% Updates
%   01Oct2015 - Updated to include error checking

%% Error checking
if nargin < 2
    error('Both the simulation object and change in joint configuration must be specified. Use "ScorSimSetDeltaBSEPR(scorSim,dBSEPR)".')
end

%% Move simulation
BSEPR = ScorSimGetBSEPR(scorSim);
BSEPR = BSEPR + dBSEPR;
ScorSimSetBSEPR(scorSim,BSEPR);
drawnow
