%% Load images
clear all
close all

image1_original = im2double(imread('images/image1.jpg'));
image1_sp = im2double(imread('images/image1_saltpepper.jpg'));
image1_gauss = im2double(imread('images/image1_gaussian.jpg'));

%% 4.2 Report the PSNR on image1

% PSNR for saltpepper
psnr_image1_sp = myPSNR(image1_original, image1_sp)

% PSNR for Gaussian noise
psnr_image1_gauss = myPSNR(image1_original, image1_gauss)

%% 4.3 Denoise images

% Question 7.1
kernel_sizes = [[3 3]; [5 5]; [7 7]];

[h,w] = size(image1_sp);
n = size(kernel_sizes, 1);

images_denoised_box = zeros(h, w, n);
images_denoised_median = zeros(h, w, n);

% Denoise saltpepper images with box/median
for i = 1:n
    images_denoised_box(:,:,i) = denoise(image1_sp, 'box', kernel_sizes(i, :));
    images_denoised_median(:,:,i) = denoise(image1_sp, 'median', kernel_sizes(i, :));
end

% Denoise gaussian images with gaussian 0.5, 1 and 2
sigmas = [0.5; 1; 2];
n = size(sigmas, 1);
images_denoised_gauss = zeros(h, w, n);
 
for i = 1:n
    images_denoised_gauss(:, :, i) = denoise(image1_gauss, 'gaussian', sigmas(i), [7 7]);
end
%% Plot denoised images
% Plot median filter results
figure
for i = 1:n
    subplot(1, n, i); imshow(images_denoised_median(:,:,i));
    sizes = kernel_sizes(i, :);
    title(string(sizes(1)) + "x" + string(sizes(2)));
end

% Plot boxfilter results
figure
for i = 1:n
    subplot(1, n, i); imshow(images_denoised_box(:,:,i));
    sizes = kernel_sizes(i, :);
    title(string(sizes(1)) + "x" + string(sizes(2)));
end

%% Plot gaussian results
figure
for i = 1:n
    subplot(1, n, i); imshow(images_denoised_gauss(:,:,i));
    sigma = sigmas(i);
    title(string(sigma));
end
%% Calculate PSN for denoised images

PSNR_median = zeros(n);
PSNR_box = zeros(n);

for i = 1:n
    PSNR_median = myPSNR(image1_original, images_denoised_median(:, :, i))
    PSNR_box = myPSNR(image1_original, images_denoised_box(:, :, i))
end