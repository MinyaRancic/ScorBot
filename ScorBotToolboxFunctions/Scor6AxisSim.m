function Scor6AxisSim(COM)
% SCOR6AXSISIM simulates the ScorBot 6-Axis controller via a designated
% serial connection
%   SCOR6AXSISIM(COM) initializes the simulation on a designated com port
%
%   Example:
%       % Initialize a ScorBot 6-Axis controller simulation on COM5
%       Scor6AxisSim('COM5');
%
%   (c) M. Kutzer, 07July2016, USNA

%% Set simulation struct as global for callback
global sim

%% Set callback parameters as global for simulated data
global ppPos ppVel dt t_start t_final moveArm isPos pos isVel vel
moveArm = false;
isPos = false;
isVel = false;
pos = [];
vel = [];

dt = 0;
t_start = 0;
t_final = 0;
t_arm = 0;

%% Check inputs
narginchk(1,1);
if ~ischar(COM)
    error('COM port must be designated as a string argument.');
end
if ~strcmp(COM(1:3),'COM');
    error('COM port must be specified as ''COM*'' (e.g. ''COM5'').');
end

%% Check if requested serial port already exists
inst = instrfind('Port',COM);
if isempty(inst)
    % Create new serial object if port is free
    s = serial(COM);
else
    % Use existing object if port is already declared
    s = inst;
    fclose(s); % close the existing connection (to reopen later)
end

%% Initialize serial connection
set(s,'BaudRate',115200);
set(s,'DataBits',8);
set(s,'Parity','even');
set(s,'StopBits',1);
set(s,'Terminator','LF');
set(s,'BytesAvailableFcnMode','Terminator');
set(s,'BytesAvailableFcn',@scorSerReadCallback);
fopen(s);

%% Initialize simulation
sim = ScorSimInit;
ScorSimPatch(sim);

%% Initialize start time
% Initialize timer
t0 = tic;
% Get initial configuration
pBSEPRG = [ScorSimGetBSEPR(sim), ScorSimGetGripper(sim)];
vBSEPRG = zeros(1,6);
while true
    %try 
        % Get current time
        T = toc(t0);
        % Prepare data for sending
        % P - Axis position (radians)
        P = pBSEPRG;
        % V - Axis velocity (radians/second)
        V = vBSEPRG;
        % S - Axis state
        % This is currently being treated as encoder "Steps" but it will be
        % replace by axis *state* which will be represented using a signed
        % integer.
        S = [ScorBSEPR2Cnts(pBSEPRG(1:5)),0]; % Note we do not know the gripper steps yet
        % Send data
        % $T_P____V____S____\n
        
        % Create message
        msg = sprintf([...
            '$T%.2f',...
            'P%.4f,%.4f,%.4f,%.4f,%.4f,%.4f',...
            'V%.4f,%.4f,%.4f,%.4f,%.4f,%.4f',...
            'S%d,%d,%d,%d,%d,%d\n'],T,P,V,S);
        
        % Wait for serial to become idle before sending
        while true
            switch s.TransferStatus
                case 'idle'
                    break
            end
        end
        % Display message to command window
        %fprintf('%s',msg); 
        % Send message over serial
        fprintf(s,'%s',msg,'async');
        
        % Animate movement (this is imperfect and will be "jerky")
        if moveArm
            if t_arm == 0
                tt0 = tic;
            end
            t_arm = toc(tt0);
            if t_final >= t_arm
                for i = 1:6
                    pBSEPRG(i) = ppval(ppPos{i},t_arm);
                    vBSEPRG(i) = ppval(ppVel{i},t_arm);
                end
                ScorSimSetBSEPR(sim,pBSEPRG(1:5));
                ScorSimSetGripper(sim,wrapGrip(pBSEPRG(6)));
                drawnow
            else
                t_arm = 0;
                moveArm = false;
                vBSEPRG = zeros(6,1);
            end
        end
    %catch
    %    fprintf(2,'Something happened?!\n');
    %    fclose(s);
    %    delete(s);
    %    break
    %end
end

end

% /////////////////////////////////////////////////////////////////////////
% Included functions
% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%% Serial callback function
function scorSerReadCallback(obj,event)
%Simple callback function to read data sent to the 6-Axis Controller and 
%   the simulation environment
%   obj - serial object associate with callback function call
%   event - structured array containing event information
%       event.Type - type of event associated with assigned callback
%           'BytesAvailable'
%           'OutputEmpty'
%           'BreakInterrupt'
%       event.Data.AbsTime - absolute time array, can be used with
%           datestr.m

% Basic command set
%   Position Commands
%       '!PosCMDdt%f\n' - declares a position command with a dt (seconds)
%       '%d,%f,%f,%f,%f,%f,%f\n' - specifies:
%           %d - index value (e.g. 1, 2, 3, ...)
%           %f - joint angle (radians)
%       '**\n' - end of transmission
%
%   Velocity Commands
%       '!VelCMDdt%f\n' - declares a velocity command with a dt (seconds)
%       '%d,%f,%f,%f,%f,%f,%f\n' - specifies:
%           %d - index value (e.g. 1, 2, 3, ...)
%           %f - joint velocity (radians/second)
%       '**\n' - end of transmission


% Set simulation struct as global for callback
global sim
% Set callback parameters as global for simulated data
global ppPos ppVel dt t_start t_final moveArm isPos pos isVel vel

