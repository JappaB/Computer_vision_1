function [h, w, xoffset, yoffset] = calculateCanvasSize(image, A, method)
%CALCULATECANVASSIZE Compute boundaries of transformed corners of the
% of the input image.
    corners = [1 1;size(image, 2) 1; 1 size(image, 1); size(image, 2) size(image, 1)]';
    newCorners = A * [corners; ones(1, size(corners, 2))];
    
    if method == "stitch"
        h = max(newCorners(2,:));
        w = max(newCorners(1,:));
    else
        h = max(newCorners(2,:)) - min(newCorners(2,:));
        w = max(newCorners(1,:)) - min(newCorners(1,:));
    end
    

    xoffset = min(newCorners(1,:));
    yoffset = min(newCorners(2,:));
end
