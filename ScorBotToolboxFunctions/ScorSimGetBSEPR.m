function BSEPR = ScorSimGetBSEPR(scorSim)
% SCORSIMGETBSEPR get the current 5-element joint configuration from the 
% ScorBot visualization.
%   BSEPR = SCORSIMGETBSEPR(scorSim) get the current 5-element joint 
%   configuration "BSERP" from the ScorBot visualization specified by 
%   "scorSim". 
%
%   See also ScorSimInit ScorSimGetXYZPR
%
%   (c) M. Kutzer, 13Aug2015, USNA

for i = 1:numel(scorSim.Joints)
    H = get(scorSim.Joints(i),'Matrix');
    BSEPR(i) = atan2(H(2,1),H(1,1));
end