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
global isPos pos isVel vel dt moveArm
%% Initialize callback parameters
isPos = false;
pos = [];
isVel = false; 
vel = [];
dt = 0;
moveArm = false;
idx = 0;

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
t0 = tic;
BSEPR = ScorSimGetBSEPR(sim);
G = ScorSimGetGripper(sim);
T = toc(t0);
tBSEPRG = [T,BSEPR,G];

while true
    try 
        % Get current joint configuration
        drawnow
        BSEPR = ScorSimGetBSEPR(sim);
        G = ScorSimGetGripper(sim);
        % Get current time
        T = toc(t0);
        % Save current time-stamped joint position
        tBSEPRG(2,:) = [T,BSEPR,G];
        % Prepare data for sending
        % P - Axis position (radians)
        P = tBSEPRG(2,2:end);
        % V - Axis velocity (radians/second)
        V = diff(tBSEPRG(:,2:end),1)./diff(tBSEPRG(:,1),1);
        % S - Axis state
        % This is currently being treated as encoder "Steps" but it will be
        % replace by axis *state* which will be represented using a signed
        % integer.
        S = [ScorBSEPR2Cnts(BSEPR),0]; % Note we do not know the gripper steps yet
        % Send data
        % $T_P____V____S____\n
        
        % Create message
        msg = sprintf([...
            '$T%.2f,',...
            'P%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,',...
            'V%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,',...
            'S%d,%d,%d,%d,%d,%d\n'],T,P,V,S);
        
        % Wait for serial to become idle before sending
        while true
            switch s.TransferStatus
                case 'idle'
                    break
            end
        end
        % Display message to command window
        fprintf('%s',msg); 
        % Send message over serial
        fprintf(s,'%s',msg,'async');
        
        % Update tBSEPRG array
        tBSEPRG(1,:) = tBSEPRG(2,:);
        
        % Animate movement (this is imperfect and will be "jerky")
        % TODO - Complete movement estimation
        %{
        if moveArm
            if isPos
                
                % Position Movement
                % Update joint configuration
                ScorSimSetBSEPR(sim,pos(i,1:5)); % <-- need to deal with "i"
                
                %
                ScorSimSetGripper(sim,pos(i,6));
            end
            if isVel
                % Velocity Movement
            end
            for i = 1:size(pos,1)
        %}
    catch
        fprintf(2,'Something happened?!\n');
        fclose(s);
        delete(s);
        break
    end
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
global isPos pos isVel vel dt moveArm

switch event.Type
    case 'BytesAvailable'
        out = fscanf(obj,'%s'); % read data coming in as a string
        if numel(out) >= 9
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
                    [arr,cnt,err,~] = sscanf(out,'%d,%f,%f,%f,%f,%f,%f',[1,8]);
                    if cnt == 7 && isempty(err)
                        % Successfully parsed data
                        if isPos
                            % Append position data
                            pos = [pos; arr];
                            fprintf('POS:%d,%f,%f,%f,%f,%f,%f\n',arr);
                        end
                        if isVel
                            % Append velocity data
                            vel = [vel; arr];
                            fprintf('VEL:%d,%f,%f,%f,%f,%f,%f\n',arr);
                        end
                    else
                        beep
                        fprintf(2,'Unexpected data format')
                    end
            end
        else
            switch out
                case '**'
                    % End of transmission
                    % TODO - Complete movement estimation
                    %{
                    moveArm = true;
                    if isPos
                        % Define time
                        t = dt*pos(:,1); % Define time
                        t = [0; t]; % Accound for zero
                        % Define configurations
                        BSEPRG = ScorSimGetBSEPR(sim);
                        BSEPRG(6) = ScorSimGetGripper(sim);
                        BSEPRG = [BSEPRG; pos(:,2:end)];
                    %}
                    fprintf('TRM:%s\n',out);
                otherwise
                    beep
                    fprintf(2,'Unexpected data format')
            end
        end
    otherwise
        error('Unexpected event.');
end

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