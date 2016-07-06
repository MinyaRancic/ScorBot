%classdef ScorSimBot < matlab.mixin.SetGet
classdef ScorSimBot < hgsetget
    properties(GetAccess = 'public', SetAccess = 'public')
        MoveTime
        MoveType
        BSEPR       %Joint angles
        XYZPR       %Task Space
        Pose        %Task Space (SE3)
        Gripper
        Speed
    end
    
    methods(Access = 'public')
        function obj = ScorSimBot
            ScorSimInit;
            ScorSimHome;
            Siminitialize(obj);
        end
        
        function delete(obj)
            ScorSafeShutdown;
            delete(obj);
        end
        
        function Siminitialize(obj)
            obj.MoveTime = ScorSimGetMoveTime;
            obj.MoveType = 'LinearJoint';
            obj.BSEPR = ScorSimGetBSEPR;
            obj.XYZPR = ScorSimGetXYZPR;
            obj.Pose = ScorSimGetPose;
            obj.Gripper = ScorSimSimGetGripper;
            obj.Speed = ScorGetSpeed;
        end
    end
    
    methods
        function BSEPR = get.BSEPR(obj)
            disp('TEST')
            BSEPR = ScorSimGetBSEPR;
        end
        
        function XYZPR = get.XYZPR(obj)
            XYZPR = ScorSimGetXYZPR;
        end
        
        function Pose = get.Pose(obj)
            Pose = ScorSimGetPose;
        end
        
        function Gripper = get.Gripper(obj)
            Gripper = ScorSimGetGripper;
        end
        
        function Speed = get.Speed(obj)
            Speed = ScorSimGetSpeed;
        end
        
        function set.BSEPR(obj, value)
            obj.BSEPR = value;
            ScorSimSetBSEPR(value, 'MoveType', obj.MoveType);
        end
        
        function set.XYZPR(obj, value)
            obj.XYZPR = value;
            ScorSimSetXYZPR(value, 'MoveType', obj.MoveType);
        end
        
        function set.Pose(obj, value)
            obj.Pose = value;
            ScorSimSetPose(value);
        end
        
        function set.Gripper(obj, value)
            obj.Gripper = value;
            ScorSimSetGripper(value);
        end
        
        function set.Speed(obj, value)
            obj.Speed = value;
            ScorSimSetSpeed(value);
        end
        
        function set.MoveTime(obj, value)
            obj.MoveTime = value;
            ScorSimSetMoveTime(value);
        end
        
        function set.MoveType(obj, value)
            switch(value)
                case 'LinearJoint'
                    obj.MoveType = 'LinearJoint';
                case 'LinearTask'
                    obj.MoveType = 'LinearTask';
                otherwise
                    error('Move Type must be LinearTask or LinearJoint');   
            end
        end
        
    end
end