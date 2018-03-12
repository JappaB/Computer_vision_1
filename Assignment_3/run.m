%% Load example images

clear all

person_image = rgb2gray(imread('person_toy/00000001.jpg'));
pingpong_image = rgb2gray(imread('pingpong/0000.jpeg'));

%% Demo of corner detection algorithm on
harris_demo(person_image, pingpong_image);

%% Test rotation invariance
angle = random('uniform', 1, 360)
rotated_person = imrotate(person_image, angle);
[H_rotated, r_rotated, c_rotated] = harris_corner_detector(rotated_person, threshold_pers, false);

%% Lucas-Kanade for a single image pair
close all
 
image1 = imread('synth1.pgm');
image2 = imread('synth2.pgm');

lucas_demo(image1, image2);

%% Track features over multiple frames
track_features("person_toy/", "*.jpg", 5e-7, 1.9);