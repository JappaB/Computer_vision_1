function [features] = extract_MSER_features_per_image(image,colorspace)
% Extracts the sift features for the given imae set
%   colorspace can be none (default = RGB), 'opponent','rgb' or 'gray' 
%   features.

% Initialize an empty matrix to store the features
features = [];

if length(size(image)) == 3
    image_gray = im2uint8(rgb2gray(image)); 
else
    image_gray = im2uint8(image);
end
% If the desired colorspace is gray, add to features array and

if strcmp(colorspace, 'gray')
    % Extract feature descriptors
    [r,f]=vl_mser(image_gray);
    features = histograms_from_mser(image_gray, r);

else

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
        channel = im2uint8(image(:,:,k));
        
        channel_feats = histograms_from_mser(channel, r);
        
        % add to feature array
        combined_channels = [combined_channels; channel_feats];
    end
    features = [features combined_channels];
end


end

function features = histograms_from_mser(im, r)
    features = [];
    for i = 1:size(r)
        M = vl_erfill(im, double(r(i)));
        hist_f = histcounts(im(M), 200, 'Normalization', 'count');
        features = [features uint8(hist_f')];
    end
end

