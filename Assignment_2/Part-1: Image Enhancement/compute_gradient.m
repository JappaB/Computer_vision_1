function [Gx, Gy, im_magnitude,im_direction] = compute_gradient(image)
Gx = conv2([1 0 -1;2 0 -2; 1 0 -1], image); 
Gy = conv2([1 2 1; 0 0 0; -1 -2 -1], image);

im_magnitude = (Gx.^2+Gy.^2).^(1/2);
im_direction = atan(Gy/Gx);
end