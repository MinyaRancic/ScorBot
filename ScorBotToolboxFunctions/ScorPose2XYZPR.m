function XYZPR = ScorPose2XYZPR(varargin)
% SCORPOSE2XYZPR calculates the XYZPR parameters of the end-effector given
% the pose of the ScorBot end-effector.
%   XYZPR = SCORPOSE2XYZPR(H) calculates the 5-element XYZPR task space 
%   vector given a 4x4 homogeneous transformation representing the 
%   end-effector pose of ScorBot
%       XYZPR - 5-element vector containing end-effector position and
%       orientation.
%           XYZPR(1) - end-effector x-position in millimeters
%           XYZPR(2) - end-effector y-position in millimeters
%           XYZPR(3) - end-effector z-position in millimeters
%           XYZPR(4) - end-effector wrist pitch in radians
%           XYZPR(5) - end-effector wrist roll in radians
%       H - 4x4 homogeneous transformation with distance parameters
%           specified in millimeters
%
%   XYZPR = SCORPOSE2XYZPR(H,'AllSolutions') calculates two 5-element XYZPR 
%   task space vectors (packaged in a cell array) given a 4x4 homogeneous 
%   transformation. Each XYZPR returned represents a possible combination 
%   parameters resulting in the same end-effector pose of ScorBot given two
%   possible base joint angles offset by pi. If solutions are redundant,  
%   the second solution is removed. 
%       b(1) = atan2(XYZPR(2),XYZPR(1))
%       b(2) = atan2(XYZPR(2),XYZPR(1)) + pi
%
%   See also ScorXYZPR2Pose ScorIkin ScorBSEPR2Pose
%
%   (c) M. Kutzer, 11Aug2015, USNA

% Updates
%   23Dec2015 - Updated to clarify errors.

%% Check inputs
% This assumes nargin is fixed to 1 or 2 with a set of common errors.

% Check for zero inputs
if nargin < 1
    error('ScorX2Y:NoPose',...
        ['End-effector pose must be specified.',...
        '\n\t-> Use "ScorPose2XYZPR(H)".']);
end
% Check Pose
if nargin >= 1
    H = varargin{1};
    if size(H,1) ~= 4 || size(H,2) ~= 4 || ~isSE(H)
        error('ScorX2Y:BadPose',...
            ['End-effector pose must be specified as a valid 4x4 element of SE(3).',...
            '\n\t-> Use "ScorPose2XYZPR(H)".']);
    end
end
% Check property value
if nargin >= 2
    switch lower(varargin{2})
        case 'allsolutions'
            % Return all solutions
        otherwise
            error('ScorX2Y:BadPropVal',...
                ['Unexpected property value: "%s".',...
                '\n\t-> Use "ScorPose2XYZPR(H,''AllSolutions'')".'],varargin{2});
    end
end
% Check for too many inputs
if nargin > 2
    warning('Too many inputs specified. Ignoring additional parameters.');
end

%% Calculate XYZPR
BSEPR = ScorPose2BSEPR(H,'AllSolutions');
if isempty(BSEPR)
    % No solution exists
    XYZPR = [];
    return
end

for i = 1:size(BSEPR,1)
    XYZPR(i,:) = ScorBSEPR2XYZPR(BSEPR(i,:));
end

%% Package output
if nargin == 1
    % Output first XYZPR solution
    XYZPR = XYZPR(1,:);
    return
end

switch lower(varargin{2})
    case 'allsolutions'
        % Output all XYZPR solutions
    case 'firstsolution'
        % Output first XYZPR solution
        XYZPR = XYZPR(1,:);
    case 1
        % Output first XYZPR solution
        XYZPR = XYZPR(1,:);
    case 2
        % Output all XYZPR solutions
    otherwise
        error('Unexpected property value.');
end