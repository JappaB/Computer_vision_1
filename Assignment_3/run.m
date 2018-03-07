%% Load example images

clear all

person_image = rgb2gray(imread('person_toy/00000001.jpg'));
pingpong_image = rgb2gray(imread('pingpong/0000.jpeg'));

%% Plot points of interest

close all
threshold_ping = 3e-6;
threshold_pers = 5e-7;

% Swapping c/r fixed pard of the problem....
[H_pers, r_pers, c_pers] = harris_corner_detector(person_image, threshold_pers);
[H_ping, r_ping, c_ping] = harris_corner_detector(pingpong_image, threshold_ping);

%% Test rotation invariance
angle = random('uniform', 1, 360)
rotated_person = imrotate(person_image, angle);
[H_rotated, r_rotated, c_rotated] = harris_corner_detector(rotated_person, threshold_pers);

%% Lucas-Kanade for a single image pair
close all
 
image1 = imread('sphere1.ppm');
image2 = imread('sphere2.ppm');

[Vx, Vy] = lucas_kanade(image1, image2, 1);

