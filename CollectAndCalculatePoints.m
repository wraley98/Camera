function [globalX , globalY , globalZ] = CollectAndCalculatePoints(pipe, pc, flyFunc)
% CollectAndCalculatePoints estimates points of CF
% compares two pointclouds, removes any similar points between the two and
% takes the mean of the remaining points to give an estimate of current
% location of CF

% initializes the previous coord array
prevCoords = zeros(407040 , 3);

% marks if the loop is on its first cycle
firstCyc = true;

% Tracks time/points of path
timeStamp = [];
xPoints = [];
yPoints = [];
zPoints = [];

initTime = 0;
index = 1;

while strcmp(flyFunc.State , 'running') 
    
    if firstCyc

        prevCoords = GetCoords(pipe , pc);
        firstCyc = false;
        initTime = 
        continue
        
    end
   
    [prevCoords, xCoords , yCoords , zCoords] = TrackForPlotPath(pipe , pc , prevCoords);

    xPoints(index) = mean(xCoords);
    yPoints(index) = mean(yCoords);
    zPoints(index) = mean(zCoords);

    index = index + 1;


end

[globalX , globalY , globalZ] = ConvertToGlobal(xPoints , yPoints , zPoints);

end

