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

BSEPR = ScorSimGetBSEPR(scorSim);
XYZPR = ScorBSEPR2XYZPR(BSEPR);