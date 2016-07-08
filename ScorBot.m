%% ScorBot Class, runs all ScorBot functions
% M Rancic, 8July2016

%classdef ScorBot < matlab.mixin.SetGet For matlab 2014b and later
classdef ScorBot < hgsetget % For matlab 2014a and earlier
    
    %% Declaration of properties of ScorBot
    % dBSEPR, dXYZPR, and dPose are used as dummy variables for
    % ScorSetDeltaBSEPR, ScorSetDeltaXYZPR, and ScorSetDeltaPose
    
    properties(GetAccess = 'public', SetAccess = 'public')
        MoveTime %Time it will take to move Scorbot from one place to another
        MoveType
        BSEPR %Joint angles
        dBSEPR %Dummy variable for ScorSetDeltaBSEPR
%         prevBSEPR
        XYZPR %Task Space
        dXYZPR %Dummy variable for ScorSetDeltaXYZPR
        Pose  %Task Space (SE3)
        dPose %Dummy variable fro ScorSetDeltaPose
        Gripper %Distance that gripper is open in mm, 0-70
        Speed %Speed that ScorBot will move when moving, will make MoveTime
        % empty when setting speed
        Control %Current control state of ScorBot
        IsMoving %Whether ScorBot is moving or not
        PendantMode %State of Pendant Mode, either Auto or Teach
        IsReady %Whether or not ScorBot is ready for another command
        GripperOffset %
    end
    
    %% Declares prevBSEPR for undo function

    properties(GetAccess = 'public', SetAccess = 'private')
        prevBSEPR %Last waypoint, in BSEPR, of ScorBot
    end
    
    %% Constructor, Destructor, and initialize properties functions

    methods(Access = 'public')
        function obj = ScorBot
            ScorInit;
            ScorHome;
            initialize(obj);
        end
        
        function delete(obj)
            ScorSafeShutdown;
            delete(obj);
        end
        
        function initialize(obj)
            obj.MoveTime = ScorGetMoveTime;
            obj.MoveType = 'LinearJoint';
            obj.BSEPR = ScorGetBSEPR;
            obj.XYZPR = ScorGetXYZPR;
            obj.Pose = ScorGetPose;
            obj.Gripper = ScorGetGripper;
            obj.Speed = ScorGetSpeed;
        end
    end
    
    %% All get and set methods

    methods
        function BSEPR = get.BSEPR(obj)
            disp('TEST')
            BSEPR = ScorGetBSEPR;
        end
        
        function XYZPR = get.XYZPR(obj)
            XYZPR = ScorGetXYZPR;
        end
        
        function Pose = get.Pose(obj)
            Pose = ScorGetPose;
        end
        
        function Gripper = get.Gripper(obj)
            Gripper = ScorGetGripper;
        end

        function Speed = get.Speed(obj)
            Speed = ScorGetSpeed;
        end
        
        function IsMoving = get.IsMoving(obj)
            IsMoving = ScorIsMoving;
        end
        
        function Control = get.Control(obj)
            Control = ScorGetControl;
        end
        
        function PendantMode = get.PendantMode(obj)
            PendantMode = ScorGetPendantMode;
        end
        
        function IsReady = get.IsReady(obj)
            IsReady = ScorIsReady;
        end
        
        function GripperOffset = get.GripperOffset(obj)
            GripperOffset = scorGetGripperOffset;
        end
        %% all the setter methods

        function obj = set.BSEPR(obj, value)
            obj.BSEPR = value;
            ScorSetBSEPR(value, 'MoveType', obj.MoveType);
        end
        
        function obj = set.XYZPR(obj, value)
            obj.XYZPR = value;
            ScorSetXYZPR(value, 'MoveType', obj.MoveType);
        end
        
        function obj = set.Pose(obj, value)
            obj.Pose = value;
            ScorSetPose(value);
        end
        
        function obj = set.Gripper(obj, value)
            obj.Gripper = value;
            ScorSetGripper(value);
        end
        
        function obj = set.Speed(obj, value)
            obj.Speed = value;
            ScorSetSpeed(value);
        end
        
        function obj = set.MoveTime(obj, value)
            obj.MoveTime = value;
            ScorSetMoveTime(value);
        end
        
        function obj = set.MoveType(obj, value)
            switch(lower(value))
                case 'linearjoint'
                    obj.MoveType = 'LinearJoint';
                case 'lineartask'
                    obj.MoveType = 'LinearTask';
                otherwise
                    error('Move Type must be LinearTask or LinearJoint');   
            end
        end
        
        function obj = set.dBSEPR(obj, value)
            ScorSetDeltaBSEPR(value);
            obj.dBSEPR = value;
            obj.BSEPR = ScorGetBSEPR;    
        end
        
        function obj = set.dXYZPR(obj, value)
            ScorSetDeltaXYZPR(value);
            obj.dXYZPR = value;
            obj.XYZPR = ScorGetXYZPR;    
        end
        
        function obj = set.dPose(obj, value)
            ScorSetDeltaPose(value);
            obj.dPose = value;
            obj.Pose = ScorGetPose;    
        end
        
        function obj = set.Control(obj, value)
            switch(lower(value))
                case 'on'
                    obj.Control = value;
                    ScorSetControl(value);
                case 'off'
                    obj.Control = 'Off';
                    ScorSetControl('Off');
                otherwise
                    error('Control must be on or off');
            end
        end
        
        function obj = set.PendantMode(obj, value)
            switch(lower(value))
                case('auto')
                    obj.PendantMode = 'Auto';
                    ScorSetPedantMode('Auto');
                case('teach')
                    obj.PendantMode = 'teach';
                    ScorSetPendantMode('teach');
                otherwise
                    error('PendantMode must be Auto or Teach');
            end
        end
        
%% action commands

        function goHome(obj)
            ScorGoHome;
        end
        
        function undo(obj)
            ScorSetBSEPR(obj.prevBSEPR);
            obj.prevBSEPR = obj.BSEPR;
            obj.BSEPR = ScorGetBSEPR;
        end
        
        function waitForMove(varargin)
            ScorWaitForMove(varargin);
        end
        
        function createVector(vName, n)
            ScorCreateVector(vName, n);
        end
        

        function setPoint(varargin)
            ScorSetPoint(varargin)
        end
        
        function gotoPoint(varargin)
            ScorGoroPoint(varargin)
        end
        
        function sendBSEPR(udpS, BSEPR)
            ScorSendBSEPR(udpS);
        end
        
        function recieveBSEPR(udpR, BSEPR)
            obj.BSEPR = ScorRecieveBSEPR(udpR, BSEPR);
        end
        
        
        function sendXYZPR(udpS, XYZPR)
            ScorSendXYZPR(udpS, ScorGetXYZPR);
        end
        
        function recieveXYZPR(udpR, XYZPR)
            obj.XYZPR = ScorRecieveXYZPR(udpR);
        end
        
        
        function sendPose(udpS, Pose)
            ScorSendPose(udpS, ScorGetPose);
        end
        
        function recievePose(udpR, Pose)
            obj.Pose = ScorRecievePose(udpR);
            ScorSendBSEPR(udpS, BSEPR);
        end
        
        function recieveBSEPR(udpR, BSEPR)
            ScorRecieveBSEPR(udpR, BSEPR);
        end
    end
end