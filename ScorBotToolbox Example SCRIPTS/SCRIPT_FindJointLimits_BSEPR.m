% Set standard initial configuration
initBSEPR(1,:) = [0,pi/2,-pi/2,-pi/2,0]; % Joint 1 initial condition
initBSEPR(2,:) = [0,pi/2,-pi/2,-pi/2,0]; % Joint 2 initial condition
initBSEPR(3,:) = [0,pi/2,-pi/2,0,0];     % Joint 3 initial condition
initBSEPR(4,:) = [0,pi/2,-pi/2,-pi/2,0]; % Joint 4 initial condition
initBSEPR(5,:) = [0,pi/2,-pi/2,0,0];     % Joint 5 initial condition
% Define initial guess for joint limits
guessLimits = ...
    [-pi,  -pi/2,-pi,-pi,-2*pi;... % Negative joint limit guesses
      pi, 3*pi/4, pi, pi, 2*pi]';  % Positive joint limit guesses
% Define very small delta theta
deltaTheta = deg2rad(1);
% Set speed to 100%
ScorSetSpeed(100);

tic;
% Explore limits for joints 1:4
for i = 1:4
    for j = 1:2
        % Initialize Position
        ScorSetBSEPR(initBSEPR(i,:));
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
        % Set arm to best guess
        BSEPR = initBSEPR(i,:);
        BSEPR(i) = guessLimits(i,j);
        isMove = false; % Flag track is ScorBot executes move
        while ~isMove   % Run while loop until ScorBot moves
            % Display current status
            fprintf('Trying BSEPR = [%.3f, %.3f, %.3f, %.3f, %.3f]\n',BSEPR);
            isMove = ScorSetBSEPR(BSEPR); % Try to move
            if isMove
                % If move is successful, wait for move
                [~] = ScorWaitForMove;
                pause(2); % this extra pause is important for getting good data
            else
                % If move fails, reduce limit
                BSEPR = BSEPR - dBSEPR;
            end
        end
        % Save joint limits
        BSEPR_now = ScorGetBSEPR;
        if ~isempty(BSEPR_now)
            disp(BSEPR_now(i));
            BSEPR_lims(i,j) = BSEPR_now(i);
        end
    end
end
toc