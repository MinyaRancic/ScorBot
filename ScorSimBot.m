classdef ScorSimBot < matlab.mixin.SetGet
%classdef ScorSimBot < hgsetget
    properties(GetAccess = 'public', SetAccess = 'public')
        %MoveTime
        %MoveType
        BSEPR       %Joint angles
        XYZPR       %Task Space
        Pose        %Task Space (SE3)
        Gripper
        Speed
        Simulation
    end
    
    methods(Access = 'public')
        function obj = ScorSimBot
            obj.Simulation = ScorSimInit;
            ScorSimPatch(obj.Simulation);
            obj.Siminitialize;
        end
        
        function delete(obj)
            ScorSafeShutdown;
            delete(obj);
        end
        
        function Siminitialize(obj)
            %obj.Simulation = ScorSimInit;
            %obj.MoveType = 'LinearJoint';
            obj.BSEPR = ScorSimGetBSEPR(obj.Simulation);
            obj.XYZPR = ScorSimGetXYZPR(obj.Simulation);
            obj.Pose = ScorSimGetPose(obj.Simulation);
            obj.Gripper = ScorSimGetGripper(obj.Simulation);
        end
    end
    
    methods
        function BSEPR = get.BSEPR(obj)
            BSEPR = ScorSimGetBSEPR(obj.Simulation);
        end
        
        function XYZPR = get.XYZPR(obj)
            XYZPR = ScorSimGetXYZPR(obj.Simulation);
        end
        
        function Pose = get.Pose(obj)
            Pose = ScorSimGetPose(obj.Simulation);
        end
        
        function Gripper = get.Gripper(obj)
            Gripper = ScorSimGetGripper(obj.Simulation);
        end
        
%         function Speed = get.Speed(obj)
%             Speed = ScorSimGetSpeed(obj.Simulation);
%         end
        
        function set.BSEPR(obj, value)
            obj.BSEPR = value;
            ScorSimSetBSEPR(obj.Simulation, value);
        end
        
        function set.XYZPR(obj, value)
            obj.XYZPR = value;
            ScorSimSetXYZPR(obj.Simulation, value);
        end
        
        function set.Pose(obj, value)
            obj.Pose = value;
            ScorSimSetPose(obj.Simulation, value);
        end
        
        function set.Gripper(obj, value)
            obj.Gripper = value;
            ScorSimSetGripper(obj.Simulation, value);
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