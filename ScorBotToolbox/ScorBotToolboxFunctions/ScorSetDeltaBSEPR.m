function confirm = ScorSetDeltaBSEPR(varargin)
% SCORSETDELTABSEPR moves the ScorBot to a specified joint configuration 
% relative to the current joint configuration.
%   SCORSETDELTABSEPR(DeltaBSEPR) moves each of ScorBot's joints by 
%   increments define in the 5-element joint-space vector angles ordered 
%   from the base up. 
%       DeltaBSEPR - 5-element joint vector in radians
%           DeltaBSEPR(1) - relative base joint movement angle in radians
%           DeltaBSEPR(2) - relative shoulder joint movement angle in radians
%           DeltaBSEPR(3) - relative elbow joint movement angle in radians
%           DeltaBSEPR(4) - relative wrist pitch movement angle in radians
%           DeltaBSEPR(5) - relative wrist roll movement angle in radians
%
%   SCORSETDELTABSEPR(...,'MoveType',mode) specifies whether the movement 
%   is linear in task space or linear in joint space.
%       Mode: {'LinearTask' ['LinearJoint']}
%
%   confirm = SCORSETDELTABSEPR(___) returns 1 if successful and 0 
%   otherwise.
%
%   See also: ScorSetDeltaXYZPR
%
%   References:
%       [1] C. Wick, J. Esposito, & K. Knowles, US Naval Academy, 2010
%           http://www.usna.edu/Users/weapsys/esposito-old/_files/scorbot.matlab/MTIS.zip
%           Original function name "ScorDeltaJtMove.m"
%       
%   (c) C. Wick, J. Esposito, K. Knowles, & M. Kutzer, 10Aug2015, USNA

% Updates
%   25Aug2015 - Updated correct help documentation, "J. Esposito K. 
%               Knowles," to "J. Esposito, & K. Knowles,"
%               Erik Hoss
%   01Sep2015 - Added ScorIsReady to account for potential empty set error
%               later in code (with ScorGetBSEPR)

% TODO - account for excessive movements 
%        (e.g. ScorSetDeltaBSEPR([0,-pi,0,0,0]);

%% Check ScorBot
isReady = ScorIsReady;
if ~isReady
    confirm = false;
    return
end

%% Check inputs 
narginchk(1,3);

mType = 'LinearJoint'; 
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
    DeltaBSEPR = varargin{1};
end

%% Move delta
BSEPR_Old = ScorGetBSEPR;
XYZPR_Old = ScorGetXYZPR;

BSEPR_New = BSEPR_Old + DeltaBSEPR;
% Check for elbow-down condition
if BSEPR_New(3) > 0
    warning('This ScorBot library does not support movements resulting in an "elbow down" configuration.');
    confirm = false;
    return
end
XYZPR_New = ScorBSEPR2XYZPR(BSEPR_New);

DeltaXYZPR = XYZPR_New - XYZPR_Old;
confirm = ScorSetDeltaXYZPR(DeltaXYZPR,'MoveType',mType);