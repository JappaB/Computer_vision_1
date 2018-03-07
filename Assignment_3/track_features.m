function track_features(image_dir, pattern, threshold, vel_scaling)
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    image_struct = dir(char(image_dir + pattern));
    n_files = length(image_struct);
    
    first_image_name = image_struct(1).name;
    im_prev = imread(char(image_dir + first_image_name));
    
    [~, i_r, i_c] = harris_corner_detector(im_prev, threshold);
    
    % lucas_kanade works with row-vectors
    i_r = i_r';
    i_c = i_c';
    
    [h, w] = size(im_prev);
    video = VideoWriter('animation.mp4', 'MPEG-4');
    open(video);
    
    handle = figure();
    for im=2:n_files
            
        im_curr = imread(char(image_dir + image_struct(im).name));
        [Vx, Vy] = lucas_kanade(im_prev, im_curr, 1, i_r, i_c);
        
        % Plot optical flow
        imshow(im_prev);
        hold on
        quiver(i_c, i_r, Vx, Vy);
        drawnow
        hold off

        i_c = i_c + vel_scaling * Vx;
        i_r = i_r + vel_scaling * Vy;
        
        if im > 54
           Vx
           Vy
        end
        
        writeVideo(video, getframe(handle));
        
        im_prev = im_curr;
    end
end

