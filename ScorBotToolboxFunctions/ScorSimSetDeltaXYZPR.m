function ScorSimSetDeltaXYZPR(scorSim,dXYZPR)
% SCORSIMSETDELTAXYZPR set the ScorBot visualization by increments 
%   specified in the 5-element task-space vector.
%   SCORSIMSETDELTAXYZPR(scorSim,XYZPR) set the ScorBot visualization 
%   specified in "scorSim" by increments specified in the 5-element 
%   task-space vector "XYZPR".
%
%   See also ScorSimInit ScorSimSetXYZPR ScorSimSetDeltaBSEPR
%
%   (c) M. Kutzer, 25Sep2015, USNA

XYZPR = ScorSimGetXYZPR(scorSim);
XYZPR = XYZPR + dXYZPR;
ScorSimSetXYZPR(scorSim,XYZPR);
drawnow