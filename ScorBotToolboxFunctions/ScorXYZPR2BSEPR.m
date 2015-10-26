function BSEPR = ScorXYZPR2BSEPR(varargin)
% SCORXYZPR2BSEPR converts task variables to joint angles.
%   BSEPR = SCORXYZPR2BSEPR(XYZPR) converts the 5-element task-space vector
%   containing the end-effector x,y,z position, and end-effector pitch and 
%   roll to the 5-element joint-space vector containing joint angles 
%   ordered from the base up in the "elbow-up" configuration.
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
%   H = SCORXYZPR2BSEPR(___,'ElbowUpSolution') returns only the "elbow-up"
%   solution. [Default]
%
%   H = SCORXYZPR2BSEPR(___,'ElbowDownSolution') returns only the 
%   "elbow-down" solution. 
%
%   H = SCORXYZPR2BSEPR(___,'AllSolutions') returns all possible solutions 
%   (packaged in a cell array).
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
%   25Aug2015 - Updated to correct help documentation, "J. Esposito K. 
%               Knowles," to "J. Esposito, & K. Knowles,"
%               Erik Hoss
%   23Oct2015 - Updated to provide clearer solutions to elbow-up, and 
%               elbow-down problem following inverse kinematic solution.

% TODO - check special case configurations
% TODO - account for additional "reach-back" solutions and clarify pitch. 

%% Check inputs
narginchk(1,2);

XYZPR = varargin{1};
if numel(XYZPR) ~= 5
    error('Task vector must containt 5-elements.');
end

%% Calculate BSEPR 
x = XYZPR(1);
y = XYZPR(2);
z = XYZPR(3);
p = XYZPR(4);
r = XYZPR(5);

DHtable = ScorDHtable;
d = DHtable(:,2);
a = DHtable(:,3);

%% Calculate "standard" theta1 solutions
% Eq. 0
theta(1,1:2) = atan2(y,x);

% Eq. 1
x_t = sqrt(x^2 + y^2) - a(1);
% if abs( cos(theta(1,1)) ) > abs( sin(theta(1,1)) )
%     x_t = ( x/cos(theta(1,1)) ) - a(1);
% else
%     x_t = ( y/sin(theta(1,1)) ) - a(1);
% end
y_t = z - d(1);

% Eq. 2
x_b = x_t - d(5)*cos(p);
y_b = y_t - d(5)*sin(p);

% Eq. 3
m = sqrt(x_b^2 + y_b^2);

% Eq. 4
alpha = atan2(y_b,x_b);

% Eq. 5
%TODO - check for singularity issue(s)
beta = acos( (a(2)^2 + m^2 - a(3)^2)/(2*a(2)*m) );
beta = real(beta);

% Eq. 6 (elbow down)
theta(2,1) = wrapToPi(alpha - beta);

% Eq. 6* (elbow up)
theta(2,2) = wrapToPi(alpha + beta);

% Eq. 7
%TODO - check for singularity issue(s)
gamma = acos( (a(2)^2 + a(3)^2 - m^2)/(2*a(2)*a(3)) );
gamma = real(gamma);

% Eq. 8 (elbow down)
theta(3,1) = pi - gamma;

% Eq. 8 (elbow up)
theta(3,2) = gamma - pi;

% Eq. 9 (elbow down)
theta(4,1) = p - theta(2,1) - theta(3,1);

% Eq. 9 (elbow up)
theta(4,2) = p - theta(2,2) - theta(3,2);

% if x_t < 0
%     theta(4,1) = wrapToPi(pi - theta(4,1));
%     theta(4,2) = wrapToPi(pi - theta(4,2));
% end

