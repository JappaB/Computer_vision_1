function [output_image] = rgb2opponent(input_image)
% converts an RGB image into opponent color space

% First get RGB values
[R, G, B] = getColorChannels(input_image);
% Convert
out1 = (R - G) ./ sqrt(2);
out2 = (R + G - 2 * B) ./ sqrt(6);
out3 = (R + G + B) ./ sqrt(3);

% put together
output_image = out1;
output_image(:, :, 2) = out2;
output_image(:, :, 3) = out3;

end

