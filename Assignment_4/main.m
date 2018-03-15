%% Load images
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

%% Detect features
[fa, fb, matches] = keypoint_matching(image1_gray, image2_gray);

%% Plot the images with lines showing 50 random pairs
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
%% RANSAC
dataIn = fa(1:2, matches(1,:));
dataOut = fb(1:2, matches(2,:));
sampleSize = 3;
iterationCount = 10000;
threshDist = 10;
inlierRatio = 0.6;

[A, inliers] = ransac(dataIn, dataOut, sampleSize, iterationCount, threshDist, inlierRatio);
[B, ~] = ransac(dataOut, dataIn, sampleSize, iterationCount, threshDist, inlierRatio);
%% Transform image1 and image2 according to affine matrices found by RANSAC
    
TA = affine2d(A');

newImage2 = imwarp(image2, TA.invert);
newImage2_ours = transformImage(image2, A);
%%
subplot(1,3,1)
imshow(mat2gray(newImage2_ours))
subplot(1,3,2)
imshow(mat2gray(newImage2))
subplot(1,3,3)
imshow(image2)

% figure
% subplot(1,2,1)
% imshow(image2)
% subplot(1,2,2)
% imshow(mat2gray(newImage))