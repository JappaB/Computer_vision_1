%% Load example images

clear all

person_image = rgb2gray(imread('person_toy/00000001.jpg'));
pingpong_image = rgb2gray(imread('pingpong/0000.jpeg'));

%% Plot points of interest

close all
threshold = 0.0025;

[H_pers, r_pers, c_pers, interest_pers, Ix, Iy] = harris_corner_detector(person_image, threshold);

% [H_ping, r_ping, c_ping] = harris_corner_detector(pingpong_image, threshold);

% TODO
figure;
imshow(person_image);
hold on;
plot(r_pers, c_pers, 'rd');

hold off;
figure;
subplot(211)
imshow(Ix)
subplot(212)
imshow(Iy)

%% Lucas-Kanade
close all


image1 = imread('sphere1.ppm');
image2 = imread('sphere2.ppm');

lucas_kanade(image1, image2, 1);
