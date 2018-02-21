function [image_new, diffR, diffG, diffB] = AWB(image)
%calculate differences
diffR = 128 - mean2(image(:,:,1));
diffG = 128 - mean2(image(:,:,2));
diffB = 128 - mean2(image(:,:,3));

image_new = image;
image_new(:,:,1) = image(:,:,1) + diffR;
image_new(:,:,2) = image(:,:,2) + diffG;
image_new(:,:,3) = image(:,:,3) + diffB;

end
