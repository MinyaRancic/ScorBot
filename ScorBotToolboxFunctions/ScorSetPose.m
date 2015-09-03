function confirm = ScorSetPose(varargin)
% SCORSETPOSE moves the ScorBot to a designated end-effector pose.
%   SCORSETPOSE(H) moves the ScorBot end-effector to a specified 4x4 
%   homogeneous transformation representing the end-effector pose of 
%   ScorBot.
%
%   SCORSETPOSE(...,'MoveType',mode) specifies whether the movement is
%   linear in task space or linear in joint space.
%       Mode: {['LinearTask'] 'LinearJoint'}
%
%   confirm = SCORSETPOSE(___) returns 1 if successful and 0 otherwise.
%
%   See also ScorPose2XYZPR ScorSetXYZPR
%
%   (c) M. Kutzer, 14Aug2015, USNA

%% Check inputs 
narginchk(1,3);

mType = 'LinearTask'; 
nInputs = nargin;
if nInputs >= 3
    if strcmpi('movetype',varargin{end-1})
        mType = varargin{end};
        nInputs = nInputs - 2;
    else
        error('Unrecognized property name.');
    end
end
if nInputs == 1
    H = varargin{1};
end

%% Get XYZPR
XYZPR = ScorPose2XYZPR(H);
if isempty(XYZPR)
    confirm = false;
    warning('Specified pose may be unreachable.');
    return
end

confirm = ScorSetXYZPR(XYZPR,'MoveType',mType);