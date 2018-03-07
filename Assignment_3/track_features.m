function track_features(image_dir, pattern, threshold)
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    image_struct = dir(char(image_dir + pattern));
    n_files = length(image_struct)
    
    first_image_name = image_struct(1).name;
    im_prev = imread(char(image_dir + first_image_name));
    
    [~, i_r, i_c] = harris_corner_detector(im_prev, threshold, false);
    
    figure
    for im=2:n_files
        im_curr = imread(char(image_dir + image_struct(im).name));
        [Vx, Vy] = lucas_kanade(im_prev, im_curr, 1, i_r', i_c');
        
        % Plot optical flow
        imshow(im_prev);
        hold on
        quiver(i_c', i_r', Vx, Vy);
        hold off
        
        drawnow
        
        i_c = i_c + Vx';
        i_r = i_r + Vy';
        
        im_prev = im_curr;
    end
end

