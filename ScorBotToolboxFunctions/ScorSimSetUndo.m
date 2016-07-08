function confirm = ScorSimSetUndo(scorSim)
% SCORSIMSETUNDO returns ScorBotSim to the previously set waypoint
% 
%   See also: ScorSimSetBSEPR ScorSimSetXYZPR ScorSimSetPose ScorSimSetDeltaBSEPR
%   ScorSimSetDeltaXYZPR ScorSimSetDeltaPose
%
%   M. Kutzer, 20Apr2016, USNA

global ScorSimSetUndoBSEPR

if isempty(ScorSimSetUndoBSEPR)
    warning('No previous waypoints detected.');
    return
end

confirm = ScorSimSetBSEPR(scorSim.Simulation, ScorSimSetUndoBSEPR);