%TODO: should be function, but is easier to program when it's not a function
%% Load images
clear all
close all
image1 = im2double(imread('left.jpg'));
image2 = im2double(imread('right.jpg'));

% Convert the image to grayscale if needed and 
% normalize range between [0,255]
if length(size(image1)) == 3
    image1_gray = single(rgb2gray(image1));
    image2_gray = single(rgb2gray(image2));
else
    image1_gray = single(image1);
    image2_gray = single(image2);    
end 
%% find the features using SIFT
% The matrix f has a column for each frame
% A frame is a disk of center f(1:2), scale f(3) and orientation f(4)

[f_left, da] = vl_sift(image1_gray) ;
[f_right, db] = vl_sift(image2_gray) ;
% matches 
[matches, scores] = vl_ubcmatch(da, db) ;

%% Find transoformation Matrix
% RANSAC
dataIn = f_left(1:2, matches(1,:));
dataOut = f_right(1:2, matches(2,:));
sampleSize = 2;
iterationCount = 10000;
threshDist = 10;
inlierRatio = 0;

% TODO: Debug ransac
[A, inliers] = ransac(dataIn, dataOut, sampleSize, iterationCount, threshDist, inlierRatio)

%% Estimate size of new image 
% (hint:calculate the transformed coordinates of corners of right.jpg)

% H and W are the corners of the right image
[h, w] = calculateCanvasSize(image2_gray, A);

% The new image is the size of the left image + the corners of the transformed 
% right image

newImage = zeros(ceil(w)+size(image1_gray,1), ceil(h) + size(image1_gray,2));


%% Visualize sitched image along original image pair
% Use affine matrix to map each pixel to a new coordinate
close all


% First find the rightmost matching interest point in the right image which
% is an inlier

last_match = round(f_left(1:2, matches(1,max(inliers))))


for x = 1:size(newImage, 2)
    for y = 1:size(newImage, 1)
        
        % if x and y are still within the row and columns apce of the left
        % image, the pixel of the stitched image is the same as the pixel of the left image
        if y <= size(image1_gray,2) && x <= last_match(1)
            newImage(x,y,1) = image1(x,y,1);
            newImage(x,y,2) = image1(x,y,2);
            newImage(x,y,3) = image1(x,y,3);
        else
            % Transform the coordinates
            % calculate the coordinate of the pixel that would land at (x,y)
            cord = [(x-size(image1_gray,1)); (y-size(image1_gray,2)); 1];
            oldCord = A \ cord;
            % Check if the coordinate inside the canvas of the new image
            if all(oldCord > 1) && oldCord(1) < size(image2, 1) && oldCord(2) < size(image2, 2)
                disp('hello')
                newImage(cord(1), cord(2), 1) = image2(round(oldCord(1)), round(oldCord(2)), 1);
                newImage(cord(1), cord(2), 2) = image2(round(oldCord(1)), round(oldCord(2)), 2);
                newImage(cord(1), cord(2), 3) = image2(round(oldCord(1)), round(oldCord(2)), 3);
            end

        end
    end 
end

% normalize all RGB values
newImage = im2double(newImage);
% R = newImage(:,:,1);
% G = newImage(:,:,2);
% B = newImage(:,:,3);
% Sum = R+G+B;
% 
% r = R./Sum;
% g = G./Sum;
% b = B./Sum;
% 
% newImage(:,:,1) = r;
% newImage(:,:,2) = g;
% newImage(:,:,3) = b;

% Plot image
imshow(newImage);