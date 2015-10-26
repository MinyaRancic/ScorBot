function ScorSimSetGripper(scorSim,grip)
% SCORSIMSETGRIPPER set the ScorBot visualization gripper state in 
% millimeters above fully closed.
%   SCORSIMSETGRIPPER(scorSim,grip) set the ScorBot visualization gripper 
%   state in millimeters. State is measured as the distance between the 
%   gripper fingers. A fully closed gripper has a "grip" of 0 mm. A fully 
%   open gripper has a "grip" of 70 mm.
%       grip - scalar gripper state in millimeters
%
%   Binary (Open/Close) Commands:
%       SCORSIMSETGRIPPER(scorSim,'Open') fully opens the gripper
%       SCORSIMSETGRIPPER(scorSim,'Close') fully closes the gripper
%
%   Note: Actual hardware resolution is rounded to millimeters. Fractions
%       of millimeter grip precision is possible in the simulation only.
%       Rounding is not included to enable smooth animations for 
%       interpolated grip data.
%
%   See also ScorSimInit ScorSimGetGripper
%
%   (c) M. Kutzer, 30Sep2015, USNA

% Updates
%   01Oct2015 - Updated to include error checking
%   03Oct2015 - Updated to include gripper functionality

%% Error checking
if nargin < 2
    error('Both the simulation object and grip parameter must be specified. Use "ScorSimSetGripper(scorSim,grip)".')
end

%% Parse inputs
if ischar(grip)
    switch lower(grip)
        case 'open'
            grip = 70;
        case 'close'
            grip = 0;
        otherwise
            error('Unexpected grip state.');
    end
end

%% Check grip
if grip > 70 || grip < 0
    error('Gripper value must be between 0 and 70 millimeters.');
end
%grip = round(grip); % round off to match ScorBot hardware functionality

%% Move simulation
g0 = 34.00+21.6-0.028; % this value must match in get and set command
o = (grip - g0)/2;
h = 47.22; % this value must match in get and set command

ang = -asin(o/h);

%% Right fingers
for i = 1:2
    set(scorSim.Finger(i),'Matrix',Rx(ang));
end

%% Right fingertip
set(scorSim.FingerTip(1),'Matrix',Rx(-ang));

%% Left fingers
for i = 3:4
    set(scorSim.Finger(i),'Matrix',Rx(-ang));
end

%% Right fingertip
set(scorSim.FingerTip(2),'Matrix',Rx(ang));

%% Update plot
drawnow