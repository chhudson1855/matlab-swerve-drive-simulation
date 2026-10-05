classdef RollingBuffer < handle
    %ROLLINGBUFFER Fixed-capacity window holding the most recent scalar values.
    %   buf = swerve.util.RollingBuffer(5);
    %   buf.push(3.2);
    %   buf.mean()

    properties (SetAccess = private)
        Capacity (1,1) double {mustBePositive, mustBeInteger} = 1
        Count    (1,1) double = 0
    end

    properties (Access = private)
        Data (1,:) double = 0
        Head (1,1) double = 0     % index of the newest value
    end

    methods
        function obj = RollingBuffer(capacity)
            arguments
                capacity (1,1) double {mustBePositive, mustBeInteger}
            end
            obj.Capacity = capacity;
            obj.Data = zeros(1, capacity);
        end

        function push(obj, value)
            arguments
                obj
                value (1,1) double
            end
            obj.Head = mod(obj.Head, obj.Capacity) + 1;
            obj.Data(obj.Head) = value;
            obj.Count = min(obj.Count + 1, obj.Capacity);
        end

        function v = values(obj)
            %VALUES Stored values as a row, oldest first, newest last.
            if obj.Count == 0
                v = zeros(1, 0);
                return
            end
            idx = mod(obj.Head - obj.Count + (0:obj.Count-1), obj.Capacity) + 1;
            v = obj.Data(idx);
        end

        function x = latest(obj)
            if obj.Count == 0
                error('swerve:RollingBuffer:empty', 'Buffer is empty.');
            end
            x = obj.Data(obj.Head);
        end

        function m = mean(obj)
            if obj.Count == 0
                error('swerve:RollingBuffer:empty', 'Buffer is empty.');
            end
            m = sum(obj.Data(1:obj.Capacity)) / obj.Count;
        end

        function tf = isFull(obj)
            tf = obj.Count == obj.Capacity;
        end

        function reset(obj)
            obj.Data(:) = 0;
            obj.Head = 0;
            obj.Count = 0;
        end
    end
end