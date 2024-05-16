function [globalX , globalY , globalZ] = ConvertToGlobal(cameraCFPtsX , cameraCFPtsY , cameraCFPtsZ)
%CONVERTTOGLOBAL converts points in camera frame to the global reference frame 

% location of the camera wrt the global reference frame
cameraLocX = 2.3;
cameraLocY = 2.173;
cameraLocZ = 0.396;

% update the points
globalX = cameraLocX - cameraCFPtsX;
globalY = cameraLocY - cameraCFPtsY;
globalZ = cameraLocZ - cameraCFPtsZ;


end

