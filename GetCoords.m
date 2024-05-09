% Get Coords
%
% Takes a single point cloud snapshot

function [vertices] = GetCoords(pipe , pointcloud)

% Obtain frames from a streaming device
fs = pipe.wait_for_frames();

% Select depth frame
depth = fs.get_depth_frame();


% Produce pointcloud
if (depth.logical())

    points = pointcloud.calculate(depth);

    % Adjust frame CS to matlab CS
    vertices = points.get_vertices();
end

%app = CaptureFrame();
%img = app.capturedImageData;

end

