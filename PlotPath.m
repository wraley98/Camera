%Plot Path
%
% Driver function for flying, tracking, and then plotting the path of the
% CF

function [pathPts] = PlotPath()

pool = parpool('Processes');
path = parfeval(pool, @TrackCF , 1);

%flyCF();

pathPts = fetchNext(path);
cancel(path);

delete(gcp('nocreate'));

end