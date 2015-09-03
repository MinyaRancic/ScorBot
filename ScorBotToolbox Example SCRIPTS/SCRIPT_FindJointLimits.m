%SCRIPT_FindJointLimits
% Set standard initial configuration
initBSEPR = [0,pi/2,-pi/2,-pi/2,0];
ScorSetSpeed(100);

% Explore limits for joints 1:4
for i = 1:4
    for j = 1:2
        % Reset Arm
        ScorSetBSEPR(initBSEPR);
        ScorWaitForMove;
        % Set joint-by-joint step and direction
        dBSEPR = zeros(1,5);
        if j == 1
            % Negative Limit
            dBSEPR(i) = -deg2rad(1);
        else
            % Positive Limit
            dBSEPR(i) = deg2rad(1);
        end
        % Step until ScorBot gives an error code
        isStuck = false;
        while ScorSetDeltaBSEPR(dBSEPR)
            [~] = ScorWaitForMove;
        end
        % Save joint limit
        BSEPR = ScorGetBSEPR;
        if ~isempty(BSEPR)
            BSEPRlims(i,j) = BSEPR(i)
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

% Manually set limits on joint 5
BSEPRlims(5,:) = [-2*pi,2*pi];
