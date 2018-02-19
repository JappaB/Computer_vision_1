close all
clear all
clc
%load img
image1 = imread('awb.jpg');
image2 = imread('van_gogh_blue.jpg');

% Automatic White Balance
image_new1 = AWB(image1);
image_new2 = AWB(image2);

figure;
subplot(2,2,1);
imshow(image1);

subplot(2,2,2);
imshow(image_new1);

subplot(2,2,3);
imshow(image2);

subplot(2,2,4);
imshow(image_new2);
