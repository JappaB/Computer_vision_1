function [recolored_image] = recoloring(reflectance, shading, r,g,b)
% [R,G,B] = getColorChannels(reflectance);

% recolored reflectance
reflectance_recolored = reflectance;
reflectance_recolored(:,:,1) = r;
reflectance_recolored(:,:,2) = g;
reflectance_recolored(:,:,3) = b;


recolored_image = iid_image_formation(im2double(reflectance_recolored),shading);
end