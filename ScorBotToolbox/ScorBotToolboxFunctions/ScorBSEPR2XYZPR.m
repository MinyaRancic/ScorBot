function XYZPR = ScorBSEPR2XYZPR(BSEPR)
% SCORBSEPR2XYZPR converts joint angles to task variables.
%   XYZPR = SCORBSEPR2XYZPR(BSEPR) converts the 5-element joint-space 
%   vector containing joint angles ordered from the base up to the 
%   5-element task-space vector containing the end-effector x,y,z 
%   position, and end-effector pitch and roll.
%   orientation.
%       BSEPR - 5-element joint vector in radians
%           BSEPR(1) - base joint angle in radians
%           BSEPR(2) - shoulder joint angle in radians
%           BSEPR(3) - elbow joint angle in radians
%           BSEPR(4) - wrist pitch angle in radians
%           BSEPR(5) - wrist roll angle in radians
%       XYZPR - 5-element vector containing end-effector position and
%       orientation.
%           XYZPR(1) - end-effector x-position in millimeters
%           XYZPR(2) - end-effector y-position in millimeters
%           XYZPR(3) - end-effector z-position in millimeters
%           XYZPR(4) - end-effector wrist pitch in radians
%           XYZPR(5) - end-effector wrist roll in radians
%
%   Note: Wrist pitch angle of BSEPR does not equal the pitch angle of 
%   XYZPR. BSEPR pitch angle is body-fixed while the pitch angle of XYZPR 
%   is calculated relative to the base.
%
%   See also ScorGetBSEPR ScorSetXYZPR ScorDHtable
%
%   References:
%       [1] C. Wick, J. Esposito, & K. Knowles, US Naval Academy, 2010
%           http://www.usna.edu/Users/weapsys/esposito-old/_files/scorbot.matlab/MTIS.zip
%           Original function name "ScorDeg2X.m"
%       
%   (c) M. Kutzer, 10Aug2015, USNA

% Updates
%   25Aug2015 - Updated correct help documentation, "J. Esposito K. 
%               Knowles," to "J. Esposito, & K. Knowles,"
%               Erik Hoss
%   01Sep2015 - Removed commented old method

%% Check inputs
narginchk(1,1);
if numel(BSEPR) ~= 5
    error('Joint angle vector must containt 5-elements.');
end

%% Calculate XYZPR
H = ScorBSEPR2Pose(BSEPR);
XYZPR(1) = H(1,4);
XYZPR(2) = H(2,4);
XYZPR(3) = H(3,4);
XYZPR(4) = wrapToPi( sum(BSEPR(2:4)) );
XYZPR(5) = BSEPR(5);
