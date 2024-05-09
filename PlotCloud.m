% Plot Cloud
%
% Creates a 3D plot of the the point cloud snapshot

function PlotCloud()

pipe = realsense.pipeline();
pointcloud = realsense.pointcloud();
profile = pipe.start();

v = GetCoords(pipe , pointcloud);

pipe.stop();

close all;

plot3(v(: , 1) , v(:,2) , v(:,3) , 'ko')

hold on

xlim([-1 1])
ylim([-1 1])
zlim([-1 1])

xlabel('X');
ylabel('Z');
zlabel('Y');

view([0 0 -1])


end

