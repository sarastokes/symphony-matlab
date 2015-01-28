classdef ExamplePulse < symphonyui.models.Protocol
    
    properties (Constant)
        displayName = 'Example Pulse'
    end
    
    properties
        amp                             % Output device
        preTime = 50                    % Pulse leading duration (ms)
        stimTime = 500                  % Pulse duration (ms)
        tailTime = 50                   % Pulse trailing duration (ms)
        pulseAmplitude = 100            % Pulse amplitude (mV)
        preAndTailSignal = -60          % Mean signal (mV)
        numberOfAverages = uint16(5)    % Number of epochs
        interpulseInterval = 0          % Duration between pulses (s)
    end
    
    methods
    end
    
end
