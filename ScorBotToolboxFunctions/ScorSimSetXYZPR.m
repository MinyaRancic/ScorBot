function ScorSimSetXYZPR(scorSim,XYZPR)
% SCORSIMSETXYZPR set the ScorBot visualization to the specified 5-element
% task configuration.
%   SCORSIMSETXYZPR(scorSim,XYZPR) set the ScorBot visualization specified 
%   by "scorSim" to the specified 5-element task configuration "XYZPR".
%
%   See also ScorSimInit ScorSimSetBSEPR
%
%   (c) M. Kutzer, 14Aug2015, USNA

BSEPR = ScorXYZPR2BSEPR(XYZPR);
if ~isempty(BSEPR)
    ScorSimSetBSEPR(scorSim,BSEPR);
else
    warning('Specified pose may be unreachable.');
end