function [h, w] = calculateCanvasSizeStitch(image, A)
%CALCULATECANVASSIZE - calculates the canvas size of the new stitched image
%
% image_left is the left image, image_right is the right_image
% It takes the left image as basis and calculate how much larger the
% imageframe should be to add the non overlapping part of the right image
%
% A is the transformation matrix to get from keypoints in the left to the
% keypoints in the right matrix
%
% matches are the matches between f_left (features left image) and f_right
% Inliers are the indices of the matches that are 'correct' matches 
% 
% The function RETURNS the width and the heigth of the new frame

% Find the highest index of a match between the features_left and
% features_right

    corners = [1 1; 1 size(image, 1); size(image, 2) 1; size(image, 1) size(image, 2)]';
    newCorners = A * [ corners ; ones(1, size(corners, 2))];
    h = max(newCorners(2,:));
    w = max(newCorners(1,:));
end

