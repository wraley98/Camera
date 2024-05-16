function [cfData , cameraPts]= PlotPath()
%PlotPath Driver function for flying, tracking, and then plotting the path 
% of the CF

% Creates parallel code to fly CF
pool = parpool('Processes');

% Set path to realsense modules
addpath('C:\Users\Will\Desktop\camera\IntelRealSenseSDK2.0')

% Create pipeline and stream for camera
pipe = realsense.pipeline();
pc = realsense.pointcloud();
profile = pipe.start();

% Adds function to the parallel code
flyFunc = parfeval(pool, @flyCF , 1);

% Retrieves the estimated points from the camera
[xPoints, yPoints, zPoints] = CollectAndCalculatePoints(pipe,pc, flyFunc);

% retrieves the CF data
cfData = fetchOutputs(flyFunc);

% Stop streaming from camera
pipe.stop();

% Plot the path of the CF
figure(1)
%plot3(xPoints , zPoints , yPoints)
hold on

%plot3(xPoints , zPoints , yPoints, 'k.')

% firstPtIndex = 1;
% while(1)
%     if isnan(xPoints(firstPtIndex))
%         firstPtIndex = 1 + firstPtIndex; 
%     else
%         plot3(xPoints(firstPtIndex) , zPoints(firstPtIndex) , yPoints(firstPtIndex), 'g.' , 'MarkerSize', 100)
%         break
%     end
%     
% end
% 
% lastPtIndex = 0;
% while(1)
%     if isnan(xPoints(end - lastPtIndex))
%         lastPtIndex = 1 + lastPtIndex; 
%     else
%         plot3(xPoints(end - lastPtIndex) , zPoints(end - lastPtIndex) , yPoints(end - lastPtIndex), 'b.' , 'MarkerSize', 100)
%         break
%     end
%     
% end

plot3(cfData(2 , :) , cfData(3 , :) , cfData(4 , :), 'r.')

xlabel('x');
ylabel('y');
zlabel('z');

axis equal

% shutdown parallel code
delete(gcp('nocreate'));

cameraPts = [xPoints ; yPoints ; zPoints];

end