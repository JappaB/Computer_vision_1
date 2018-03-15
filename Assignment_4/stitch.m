%TODO: should be function, but is easier to program when it's not a function
%% Load images
clear all
close all
left = im2double(imread('left.jpg'));
right = im2double(imread('right.jpg'));

% Convert the image to grayscale if needed and 
% normalize range between [0,255]
if length(size(left)) == 3
    left_gray = single(rgb2gray(left));
    right_gray = single(rgb2gray(right));
else
    left_gray = single(left);
    right_gray = single(right);    
end 
%% find the features using SIFT
% The matrix f has a column for each frame
% A frame is a disk of center f(1:2), scale f(3) and orientation f(4)

[f_left, da] = vl_sift(left_gray) ;
[f_right, db] = vl_sift(right_gray) ;
% matches 
[matches, scores] = vl_ubcmatch(da, db) ;

%% Find transformation Matrix
% RANSAC
dataIn = f_left(1:2, matches(1,:));
dataOut = f_right(1:2, matches(2,:));
sampleSize = 3;
iterationCount = 10000;
threshDist = 10;
inlierRatio = 0;

% TODO: Debug ransac
[C, inliers] = ransac(dataIn, dataOut, sampleSize, iterationCount, threshDist, inlierRatio)

%% Estimate size of new image 
% (hint:calculate the transformed coordinates of corners of right.jpg)

% H and W are the corners of the right image
[h, w] = calculateCanvasSize(right_gray, C);

% The new image is the size of the left image + the corners of the transformed 
% right image
CA = affine2d(C');
newImageLeft = transformImage(right, C);
imshow(newImageLeft)


%% Visualize sitched image along original image pair
% Use affine matrix to map each pixel to a new coordinate
stitched = stitchFunction(left, right, C);
imshow(stitched)

