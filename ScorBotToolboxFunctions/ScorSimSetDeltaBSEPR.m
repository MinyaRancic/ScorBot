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

BSEPR = ScorSimGetBSEPR(scorSim);
BSEPR = BSEPR + dBSEPR;
ScorSimSetBSEPR(scorSim,BSEPR);
drawnow
