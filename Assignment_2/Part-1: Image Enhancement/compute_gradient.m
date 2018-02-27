function [Gx, Gy, im_magnitude,im_direction] = compute_gradient(image)

%Im2double = NEEDED!!
image = im2double(image);
Gx = conv2(image, [1 0 -1;2 0 -2; 1 0 -1]); 
Gy = conv2(image, [1 2 1; 0 0 0; -1 -2 -1]);

im_magnitude = (Gx.^2+Gy.^2).^(1/2);
im_direction = atan(Gy./Gx);
end