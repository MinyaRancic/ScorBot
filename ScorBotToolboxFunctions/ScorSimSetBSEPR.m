function ScorSimSetBSEPR(scorSim,BSEPR)
% SCORSIMSETBSEPR set the ScorBot visualization to the specified 5-element
% joint configuration.
%   SCORSIMSETBSEPR(scorSim,BSEPR) set the ScorBot visualization specified 
%   by "scorSim" to the specified 5-element joint configuration "BSEPR".
%
%   See also ScorSimInit ScorSimSetDeltaBSEPR ScorSimSetXYZPR
%
%   (c) M. Kutzer, 13Aug2015, USNA

% Updates
%   01Oct2015 - Updated to include error checking

%% Error checking
if nargin < 2
    error('Both the simulation object and joint configuration must be specified. Use "ScorSimSetBSEPR(scorSim,BSEPR)".')
end

%% Move simulation
for i = 1:numel(scorSim.Joints)
    set(scorSim.Joints(i),'Matrix',Rz(BSEPR(i)));
end
drawnow