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
        

        % Grayscale image needed to extract keypoints
        image = image_set{i,j};
        if length(size(image)) == 3
            image_gray = rgb2gray(image); 
        else
            image_gray = image;
        end
        % If the desired colorspace is gray, add to features array and
        % continue
        if strcmp(colorspace, 'gray')

            % Extract feature descriptors
            if dense == true
                [f, d] = vl_dsift(single(image_gray), 'step', 20);
                features = [features d];  
                
            else
                [f, d] = vl_sift(single(image_gray));
                features = [features d];
            end
            
            continue
           
        end

        % Only colored pictures can be used for the RGB,rgb,opponent SIFT
        if length(size(image)) == 3

            % Default is rgb
            % else: change color space
            %TODO: check funtions color spaces
            %TODO: 
            if strcmp(colorspace, 'opponent')                
                image = rgb2opponent(image); 
            elseif strcmp(colorspace, 'RGB')
                % do nothing
            elseif strcmp(colorspace, 'normalized_rgb')
                image = rgb2normedrgb(image);
            end


            % Extract the keypoints
            if dense == true
                combined_channels = [];
                
                for k = 1:3                    
                    % Extract channel
                    channel = single(image(:,:,k));
                    [f, d] = vl_dsift(channel, 'step',20);
                    combined_channels = cat(1,combined_channels, d);
                end

            else
                im = single(image_gray);
                [f, d] = vl_sift(im);
                                
                % If the desired colorspace is not gray, do vl_sift on all
                % seperate color channels
                combined_channels = [];
                for k = 1:3;
                    % Extract channel
                    channel = single(image(:,:,k));

                    % Follow VL_Feat documentation on how to extract grad
                    I_       = vl_imsmooth(im2double(channel), sqrt(f(3)^2 - 0.5^2)) ;
                    [Ix, Iy] = vl_grad(I_) ;
                    mod      = sqrt(Ix.^2 + Iy.^2) ;
                    ang      = atan2(Iy,Ix) ;
                    grad      = shiftdim(cat(3,mod,ang),2) ;
                    grad      = single(grad) ;

                    % Extract features and add to feature cell array
                    d =  vl_siftdescriptor(grad, f);
                    combined_channels = cat(1,combined_channels, d);
                end                               
            end
            
            features = [features combined_channels];




        end    
    end
end


end

