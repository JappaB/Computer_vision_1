function [features] = extract_sift_features(image_set,colorspace,dense)
% Extracts the sift features for the given imae set
%   colorspace can be none (default = RGB), 'opponent','rgb' or 'gray' 
%   dense is either true or false. True indicates densely extracted
%   features.

% Initialize an empty matrix to store the features
features = [];
% for all imagesets
for i= 1: size(image_set,1)
    % for all images
    for j= 1: size(image_set,2)
        image_features = extract_sift_features_per_image(image_set{i,j}, colorspace, dense);
        features = [features image_features];
    end
end
end

