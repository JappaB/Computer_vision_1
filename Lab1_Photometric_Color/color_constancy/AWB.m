function [image_new] = AWB(image)
%calculate differences
grey = mean2(mean(image, 3));
diffR = grey / mean2(image(:,:,1));
diffG = grey / mean2(image(:,:,2));
diffB = grey / mean2(image(:,:,3));

image_new = zeros(size(image));
image_new(:,:,1) = image(:,:,1) * diffR;
image_new(:,:,2) = image(:,:,2) * diffG;
image_new(:,:,3) = image(:,:,3) * diffB;

mean(mean(image_new))

end