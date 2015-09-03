function BSEPR = ScorXYZPR2BSEPR(XYZPR)
% SCORXYZPR2BSEPR converts task variables to joint angles.
%   BSEPR = SCORXYZPR2BSEPR(XYZPR) converts the 5-element task-space vector
%   containing the end-effector x,y,z position, and end-effector pitch and 
%   roll to the 5-element joint-space vector containing joint angles 
%   ordered from the base up.
%       XYZPR - 5-element vector containing end-effector position and
%       orientation.
%           XYZPR(1) - end-effector x-position in millimeters
%           XYZPR(2) - end-effector y-position in millimeters
%           XYZPR(3) - end-effector z-position in millimeters
%           XYZPR(4) - end-effector wrist pitch in radians
%           XYZPR(5) - end-effector wrist roll in radians
%       BSEPR - 5-element joint vector in radians
%           BSEPR(1) - base joint angle in radians
%           BSEPR(2) - shoulder joint angle in radians
%           BSEPR(3) - elbow joint angle in radians
%           BSEPR(4) - wrist pitch angle in radians
%           BSEPR(5) - wrist roll angle in radians
%
%   NOTE: An empty set is returned if no reachable solution exists.
%
%   Note: Wrist pitch angle of BSEPR does not equal the pitch angle of 
%   XYZPR. BSEPR pitch angle is body-fixed while the pitch angle of XYZPR 
%   is calculated relative to the base.
%
%   See also ScorGetBSEPR ScorSetXYZPR
%
%   References:
%       [1] C. Wick, J. Esposito, & K. Knowles, US Naval Academy, 2010
%           http://www.usna.edu/Users/weapsys/esposito-old/_files/scorbot.matlab/MTIS.zip
%           Original function name "ScorX2Deg.m"
%       
%   (c) C. Wick, J. Esposito, K. Knowles, & M. Kutzer, 10Aug2015, USNA

% Updates
%   25Aug2015 - Updated correct help documentation, "J. Esposito K. 
%               Knowles," to "J. Esposito, & K. Knowles,"
%               Erik Hoss

%% Check inputs
narginchk(1,1);
if numel(XYZPR) ~= 5
    error('Task vector must containt 5-elements.');
end

H = ScorXYZPR2Pose(XYZPR);
% Return if no solution exists
if isempty(H)
    BSEPR = [];
    return;
end
BSEPR = ScorPose2BSEPR(H);

% BSEPR = [];
% H = ScorXYZPR2Pose(XYZPR,'AllSolutions');
% 
% for i = 1:numel(H)
%     BSEPRi = ScorPose2BSEPR(H{i});
%     BSEPR = [BSEPR; BSEPRi];
% end

%% Remove roll parameters that do not match
ZERO = 1e-6;
idx = find( abs(bsxfun(@minus,BSEPR(:,5),XYZPR(5))) > ZERO );
BSEPR(idx,:) = [];

return
% %% Get rigid geometry terms from DHtable
% DHtable = ScorDHtable;
% d = DHtable(:,2);
% a = DHtable(:,3);
% 
% %% Calculate task vector
% BSEPR = zeros(1,5);
% % base joint angle in radians
% BSEPR(1) = atan2(XYZPR(2), XYZPR(1));
% % wrist roll angle in radians
% BSEPR(5) = XYZPR(5);
% % radius in xy-plane
% r = sqrt( (XYZPR(1)^2)+(XYZPR(2)^2) )-a(1)-d(5)*cos(XYZPR(4));
% %
% h = XYZPR(3)-d(1)-d(5)*sin(XYZPR(4));
% %
% gamma = atan2(h,r);
% %
% b = sqrt(h^2+r^2);
% %
% alpha = atan2(sqrt( 4*(a(2)^2)-(b^2) ),b);
% % shoulder joint angle in radians
% BSEPR(2) = alpha+gamma;
% % elbow joint angle in radians
% BSEPR(3) = -2*alpha;
% % wrist pitch in radians
% BSEPR(4) = XYZPR(4)-BSEPR(2)-BSEPR(3);
