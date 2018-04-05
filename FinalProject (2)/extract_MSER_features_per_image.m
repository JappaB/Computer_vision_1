function [features] = extract_MSER_features_per_image(image,colorspace, dense)
% Extracts the sift features for the given imae set
%   colorspace can be none (default = RGB), 'opponent','rgb' or 'gray' 
%   features.

% Initialize an empty matrix to store the features
features = [];

if length(size(image)) == 3
    image_gray = rgb2gray(image); 
else
    image_gray = image;
end
% If the desired colorspace is gray, add to features array and

if strcmp(colorspace, 'gray')

    % Extract feature descriptors
    [r,f]=vl_mser(uint8(image_gray));
    features = [features f]

end

% Only colored pictures can be used for the RGB,rgb,opponent SIFT
if length(size(image)) == 3

    % Default is rgb
    % else: change color space
    if strcmp(colorspace, 'opponent')                
        image = rgb2opponent(image); 
    elseif strcmp(colorspace, 'RGB')
        % do nothing
    elseif strcmp(colorspace, 'normalized_rgb')
        image = rgb2normedrgb(image);
    end

    % If the desired colorspace is not gray, do vl_sift on all
    % seperate color channels
    combined_channels = [];
    for k = 1:3;
        % Extract channel
        channel = uint8(image(:,:,k));

        % apply MSER to channel
        [r,f]=vl_mser(uint8(channel)); 
        % add to feature array
        combined_channels = cat(1,combined_channels, f);
    end                               
end

features = [features combined_channels];




end    

