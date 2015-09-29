function confirm = ScorSetBSEPR(varargin)
% SCORSETBSEPR moves the ScorBot to a specified joint configuration.
%   SCORSETBSEPR(BSEPR) moves the ScorBot to the 5-element joint-space 
%   vector containing joint angles ordered from the base up. 
%       BSEPR - 5-element joint vector in radians
%           BSEPR(1) - base joint angle in radians
%           BSEPR(2) - shoulder joint angle in radians
%           BSEPR(3) - elbow joint angle in radians
%           BSEPR(4) - wrist pitch angle in radians
%           BSEPR(5) - wrist roll angle in radians
%
%   SCORSETBSEPR(...,'MoveType',mode) specifies whether the movement is
%   linear in task space or linear in joint space.
%       Mode: {'LinearTask' ['LinearJoint']}
%
%   confirm = SCORSETBSEPR(___) returns 1 if successful and 0 otherwise.
%
%   Note: Wrist pitch angle of BSEPR does not equal the pitch angle of 
%   XYZPR. BSEPR pitch angle is body-fixed while the pitch angle of XYZPR 
%   is calculated relative to the base.
%
%   See also ScorGetBSEPR ScorSetXYZPR ScorGetXYZPR
%
%   References:
%       [1] C. Wick, J. Esposito, & K. Knowles, US Naval Academy, 2010
%           http://www.usna.edu/Users/weapsys/esposito-old/_files/scorbot.matlab/MTIS.zip
%           Original function name "ScorJtMove.m"
%       
%   (c) C. Wick, J. Esposito, K. Knowles, & M. Kutzer, 10Aug2015, USNA

% Updates
%   25Aug2015 - Updated correct help documentation, "J. Esposito K. 
%               Knowles," to "J. Esposito, & K. Knowles,"
%               Erik Hoss
%   25Sep2015 - Updated to account for BSEPR(1) = +/-pi issue of returning
%               successful move when no move occurs.

%% Check inputs 
narginchk(1,3);

mType = 'LinearJoint'; 
nInputs = nargin;
if nInputs >= 3
    if strcmpi('movetype',varargin{end-1})
        mType = varargin{end};
        nInputs = nInputs - 2;
    else
        error('Unexpected property name.');
    end
end
if nInputs == 1
    BSEPR = varargin{1};
end

%% Check for known joint 1 issue
if abs(BSEPR(1)) >= pi
    % Force code 908
    errStruct = ScorParseErrorCode(908);
    ScorDispError(errStruct);
    confirm = false;
    return
end
%% Check for elbow-down condition
if BSEPR(3) > 0
    warning('This ScorBot library does not support movements resulting in an "elbow down" configuration.');
    confirm = false;
    return
end

%% Convert BSEPR to XYZPR
% NOTE: This library is currently unable to access direct control over
% joint angles due to a possible discrepancy in the available ScorBot 
% documentation. As a result, BSEPR angles must be converted to task
% variables, and a task-variable move is executed.
XYZPR = ScorBSEPR2XYZPR(BSEPR);
confirm = ScorSetXYZPR(XYZPR,'MoveType',mType);