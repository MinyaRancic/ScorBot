classdef ScorBotSim < matlab.mixin.SetGet
%classdef ScorBotSim < hgsetget
    properties(GetAccess = 'public', SetAccess = 'public')
        %MoveTime
        %MoveType
        BSEPR       %Joint angles
        XYZPR       %Task Space
        Pose        %Task Space (SE3)
        Gripper
        Speed
        Simulation
        DeltaBSEPR
        DeltaXYZPR
        DeltaPose
        PrevSpot
    end
    
    %Methods left: ScoSimQuitTeachCallback,
    % ScorSimTeaches
    
    methods(Access = 'public')
        function obj = ScorBotSim
            obj.Simulation = ScorSimInit;
            ScorSimPatch(obj.Simulation);
            obj.Siminitialize;
        end
        
        function delete(obj)
            delete(obj);
            clear obj;
        end
        
        function Siminitialize(obj)
            %obj.Simulation = ScorSimInit;
            %obj.MoveType = 'LinearJoint';
            obj.BSEPR = ScorSimGetBSEPR(obj.Simulation);
            obj.XYZPR = ScorSimGetXYZPR(obj.Simulation);
            obj.Pose = ScorSimGetPose(obj.Simulation);
            obj.Gripper = ScorSimGetGripper(obj.Simulation);
            ScorSimGoHome(obj.Simulation);
        end
        
        function TeachBSEPR(obj)
            ScorSimTeachBSEPR(obj.Simulation);
        end
        
        function TeachXYZPR(obj)
            ScorSimTeachXYZPR(obj.Simulation);
        end
        
        function Undo(obj)
            temp = obj.BSEPR;
            setBSEPR(obj, obj.PrevSpot);
            obj.PrevSpot = temp;
        end
    end
    
    methods
        function BSEPR = getBSEPR(obj)
            BSEPR = ScorSimGetBSEPR(obj.Simulation);
        end
        
        function XYZPR = getXYZPR(obj)
            XYZPR = ScorSimGetXYZPR(obj.Simulation);
        end
        
        function Pose = getPose(obj)
            Pose = ScorSimGetPose(obj.Simulation);
        end
        
        function Gripper = getGripper(obj)
            Gripper = ScorSimGetGripper(obj.Simulation);
        end
        
%         function Speed = get.Speed(obj)
%             Speed = ScorSimGetSpeed(obj.Simulation);
%         end
        
        function setBSEPR(obj, value)
            obj.PrevSpot = obj.BSEPR;
            obj.BSEPR = value;
            ScorSimSetBSEPR(obj.Simulation, value);
        end
        
        function setXYZPR(obj, value)
            obj.PrevSpot = ScorXYZPR2BSEPR(obj.XYZPR);
            obj.XYZPR = value;
            ScorSimSetXYZPR(obj.Simulation, value);
        end
        
        function setPose(obj, value)
            obj.PrevSpot = ScorPose2BSEPR(obj.Pose);
            obj.Pose = value;
            ScorSimSetPose(obj.Simulation, value);
        end
        
        function setGripper(obj, value)
            obj.Gripper = value;
            ScorSimSetGripper(obj.Simulation, value);
        end
        
        function setDeltaBSEPR(obj, value)
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
        
%         
%         function set.Speed(obj, value)
%             obj.Speed = value;
%             ScorSimSetSpeed(obj.Simulation, value);
%         end
%         
%         function set.MoveTime(obj, value)
%             obj.MoveTime = value;
%             ScorSimSetMoveTime(value);
%         end
%         
%         function set.MoveType(obj, value)
%             switch(value)
%                 case 'LinearJoint'
%                     obj.MoveType = 'LinearJoint';
%                 case 'LinearTask'
%                     obj.MoveType = 'LinearTask';
%                 otherwise
%                     error('Move Type must be LinearTask or LinearJoint');   
%             end
%         end
        
    end
end