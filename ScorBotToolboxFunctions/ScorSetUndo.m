function confirm = ScorSetUndo
% SCORSETUNDO returns ScorBot to the previously set waypoint
% 
%   See also: ScorSetBSEPR ScorSetXYZPR ScorSetPose ScorSetDeltaBSEPR
%   ScorSetDeltaXYZPR ScorSetDeltaPose
%
%   M. Kutzer, 20Apr2016, USNA

global ScorSetUndoBSEPR

if isempty(ScorSetUndoBSEPR)
    warning('No previous waypoints detected.');
    return
end

confirm = ScorSetBSEPR(ScorSetUndoBSEPR);