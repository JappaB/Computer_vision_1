function [output_image] = rgb2normedrgb(input_image)
% converts an RGB image into normalized rgb
% converts an RGB image into opponent color space

% First get RGB values
[R, G, B] = getColorChannels(input_image);

% Convert
out1 = (R) ./ (R+G+B);
out2 = (G) ./ (R+G+B);
out3 = (B) ./ (R+G+B);

% put together
output_image = out1;
output_image(:, :, 2) = out2;
output_image(:, :, 3) = out3;
end

