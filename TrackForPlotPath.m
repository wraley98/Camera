function [newCoords , adjustedX , adjustedY , adjustedZ] = TrackForPlotPath(pipe , pc , prevCoords)

% retrieves the current pointcloud
[newCoords] = GetCoords(pipe , pc);

adjustedX = [];
adjustedY = [];
adjustedZ = [];

index = 1;

for j = 1:height(newCoords)

    % determines the changes between the previous and current
    % pointclouds
    x = abs(newCoords(j , 1) - prevCoords(j , 1));
    y = abs(newCoords(j , 2) - prevCoords(j , 2));
    z = abs(newCoords(j , 3) - prevCoords(j , 3));

    % if the changes in coords are less then a threshhold, the 3D coord is
    % set to zero, or if the x,y,z coord is greater than the max range
    if x <= 2.5 && y <= 2.5 && z <= 2.5 || abs(newCoords(j , 1)) >= 1 || abs(newCoords(j , 2)) >= 1 || abs(newCoords(j , 3)) >= 1.7

        continue;

    else

        if newCoords(j , 1) == 0 || newCoords(j , 2) == 0 || newCoords(j , 3) == 0

            continue;

        end

        adjustedX(index) = newCoords(j , 1);
        adjustedY(index) = newCoords(j , 2);
        adjustedZ(index) = newCoords(j , 3);

        index = index + 1;

    end
end
end