%% Calculate "reach-back" theta1 solutions
% % Eq. 0
% theta(1,[1:2]+2) = wrapToPi(atan2(y,x) + pi);
% 
% % Eq. 1
% % x_t = sqrt(x^2 + y^2) - a(1);
% if abs( cos(theta(1,1+2)) ) > abs( sin(theta(1,1+2)) )
%     x_t = ( x/cos(theta(1,1+2)) ) - a(1);
% else
%     x_t = ( y/sin(theta(1,1+2)) ) - a(1);
% end
% y_t = z - d(1);
% 
% % Eq. 2
% x_b = x_t - d(5)*cos(p);
% y_b = y_t - d(5)*sin(p);
% 
% % Eq. 3
% m = sqrt(x_b^2 + y_b^2);
% 
% % Eq. 4
% alpha = atan2(y_b,x_b);
% 
% % Eq. 5
% %TODO - check for singularity issue(s)
% beta = acos( (a(2)^2 + m^2 - a(3)^2)/(2*a(2)*m) );
% beta = real(beta);
% 
% % Eq. 6 (elbow down)
% theta(2,1+2) = wrapToPi(alpha - beta);
% 
% % Eq. 6* (elbow up)
% theta(2,2+2) = wrapToPi(alpha + beta);
% 
% % Eq. 7
% %TODO - check for singularity issue(s)
% gamma = acos( (a(2)^2 + a(3)^2 - m^2)/(2*a(2)*a(3)) );
% gamma = real(gamma);
% 
% % Eq. 8 (elbow down)
% theta(3,1+2) = pi - gamma;
% 
% % Eq. 8 (elbow up)
% theta(3,2+2) = gamma - pi;
% 
% % Eq. 9 (elbow down)
% theta(4,1+2) = p - theta(2,1+2) - theta(3,1+2);
% 
% % Eq. 9 (elbow up)
% theta(4,2+2) = p - theta(2,2+2) - theta(3,2+2);
% 
% % if x_t < 0
% %     theta(4,1) = wrapToPi(pi - theta(4,1+2));
% %     theta(4,2) = wrapToPi(pi - theta(4,2+2));
% % end

%% Set theta5
% Eq. 10
theta(5,:) = r;

%% Check solution
for i = 1:size(theta,2)
    X = ScorBSEPR2XYZPR(transpose( theta(:,i) ));
    if norm(XYZPR - X) > 1e-8
        %fprintf('Bad Solution %d\n',i);
        BSEPR = [];
        return
    end
end

%% Package output
if nargin < 2
    % Return elbow-up solution only
    BSEPR = transpose( theta(:,2) ); 
    return
end

switch lower(varargin{2})
    case 'elbowupsolution'
        % Return elbow-up solution only
        BSEPR = transpose( theta(:,2) );
    case 'elbowdownsolution'
        % Return elbow-down solution only
        BSEPR = transpose( theta(:,1) );
    case 'allsolutions'
        % Return elbow-up solution
        BSEPR{1} = transpose( theta(:,2) );
        BSEPR{2} = transpose( theta(:,1) );
        % Return elbow-down solution
        %BSEPR{3} = transpose( theta(:,4) );
        %BSEPR{4} = transpose( theta(:,3) );
    otherwise
        error('Unexpected property value.');
end

return
%% Old methods
%--------------------------------------------------------------------------
% Pose method.
%--------------------------------------------------------------------------
% H = ScorXYZPR2Pose(XYZPR);
% % Return if no solution exists
% if isempty(H)
%     BSEPR = [];
%     return;
% end
% BSEPR = ScorPose2BSEPR(H);
% 
% % BSEPR = [];
% % H = ScorXYZPR2Pose(XYZPR,'AllSolutions');
% % 
% % for i = 1:numel(H)
% %     BSEPRi = ScorPose2BSEPR(H{i});
% %     BSEPR = [BSEPR; BSEPRi];
% % end
% 
% %% Remove roll parameters that do not match
% ZERO = 1e-6;
% idx = find( abs(bsxfun(@minus,BSEPR(:,5),XYZPR(5))) > ZERO );
% BSEPR(idx,:) = [];

%--------------------------------------------------------------------------
% Original method.
%--------------------------------------------------------------------------
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
