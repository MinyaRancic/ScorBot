classdef ScorBot6Axis < matlab.mixin.SetGet
    %ScorBot6Axis Summary of this class goes here
    %   Detailed explanation goes here
    
    
    properties
        SimSerial
        RWSerial
    end

    methods (Access = 'public')
        function obj = ScorBot6Axis(COM1, COM2)
            obj.SimSerial = COM1;
            obj.RWSerial = COM2;
        end
        
        function ser = Scor6AxisCreateSerial(obj)
            ser = Scor6AxisInit(obj.RWSerial);
        end
        
        function Scor6AxisCreateSim(obj)
            global COM;
            COM = obj.SimSerial;
            !matlab -r eval('assignin('base', 'COM', obj.SimSerial); Scor6AxisSim(COM);') &
        end
    end
    
    methods
        function Scor6AxisSetPosition(ser, dt, values)
            Scor6AxisWritePosition(ser, dt, values);
        end
        
        function Scor6AxisSetVelocity(ser, dt, values)
            Scor6AxisWriteVelocity(ser, dt, values);
        end
        
        function Scor6AxisGetInfo(ser)
            info.Time = Scor6AxisGetRecentTime(ser);
            info.Position = Scor6AxisGetRecentPosition(ser);
            info.Velocity = Scor6AxisGetRecentVelocity(ser);
            info.State = Scor6AxisGetRecentState(ser);
        end
    end
end