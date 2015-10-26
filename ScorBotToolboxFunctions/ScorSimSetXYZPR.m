function ScorSimSetXYZPR(scorSim,XYZPR)
% SCORSIMSETXYZPR set the ScorBot visualization to the specified 5-element
% task configuration.
%   SCORSIMSETXYZPR(scorSim,XYZPR) set the ScorBot visualization specified 
%   by "scorSim" to the specified 5-element task configuration "XYZPR".
%
%   See also ScorSimInit ScorSimSetDeltaXYZPR ScorSimSetBSEPR
%
%   (c) M. Kutzer, 14Aug2015, USNA

% Updates
%   01Oct2015 - Updated to include error checking
%   23Oct2015 - Account for elbow-up and elbow-down solutions using current
%               simulation configuration.

%% Error checking
if nargin < 2
    error('Both the simulation object and task configuration must be specified. Use "ScorSimSetXYZPR(scorSim,XYZPR)".')
end

%% Check for elbow-up or elbow-down using current simulation configuration
BSEPR = ScorSimGetBSEPR(scorSim);
E = BSEPR(3);
if E > 0
    % Elbow-down
    ElbowStr = 'ElbowDownSolution';
else
    % Elbow-up
    ElbowStr = 'ElbowUpSolution';
end

%% Move simulation
BSEPR = ScorXYZPR2BSEPR(XYZPR,ElbowStr);
if ~isempty(BSEPR)
    ScorSimSetBSEPR(scorSim,BSEPR);
else
    warning('Specified pose may be unreachable.');
end