% Fly CF
%
% Calls the python CF code to fly and hold

function [cfLog] = flyCF()

cfLog = pyrunfile('FlyAndHold.py' , 'returnLog');
cfLog = double(cfLog);
end

