function confirm = ScorSetDeltaPose(varargin)
% SCORSETDELTAPOSE moves the ScorBot to a designated end-effector pose 
% relative to the current end-effector pose.
%   SCORSETPOSE(H) moves the ScorBot end-effector to a specified 4x4 
%   homogeneous transformation representing the end-effector pose of 
%   ScorBot relative to the current end-effector pose of ScorBot.
%
%   SCORSETDELTAPOSE(...,'MoveType',mode) specifies whether the movement is
%   linear in task space or linear in joint space.
%       Mode: {['LinearTask'] 'LinearJoint'}
%
%   confirm = SCORSETDELTAPOSE(___) returns 1 if successful and 0 otherwise.
%
%   See also ScorPose2XYZPR ScorSetDeltaXYZPR
%
%   (c) M. Kutzer, 17Aug2015, USNA

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
    H_rel = varargin{1};
end

%% Get current pose
H_cur = ScorGetPose;

%% Calculate absolute pose
H = H_cur*H_rel;

%% Move to pose
confirm = ScorSetPose(H,'MoveType',mType);
