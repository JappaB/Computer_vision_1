function [h, w] = calculateCanvasSize(image,A)
%CALCULATECANVASSIZE Summary of this function goes here
%   Detailed explanation goes here
    corners = [0 0; 0 size(image, 2); size(image, 1) 0; size(image)]';
    newCorners = A * [ corners ; ones(1, size(corners, 2)) ];
    h = max(newCorners(2,:)) - min(newCorners(2,:));
    w = max(newCorners(1,:)) - min(newCorners(1,:));
end

