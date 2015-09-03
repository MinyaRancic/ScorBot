function ScorSimSetBSEPR(scorSim,BSEPR)
% SCORSIMSETBSEPR set the ScorBot visualization to the specified 5-element
% joint configuration.
%   SCORSIMSETBSEPR(scorSim,BSEPR) set the ScorBot visualization specified 
%   by "scorSim" to the specified 5-element joint configuration "BSEPR".
%
%   See also ScorSimInit ScorSimSetXYZPR
%
%   (c) M. Kutzer, 13Aug2015, USNA

for i = 1:numel(scorSim.Joints)
    set(scorSim.Joints(i),'Matrix',Rz(BSEPR(i)));
end
drawnow