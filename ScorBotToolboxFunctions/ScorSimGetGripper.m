function grip = ScorSimGetGripper(scorSim)
% SCORSIMGETGRIPPER get the gripper state of the ScorBot visualization as 
% measured in millimeters above fully closed.
%   grip = SCORSIMGETGRIPPER(scorSim) get the gripper state of the ScorBot
%   visualization in millimeters. State is measured as the distance between
%   the gripper fingers. A fully closed gripper has a "grip" of 0 mm. A 
%   fully open gripper has a "grip" of approximately 70 mm.
%
%   See also ScorSimInit ScorSimSetGripper
%
%   (c) M. Kutzer, 30Sep2015, USNA

% Updates
%   01Oct2015 - Updated to include error checking
%   03Oct2015 - Updated to include gripper functionality

%% Error checking
if nargin < 1
    error('The simulation object must be specified. Use "ScorSimGetGripper(scorSim)".')
end

%% Get grip
g0 = 34.00+21.6-0.028; % this value must match in get and set command
h = 47.22; % this value must match in get and set command

H = get(scorSim.Finger(1),'Matrix');
ang = atan2(H(3,2),H(2,2));

o = -h*sin(ang);

grip = 2*o+g0;
