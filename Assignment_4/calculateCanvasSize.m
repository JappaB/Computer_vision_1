function [h, w, xoffset, yoffset] = calculateCanvasSize(image, A, method)
%CALCULATECANVASSIZE Compute boundaries of transformed corners of the
% of the input image.

    % Transform corners of image
    corners = [1 1;size(image, 2) 1; 1 size(image, 1); size(image, 2) size(image, 1)]';
    newCorners = A * [corners; ones(1, size(corners, 2))];
    
    % Different behaviour based on application
    if method == "stitch"
        % Return max
        h = max(newCorners(2,:));
        w = max(newCorners(1,:));
    else
        % Return difference between extrema
        h = max(newCorners(2,:)) - min(newCorners(2,:));
        w = max(newCorners(1,:)) - min(newCorners(1,:));
    end
    
    % Return offset for aligning the image in the figure
    xoffset = min(newCorners(1,:));
    yoffset = min(newCorners(2,:));
end
