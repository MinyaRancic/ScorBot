classdef ScorBot
    properties(GetAccess = 'public', SetAccess = 'public')
        BSEPR       %Joint angles
        XYZPR       %Task Space
        Pose        %Task Space (SE3)
        Gripper
        Speed
    end
    methods(Access = 'public')
        function obj = ScorBot
            ScorInit;
            ScorHome;
        end
        function delete obj
            ScorSafeShutdown;
        end
    end
    methods
        function get(obj, 'BSEPR')
            BSEPR = ScorGetBSEPR;
        end
end
