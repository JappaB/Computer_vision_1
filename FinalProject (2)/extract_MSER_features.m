function [features] = extract_MSER_features(image_set,colorspace,dense)
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
        

        % Grayscale image needed to extract keypoints
        image = image_set{i,j};
        if length(size(image)) == 3
            image_gray = uint8(rgb2gray(image)); 
        else
            image_gray = uint8(image);
        end
        % If the desired colorspace is gray, add to features array and
        % continue
        if strcmp(colorspace, 'gray')

            % Extract feature descriptors
            [r,f] = vl_mser(uint8(image_gray));
            disp(f)
            features = [features f];
            continue
           
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
    end
end

