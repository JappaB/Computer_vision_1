close all
clear all
clc

%load images (as doubles, otherwise it is not precise enough)
ball = (imread('ball.png'));
ball_reflectance = im2double(imread('ball_reflectance.png'));
ball_shading = im2double(imread('ball_shading.png'));

% reconstruct the image by doing the pointwise multiplication of shading
% and reflectance
ball_reconstructed = iid_image_formation(ball_reflectance, ball_shading);

% show the original, the components and the reconstructed image
figure;
subplot(2,2,1);
imshow(ball);

subplot(2,2,2);
imshow(ball_reconstructed);

subplot(2,2,3);
imshow(ball_reflectance);

subplot(2,2,4);
imshow(ball_shading);

%True material color in RGB space (uniform)
[R,G,B] = getColorChannels(ball_reflectance);
fprintf('R: %.4f, G: %.4f, B:%.4f',R(130,240),G(130,240),B(130,240))

% Recoloring (give rgb as values between 0-1 because they are doubles)
green_ball = recoloring(ball_reflectance,ball_shading,0,1,0);
magenta_ball = recoloring(ball_reflectance,ball_shading,1,0,1);

figure;
subplot(1,3,1);
imshow(ball);
subplot(1,3,2);
imshow(green_ball);
subplot(1,3,3);
imshow(magenta_ball);