%try
switch event.Type
    case 'BytesAvailable'
        out = fscanf(obj,'%s'); % read data coming in as a string
        if numel(out) >= 10
            switch out(1:9)
                case '!PosCMDdt'
                    % Position command started
                    dt = str2double(out(10:end));
                    isPos = true;
                    isVel = false;
                    fprintf('Position command initiated:\n');
                    fprintf('\t"%s" | dt=%.2f\n',out,dt);
                case '!VelCMDdt'
                    % Velocity command started
                    dt = str2double(out(10:end));
                    isPos = false;
                    isVel = true;
                    fprintf('Velocity command initiated:\n');
                    fprintf('\t"%s" | dt=%.2f\n',out,dt);
                otherwise
                    % Assume the received message is data
                    [arr,cnt,err,~] = sscanf(out,'%d,%f,%f,%f,%f,%f,%f',[1,7]);
                    if cnt == 7 && isempty(err)
                        % Successfully parsed data
                        if isPos
                            % Append position data
                            pos = [pos; arr];
                            % Print received data to command window
                            fprintf('POS:%d,%f,%f,%f,%f,%f,%f\n',arr);
                        end
                        if isVel
                            % Append velocity data
                            vel = [vel; arr];
                            % Print received data to command window
                            fprintf('VEL:%d,%f,%f,%f,%f,%f,%f\n',arr);
                        end
                    else
                        beep
                        fprintf(2,'Unexpected data format\n')
                    end
            end
        else
            switch out
                case '**'
                    % End of transmission
                    fprintf('TRM:%s\n',out);
                    % Process position trajectory
                    if isPos
                        % Define time
                        t = dt*pos(:,1); % Define time using index and dt
                        t = [0; t];      % Account for zero time
                        % Define configurations
                        BSEPRG = ScorSimGetBSEPR(sim);      % joint configuration at time 0
                        BSEPRG(6) = ScorSimGetGripper(sim); % gripper configuration at time 0
                        BSEPRG = [BSEPRG; pos(:,2:end)];    % append trajectory
                        % Fit piecewise polynomial
                        conds = [0,0]; % Constrain first derivative
                        x = t';
                        %size(x)
                        for i = 1:6
                            y = [0; BSEPRG(:,i); 0]'; % Add end-constraints
                            %size(y)
                            ppPos{i} = csape(x,y,conds); % Position
                            ppVel{i} = dspline(ppPos{i});  % Velocity
                        end
                        % Define start and end times 
                        t_start = t(1);
                        t_final = t(end);
                        % Update profile flags
                        isPos = false;
                        isVel = false;
                        % Empty profile data
                        pos = [];
                        vel = [];
                        % Flag move
                        moveArm = true;
                    end
                    % Process velocity trajectory
                    if isVel
                        % Define time
                        t = dt*vel(:,1); % Define time using index and dt
                        t = [0; t];      % Accound for zero time
                        % Get starting configuration
                        BSEPRG0 = ScorSimGetBSEPR(sim);      % joint configuration at time 0
                        BSEPRG0(6) = ScorSimGetGripper(sim); % gripper configuration at time 0
                        % Define velocities
                        BSEPRG = zeros(1,6);    % Assume start at 0 velocity
                        BSEPRG = [BSEPRG; vel(:,2:end)];
                        % Fit piecewise polynomial
                        conds = [0,0]; % Constrain first derivative
                        x = t';
                        %size(x)
                        for i = 1:6
                            y = [0; BSEPRG(:,i); 0]'; % Add end-constraints
                            %size(y)
                            ppVel{i} = csape(x,y,conds); % Position
                            ppPos{i} = ispline(ppVel{i},BSEPRG0(i));  % Velocity
                        end
                        % Define start and end times 
                        t_start = t(1);
                        t_final = t(end);
                        % Update flags
                        isPos = false;
                        isVel = false;
                        % Empty profile data
                        pos = [];
                        vel = [];
                        % Flag move
                        moveArm = true;
                    end
                otherwise
                    beep
                    fprintf(2,'Unexpected data format\n')
            end
        end
    otherwise
        error('Unexpected event.');
end
%catch ME
%    disp(ME)
%end

end

%% Gripper wrap function
function grip = wrapGrip(grip)
% Account for gripper misuse
if grip < 0
    grip = 0;
end
if grip > 70
    grip = 70;
end

end

%% Conversion function
function cnts=ScorBSEPR2Cnts(BSEPR)
% SCORBSEPR2CNTS converts BSEPR angles to motor encoder counts
% cnts=ScorDeg2Cnts(BSEPR) converts relative BSEPR joint values to encoder
% counts.
%   cts - 1x5 vector of joint motor encoder counts
%   theta - 1x5 vector of relative D-H joint angles in degrees
%
%	Wick & Esposito & Knowles, US Naval Academy, 2010

% Updates
%   07July2016 - Updated documentation and made function match Scor*
%   standard.

% Define constants
kb   = -141.8888;
kse  = -113.5111;
offs =  120.27;
offe = -25.24;
kw   = -27.9;
offw =  63.57;

% Convert angles to degrees (per Wick/Esposito/Knowles)
theta = rad2deg(BSEPR);

% Convert to counts
cnts(1,1) = kb*theta(1);
cnts(1,2) = kse*(offs+theta(2));
cnts(1,3) = kse*(offe-theta(2)-theta(3));
cnts(1,4) = kw*(offw-theta(2)-theta(3)-theta(4)-theta(5));
cnts(1,5) = kw*(theta(2)+theta(3)+theta(4)-theta(5)-offw);

% Round encoder counts (because that they can only be integers)
cnts = round(cnts);
end