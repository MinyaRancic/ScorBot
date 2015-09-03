function confirm = ScorSetDeltaXYZPR(varargin)
% SCORSETDELTAXYZPR moves the ScorBot end-effector to a specified x,y,z 
% position, and pitch and roll orientation relative to the current
% end-effector position and orientation.
%   SCORSETDELTAXYZPR(DeltaXYZPR) changes ScorBot's end-effector position
%   and orientation by the changes specified 5-element task-space vector.
%       DeltaXYZPR - 5-element vector containing changes in end-effector 
%       position and orientation.
%           DeltaXYZPR(1) - change in end-effector x-position in millimeters
%           DeltaXYZPR(2) - change in end-effector y-position in millimeters
%           DeltaXYZPR(3) - change in end-effector z-position in millimeters
%           DeltaXYZPR(4) - change in end-effector pitch in radians
%           DeltaXYZPR(5) - change in end-effector roll in radians
%
%   SCORSETDELTAXYZPR(...,'MoveType',mode) specifies whether the movement 
%   is linear in task space or linear in joint space.
%       Mode: {['LinearTask'] 'LinearJoint'}
%
%   confirm = SCORSETDELTAXYZPR(___) returns 1 if successful and 0 otherwise.
%
%   See also ScorSetDeltaBSEPR ScorSetXYZPR
%
%   References:
%       [1] C. Wick, J. Esposito, &  K. Knowles, US Naval Academy, 2010
%           http://www.usna.edu/Users/weapsys/esposito-old/_files/scorbot.matlab/MTIS.zip
%           Original function name "ScorDeltaCartMove.m"
%       
%   (c) C. Wick, J. Esposito, K. Knowles, & M. Kutzer, 10Aug2015, USNA

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
    DeltaXYZPR = varargin{1};
end

%% Set point
isSet = ScorSetPoint(DeltaXYZPR,'Mode','Relative');
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