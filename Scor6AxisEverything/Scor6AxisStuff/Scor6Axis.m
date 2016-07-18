classdef Scor6Axis < matlab.mixin.SetGet
% Scor6Axis handle class for establishing communication with Scor6AxisSim
    %   obj = Scor6Axis creates a Scor6Axis object to establish
    %   communication with Scor6AxisSim.
    %
    % Scor6Axis Methods
    %   writePos - Sends array of positions to Scor6AxisSim to move to
    %   writeVel - Sends array of velocities to Scor6AxisSim to move
    %   Set - Sets properties of pos, vel, and dt to use in the writePos
    %   and writeVel functions
    %   Get - Gets mos recent set of data from the Scor6Axis and puts it in
    %   a struct
    %
    % Scor6Axis Properties
    %   dt - Delta time between each data point
    %   pos - Nx6 array of floats for joint positions
    %   vel - Nx6 array of floats for joint velocities
    %   ser - Serial object for communication with Scor6AxisSim
    %
    % Example:  
    %
    %       % Create object
    %           obj = Scor6Axis(COM)
    %       % In another instance of matlab
    %           Scor6AxisSim(COM)
    %
    %
    %   D. Saiontz, M. Kutzer, 15July2016, USNA/SEAP
    
    % --------------------------------------------------------------------
    % General properties
    % --------------------------------------------------------------------
    properties (GetAccess='public', SetAccess='public')
        dt
        pos
        vel
        ser
    end
    
    methods (Access = 'public')
        % -----------------------------------------------------------------
        % Constructor/Destructor
        % -----------------------------------------------------------------
        function obj = Scor6Axis(COM)
            obj.ser = Scor6AxisInit(COM);
            obj.dt = .05;
        end
        
        function delete(obj)
            delete(obj);
            fclose('all');
            delete(instrfindall);
        end
        
        % --------------------------------------------------------------------
        % Send data points to Scor6AxisSim
        % --------------------------------------------------------------------
        function writePos(obj)
            Scor6AxisSetPosition(obj.ser, obj.dt, obj.pos);
        end
        
        function writeVel(obj)
            Scor6AxisSetVelocity(obj.ser, obj.dt, obj.vel);
        end
    end
    
    methods
        % --------------------------------------------------------------------
        % Getters/Setters
        % --------------------------------------------------------------------
        function Scor6AxisSetPos(obj, values)
            obj.pos = values;
        end
        
        function Scor6AxisSetVel(obj, values)
            obj.vel = values;
        end
        
        function Scor6AxisSetDt(obj, value)
            obj.dt = value;
        end
        
        % Most recent data points are put into a struct
        function info = Scor6AxisInfo(obj)
            info = Scor6AxisGetInfo(obj.ser);
        end
    end
end