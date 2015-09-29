%SCRIPT_FindJointLimits
% Set standard initial configuration
initBSEPR = [0,pi/2,-pi/2,-pi/2,0];
% Define initial guess for joint limits (to save time)
guessLimits = ...
    [-2*pi/3,    0,-2*pi/3,-3*pi/5,-2*pi;...
      2*pi/3, pi/2,  -pi/6, 3*pi/5, 2*pi]';
% Define very small delta theta
deltaTheta = deg2rad(1);
% Set speed to 100%
ScorSetSpeed(100);

tic;
% Explore limits for joints 1:4
for i = 1:4
    for j = 1:2
        % Set arm to best guess
        BSEPR = initBSEPR;
        BSEPR(i,j) = guessLimits(i,j); 
        ScorSetBSEPR(BSEPR);
        ScorWaitForMove;
        % Set joint-by-joint step and direction
        dBSEPR = zeros(1,5);
        if j == 1
            % Negative Limit
            dBSEPR(i) = -deltaTheta;
        else
            % Positive Limit
            dBSEPR(i) = deltaTheta;
        end
        % Step until ScorBot gives an error code
        while ScorSetDeltaBSEPR(dBSEPR)
            [~] = ScorWaitForMove;
        end
        disp('DONE')
        pause
        % Save joint limit
        limBSEPR = ScorGetBSEPR;
        if ~isempty(limBSEPR)
            BSEPRlims(i,j) = limBSEPR(i)
        end
        % Attempt to recover from the error
        if ~ScorIsReady
            isHome = ScorGoHome;
            if ~isHome
                ScorHome;
            end
        end
    end
    
end
toc 

% Manually set limits on joint 5
BSEPRlims(5,:) = [-2*pi,2*pi];
