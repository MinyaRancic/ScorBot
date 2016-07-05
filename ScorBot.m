classdef ScorBot
    properties(GetAccess = 'public', SetAccess = 'public')
<<<<<<< HEAD
        BSEPR = ScorGetBSEPR;       %Joint angles
        XYZPR = ScorGetXYZPR;       %Task Space
        Pose = ScorGetPose;        %Task Space (SE3)
        Gripper = ScorGetGripper;
        Speed = ScorGetSpeed;
=======
        BSEPR       %Joint angles
        XYZPR       %Task Space
        Pose        %Task Space (SE3)
        Gripper
        Speed
>>>>>>> origin/master
    end
    methods(Access = 'public')
        function obj = ScorBot
            obj = ScorInit;
            ScorHome;
        end
        
        function delete(obj)
            ScorSafeShutdown;
        end            
    end
    
    %methods
       % function BSEPR = get.BSEPR(obj)
        %    BSEPR = ScorGetBSEPR(obj);
    %    end
    
    methods
        function get(obj, 'BSEPR')
            BSEPR = ScorGetBSEPR;
        end
end
