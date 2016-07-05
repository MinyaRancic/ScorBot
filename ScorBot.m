classdef ScorBot
    properties(GetAccess = 'public', SetAccess = 'public')
        BSEPR       %Joint angles
        XYZPR       %Task Space
        Pose        %Task Space (SE3)
        Gripper
        Speed
    methods(Access = 'public')
        function obj = ScorBot
            ScorInit;
            ScorHome;
        end
      
    methods(Access = 'public')
        function delete obj
            ScorSafeShutdown;
        end
          
end
