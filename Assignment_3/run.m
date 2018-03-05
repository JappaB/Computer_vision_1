%% Load example images

clear all

person_image = rgb2gray(imread('person_toy/00000001.jpg'));
pingpong_image = rgb2gray(imread('pingpong/0000.jpeg'));

%% Plot points of interest

close all
threshold = 0.001;

% Swapping c/r fixed pard of the problem....
[H_pers, r_pers, c_pers] = harris_corner_detector(person_image, threshold);
[H_ping, r_ping, c_ping] = harris_corner_detector(pingpong_image, threshold);

%% Lucas-Kanade
close all


image1 = imread('sphere1.ppm');
image2 = imread('sphere2.ppm');

lucas_kanade(image1, image2, 1);
