%% DEMO Image Alignment
clear all
close all
image1 = imread('boat1.pgm');
image2 = imread('boat2.pgm');

% Convert the image to grayscale if needed and 
% normalize range between [0,255]
if length(size(image1)) == 3
    image1_gray = single(rgb2gray(image1));
    image2_gray = single(rgb2gray(image2));
else
    image1_gray = single(image1);
    image2_gray = single(image2);    
end 

% Detect features
[fa, fb, matches] = keypoint_matching(image1_gray, image2_gray);

% Plot the images with lines showing 50 random pairs
close all

% randomly sample 50 points
perm = randperm(size(matches,2)) ;
n_points = 50;
sel = perm(1:n_points) ;
sela = matches(1,sel);
selb = matches(2,sel);

% the second image starts after the first image
% shift the coordinates with the number of cols in image1
shift = size(image1,2);
fb_new = fb;
fb_new(1,:) = fb_new(1,:) + shift;

% Plot the two images and their corresponding features
figure;
imshow([image1,image2]);
hold on
h1 = vl_plotframe(fa(:,sela)) ;
h2 = vl_plotframe(fa(:,sela)) ;
h3 = vl_plotframe(fb_new(:,selb)) ;
h4 = vl_plotframe(fb_new(:,selb)) ;

%Plot the lines
for i = 1:n_points
    p1 = [fa(2,sela(i)),fa(1,sela(i))];
    p2 = [fb_new(2,selb(i)),fb_new(1,selb(i))];
    plot([p1(2),p2(2)],[p1(1),p2(1)],'color','r','LineWidth',2);
end

hold off
% Estimate affine transformation using RANSAC
dataIn = fa(1:2, matches(1,:));
dataOut = fb(1:2, matches(2,:));
sampleSize = 3;
threshDist = 10;
inlierRatio = 0.6;

% Set iteration count for a 99% chance of succes
iterationCount = log(1 - 0.99) / log(1 - inlierRatio^sampleSize);

% Perform ransac and visualize sample of transformed points for each
% best iteration
[A, ~] = ransac(dataIn, dataOut, sampleSize, iterationCount, threshDist, inlierRatio, image1, image2);
[B, ~] = ransac(dataOut, dataIn, sampleSize, iterationCount, threshDist, inlierRatio, image2, image1);
A = inv(A);
B = inv(B);

% Transform image1 and image2 according to affine matrices found by RANSAC

% Make tform structures from estimated transformation
TA = affine2d(A');
TB = affine2d(B');

% Use built-in functions for transformation
tformImage1 = imwarp(image1, TB);
tformImage2 = imwarp(image2, TA);

%% Use home-made functions for transformation
newImage2 = transformImage(image2, A);
newImage1 = transformImage(image1, B);

figure;
% Plot image2->image1 and image1->image2
subplot(1,2,1)
imshow(image1)
subplot(1,2,2)
imshow(mat2gray(newImage2))

figure
subplot(1,2,1)
imshow(image2)
subplot(1,2,2)
imshow(mat2gray(newImage1))

%% Compare built-in function to home-made
figure;

subplot(1,2,1); title('Home made transformation');
imshow(mat2gray(newImage2));
subplot(1,2,2); title('Built-in function');
imshow(tformImage2);

%% DEMO stitch.m
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

% find the features using SIFT
[f_left, da] = vl_sift(left_gray) ;
[f_right, db] = vl_sift(right_gray) ;

% extract inidices of the matches
[matches, scores] = vl_ubcmatch(da, db) ;

% Find transformation Matrix using RANSAC
dataIn = f_left(1:2, matches(1,:));
dataOut = f_right(1:2, matches(2,:));
sampleSize = 3;
threshDist = 10;
inlierRatio = 0.6;
iterationCount = log(1 - 0.99) / log(1 - inlierRatio^sampleSize);


[C, inliers] = ransac(dataIn, dataOut, sampleSize, iterationCount, threshDist, inlierRatio, left_gray, right_gray);

% For some reason, our transformation matrix is inverted.
C = inv(C);

%% Visualize sitched image along original image pair
stitched = stitch(left, right, C);
subplot(1, 3, 1);
imshow(stitched);
subplot(1, 3, 2);
imshow(left);
subplot(1, 3, 3);
imshow(right);