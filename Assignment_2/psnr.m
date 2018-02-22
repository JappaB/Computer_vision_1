%% Load images
clear all
close all

image1_original = imread('images/image1.jpg');
image1_sp = imread('images/image1_saltpepper.jpg');
image1_gauss = imread('images/image1_gaussian.jpg');

%% 4.2 Report the PSNR on image1

% PSNR for saltpepper
psnr_image1_sp = myPSNR(image1_original, image1_sp)

% PSNR for Gaussian noise
psnr_image1_gauss = myPSNR(image1_original, image1_gauss)

%% 4.3 Denoise images

image1_sp_denoised = denoise(image1_sp, 'median', [5 5]);
image1_gauss_denoised = denoise(image1_gauss, 'gaussian', 0.5, 5);

figure
subplot(2,2,1), imshow(image1_sp), title('saltpepper');
subplot(2,2,2), imshow(image1_sp_denoised), title('saltpepper denoised');
subplot(2,2,3), imshow(image1_gauss), title('gaussian');
subplot(2,2,4), imshow(image1_gauss_denoised), title('gaussian denoised');