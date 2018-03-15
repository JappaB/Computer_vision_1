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

%% find the features using SIFT
% The matrix f has a column for each frame
% A frame is a disk of center f(1:2), scale f(3) and orientation f(4)

[fa, da] = vl_sift(image1_gray) ;
[fb, db] = vl_sift(image2_gray) ;
% matches 
[matches, scores] = vl_ubcmatch(da, db) ;

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

%# plot the points.
%# Note that depending on the definition of the points,
%# you may have to swap x and y
% plot([p1(2),p2(2)],[p1(1),p2(1)],'Color','r','LineWidth',2)

% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;

%  %other possibility: https://stackoverflow.com/questions/22733985/draw-matched-points-between-two-images-in-matlab
% 
% % randomly sample 50 points
% sample = datasample(matches,50,2);
% 
% matchedPoints1 = da(sample(1,:));
% matchedPoints2 = db(sample(2,:));
% % Plot
% figure; ax = axes;
% showMatchedFeatures(image1_gray,image2_gray,matchedPoints1,matchedPoints2,'montage','Parent',ax);
% title(ax, 'Candidate point matches');
% legend(ax, 'Matched points 1','Matched points 2');
%% RANSAC
dataIn = fa(1:2, matches(1,:));
dataOut = fb(1:2, matches(2,:));
sampleSize = 2;
iterationCount = 10000;
threshDist = 10;
inlierRatio = 0;

% TODO: Debug ransac
[A, inliers] = ransac(dataIn, dataOut, sampleSize, iterationCount, threshDist, inlierRatio)
% inliers = matches(:, inliers);
% A = createAffineTransformation(fa(1:2, inliers), fb(1:2, inliers));
%% Transform image1 according to affine matrix found by RANSAC

% TODO: calculate size of new canvas
[h, w] = calculateCanvasSize(image2, A);
newImage = zeros(ceil(w), ceil(h));

%% Use affine matrix to map each pixel to a new coordinate
for x = 1:size(newImage, 2)
    for y = 1:size(newImage, 1)
        
        % calculate the coordinate of the pixel that would land at (x,y)
        cord = [x; y; 1];
        oldCord = A \ cord;
        
        % Check if the coordinate inside the canvas of the source image
        if all(oldCord > 1) && oldCord(1) < size(image2, 1) && oldCord(2) < size(image2, 2)
            newImage(cord(1), cord(2)) = image2(round(oldCord(1)), round(oldCord(2)));
        end
    end 
end

subplot(1,2,1)
imshow(image1)
subplot(1,2,2)
imshow(mat2gray(newImage))