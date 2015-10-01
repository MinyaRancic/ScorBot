function ScorSimGoHome(scorSim)
% SCORSIMGOHOME moves the ScorBot visualization to the home position.
%   SCORSIMGOHOME(scorSim) moves the ScorBot visualization to the home 
%   position.
%       scorSim.Figure - figure handle of ScorBot visualization
%       scorSim.Axes   - axes handle of ScorBot visualization
%       scorSim.Joints - 1x5 array containing joint handles for ScorBot
%           visulization (hgtransform objects, use 
%           set(scorSim.Joints(i),'Matrix',Rz(angle)) to change a specific
%           joint angle)
%       scorSim.Frames - 1x5 array containing reference frame handles for
%           ScorBot (hgtransform objects with triad.m decendants)
%
%   See also ScorSimInit ScorSimSetBSEPR ScorSimGetBSEPR ScorSimSetXYZPR
%       ScorSimGetXYZPR etc
%
%   (c) M. Kutzer, 14Aug2015, USNA

% Updates
%   01Oct2015 - Updated to include error checking

%% Error checking
if nargin < 1
    error('The simulation object must be specified. Use "ScorSimGoHome(scorSim)".')
end

%% Go Home
BSEPRhome = [0.00000,2.09925,-1.65843,-1.54994,0.00000];
ScorSimSetBSEPR(scorSim,BSEPRhome);