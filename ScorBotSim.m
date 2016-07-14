%% ScorBotSim class, runs all Scorbot simulation functions
% D. Saiontz, M. Rancic, M. Kutzer, 8July2016, USNA


classdef ScorBotSim < matlab.mixin.SetGet %%For matlab version 2014b and later
    %classdef ScorBotSim < hgsetget For matlab version 2014a and before
    %% Declaration of properties of ScorBotSim
    % Uses DeltaBSEPR, DeltaXYZPR, and DeltaPose as dummy variables to be
    % able to run ScorSimSetDeltaBSEPR, ScorSimSetDeltaXYZPR, and
    % ScorSimSetDeltaPose
    
    properties(GetAccess = 'public', SetAccess = 'public')
        BSEPR       %Joint angles
        XYZPR       %Task Space
        Pose        %Task Space (SE3)
        Gripper     %Distance that gripper is open in mm, 0-70
        Simulation  %Variable used for most of the functions, can't put
        %         ScorBotSim into function, has to be ScorBotSim.Simulation
        %         property
        DeltaBSEPR  %Dummy variable for ScorSimSetDeltaBSEPR
        DeltaXYZPR  %Dummy variable for ScorSimSetDeltaXYZPR
        DeltaPose   %Dummy variable for ScorSimSetDeltaPose
        PrevSpot    %Saves last place moved to as BSEPR for undo
    end
    
    %% Constructor, Destructor, Initialize variables, Start TeachBSEPR,
    % Start TeachXYZPR, and Undo functions
    
    methods(Access = 'public')
        function obj = ScorBotSim %Constructor
            obj.Simulation = ScorSimInit;
            ScorSimPatch(obj.Simulation);
            obj.Siminitialize;
        end
        
        function delete(obj) %Deletes obj
            delete(obj);
            clear obj;
        end
        
        function Siminitialize(obj) %Initializes properties necessary
            %obj.Simulation = ScorSimInit;
            %obj.MoveType = 'LinearJoint';
            obj.BSEPR = ScorSimGetBSEPR(obj.Simulation);
            obj.XYZPR = ScorSimGetXYZPR(obj.Simulation);
            obj.Pose = ScorSimGetPose(obj.Simulation);
            obj.Gripper = ScorSimGetGripper(obj.Simulation);
            ScorSimGoHome(obj.Simulation);
        end
        
        function TeachBSEPR(obj) %Enables teaching mode with BSEPR
            ScorSimTeachBSEPR(obj.Simulation);
        end
        
        function TeachXYZPR(obj) %Enables teaching mode with XYZPR
            ScorSimTeachXYZPR(obj.Simulation);
        end
        
        function Undo(obj) %Undo most recent movement with BSEPR, XYZPR, or
            %             Pose, will not undo changes to gripper, will only be able to
            %             undo most recent spot
            temp = obj.BSEPR;
            setBSEPR(obj, obj.PrevSpot);
            obj.PrevSpot = temp;
        end
    end
    
    %% All set and get funtions
    
    methods
        function BSEPR = getBSEPR(obj) %Returns BSEPR
            BSEPR = ScorSimGetBSEPR(obj.Simulation);
        end
        
        function XYZPR = getXYZPR(obj) %Returns XYZPR
            XYZPR = ScorSimGetXYZPR(obj.Simulation);
        end
        
        function Pose = getPose(obj) %Returns Pose
            Pose = ScorSimGetPose(obj.Simulation);
        end
        
        function Gripper = getGripper(obj) %Returns Gripper
            Gripper = ScorSimGetGripper(obj.Simulation);
        end
        
        function setBSEPR(obj, value) %Sets BSEPR to value and sets
            %             PrevSpot to most recent BSEPR
            obj.PrevSpot = obj.BSEPR;
            obj.BSEPR = value;
            ScorSimSetBSEPR(obj.Simulation, value);
            obj.XYZPR = ScorBSEPR2XYZPR(obj.BSEPR);
            obj.Pose = ScorBSEPR2Pose(obj.BSEPR);
        end
        
        function setXYZPR(obj, value) %Sets XYZPR to value and sets
            %             PrevSpot to most recent BSEPR
            obj.PrevSpot = ScorXYZPR2BSEPR(obj.XYZPR);
            obj.XYZPR = value;
            ScorSimSetXYZPR(obj.Simulation, value);
            obj.BSEPR = ScorXYZPR2BSEPR(obj.XYZPR);
            obj.Pose = ScorXYZPR2Pose(obj.XYZPR);
        end
        
        function setPose(obj, value) %Sets Pose to value and sets
            %             PrevSpot to most recent BSEPR
            obj.PrevSpot = ScorPose2BSEPR(obj.Pose);
            obj.Pose = value;
            ScorSimSetPose(obj.Simulation, value);
            obj.BSEPR = ScorPose2BSEPR(obj.Pose);
            obj.XYZPR = ScorPose2XYZPR(obj.Pose);
        end
        
        function setGripper(obj, value) %Sets gripper to value
            obj.Gripper = value;
            ScorSimSetGripper(obj.Simulation, value);
        end
        
        function setDeltaBSEPR(obj, value) %Sets
            obj.DeltaBSEPR = value;
            obj.PrevSpot = obj.BSEPR;
            obj.BSEPR = obj.BSEPR - obj.DeltaBSEPR;
            ScorSimSetBSEPR(obj.Simulation, obj.BSEPR);
            obj.XYZPR = ScorBSEPR2XYZPR(obj.BSEPR);
            obj.Pose = ScorBSEPR2Pose(obj.BSEPR);
        end
        
        function setDeltaXYZPR(obj, value)
            obj.PrevSpot = ScorXYZPR2BSEPR(obj.XYZPR);
            obj.DeltaXYZPR = value;
            obj.XYZPR = obj.XYZPR - obj.DeltaXYZPR;
            ScorSimSetXYZPR(obj.Simulation, obj.XYZPR);
            obj.BSEPR = ScorXYZPR2BSEPR(obj.XYZPR);
            obj.Pose = ScorXYZPR2Pose(obj.XYZPR);
        end
        
        function setDeltaPose(obj, value)
            obj.PrevSpot = ScorPose2BSEPR(obj.Pose);
            obj.DeltaPose = value;
            obj.Pose = obj.Pose - obj.DeltaPose;
            ScorSimSetPose(obj.Simulation, obj.Pose);
            obj.BSEPR = ScorPose2BSEPR(obj.Pose);
            obj.XYZPR = ScorPose2XYZPR(obj.Pose);
        end
        
    end
end