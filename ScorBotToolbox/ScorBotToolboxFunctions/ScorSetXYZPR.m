function confirm = ScorSetXYZPR(varargin)
% SCORSETXYZPR moves the ScorBot end-effector to a specified x,y,z 
% position, and pitch and roll orientation.
%   SCORSETXYZPR(XYZPR) moves the ScorBot to the 5-element task-space 
%   vector containing the end-effector x,y,z position, and end-effector 
%   pitch and roll orientation.
%       XYZPR - 5-element vector containing end-effector position and
%       orientation.
%           XYZPR(1) - end-effector x-position in millimeters
%           XYZPR(2) - end-effector y-position in millimeters
%           XYZPR(3) - end-effector z-position in millimeters
%           XYZPR(4) - end-effector pitch in radians
%           XYZPR(5) - end-effector roll in radians
%
%   SCORSETXYZPR(...,'MoveType',mode) specifies whether the movement is
%   linear in task space or linear in joint space.
%       Mode: {['LinearTask'] 'LinearJoint'}
%
%   confirm = SCORSETXYZPR(___) returns 1 if successful and 0 otherwise.
%
%   Note: Wrist pitch angle of BSEPR does not equal the pitch angle of 
%   XYZPR. BSEPR pitch angle is body-fixed while the pitch angle of XYZPR 
%   is calculated relative to the base.
%
%   See also ScorGetXYZPR ScorSetBSEPR ScorGetBSEPR
%
%   References:
%       [1] C. Wick, J. Esposito, & K. Knowles, US Naval Academy, 2010
%           http://www.usna.edu/Users/weapsys/esposito-old/_files/scorbot.matlab/MTIS.zip
%           Original function name "ScorCartMove.m"
%       
%   (c) M. Kutzer, 10Aug2015, USNA

% Updates
%   25Aug2015 - Updated correct help documentation, "J. Esposito K. 
%               Knowles," to "J. Esposito, & K. Knowles,"
%               Erik Hoss
%   28Aug2015 - Updated error handling

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
    XYZPR = varargin{1};
end

%% Set point
isSet = ScorSetPoint(XYZPR,'Mode','Absolute');
if ~isSet
    confirm = false;
    return
end

%% Goto point
isMove = ScorGotoPoint('MoveType',mType);
if isMove
    confirm = true;
    return
else
    confirm = false;
    return
end
