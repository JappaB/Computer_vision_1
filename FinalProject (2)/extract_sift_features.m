function [features] = extract_sift_features(image_set,colorspace,dense)
% Extracts the sift features for the given imae set
%   colorspace can be none (default = RGB), 'opponent','rgb' or 'gray' 
%   dense is either true or false. True indicates densely extracted
%   features.

% Initialize a cell array to store the features
features = {}
% for all imagesets
for i= 1: size(image_set,1)
    % for all images
    for j= 1: size(image_set,2)

        % Grayscale image needed to extract keypoints
        image = image_set{i,j};
        image_gray = rgb2gray(image); 

        % If the desired colorspace is gray, add to features array and
        % continue
        if strcmp(colorspace, 'gray');

            % Extract feature descriptors
            if dense == true;
                [f, d] = vl_dsift(single(image_gray));
            else
                [f, d] = vl_sift(single(image_gray));
            end
            features{i,j} = d;
            continue
        end
           
        % Only colored pictures can be used for the RGB,rgb,opponent SIFT
        if length(size(image)) == 3;
                     
            % Default is rgb
            % else: change color space
            if strcmp(colorspace, 'opponent')                
                image = single(rgb2opponent(image)); 
            elseif strcmp(colorspace, 'RGB');
                
            elseif strcmp(colorspace, 'normalized_rgb');
                %do nothing
                % image = single(rgb2normedrgb(image));
            end
            
            
            % Extract the keypoints
            if dense == true;
                [f, d] = vl_dsift(single(image_gray));
            else
                [f, d] = vl_sift(single(image_gray));
            end
            
            % If the desired colorspace is not gray, do vl_sift on all
            % seperate color channels
            
            for k = 1:3;
                % Extract channel
                channel = image(:,:,k);
                
                % Follow VL_Feat documentation on how to extract grad
                I_       = vl_imsmooth(im2double(channel), sqrt(f(3)^2 - 0.5^2)) ;
                [Ix, Iy] = vl_grad(I_) ;
                mod      = sqrt(Ix.^2 + Iy.^2) ;
                ang      = atan2(Iy,Ix) ;
                grad      = shiftdim(cat(3,mod,ang),2) ;
                grad      = single(grad) ;
                
                % Extract features and add to feature cell array
                d =  vl_siftdescriptor(grad, f);
                features{i,j}(:,:,k) = d;
            end
         
        end
     
    end
end


end

