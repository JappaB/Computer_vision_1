%% Gaussians
gauss1D(2,5);
gauss2D(1,5);

%% Load images
clear all
close all

image2_original = imread('images/image2.jpg');
dispimage
%% Compute gradient
[Gx, Gy, im_magnitude,im_direction] = compute_gradient(image2_original);

figure
subplot(221)
imshow(Gx);
title('Gx')
subplot(222)
imshow(Gy);
title('Gy')

subplot(223)
imshow(im_magnitude);
title('Magnitude')

subplot(224)
imshow(im_direction);
title('direction')

%% Laplacian of Gaussians

imOut1 = compute_LoG(image2_original, 1);
imOut2 = compute_LoG(image2_original, 2);
imOut3 = compute_LoG(image2_original,3);
figure
subplot(131), imshow(imOut1), title('method 1');
subplot(132), imshow(imOut2), title('method 2');
subplot(133), imshow(imOut3), title('method 3');


