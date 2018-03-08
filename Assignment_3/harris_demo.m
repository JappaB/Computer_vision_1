function harris_demo(image1, image2)
    % Plot the results for harris_corner_detector.m on two
    % demo images
    close all
    
    threshold1 = 3e-6;
    threshold2 = 5e-7;

    % Detect corners
    [~, r1, c1, Ix1, Iy1] = harris_corner_detector(image1, threshold2);
    [~, r2, c2, Ix2, Iy2] = harris_corner_detector(image2, threshold1);
    
    % Plot person_toy/0000000.jpg gradients and interest points
    figure;
    subplot(131)
    imshow(mat2gray(Ix1)); title('Horizontal gradient');
    subplot(132)
    imshow(mat2gray(Iy1)); title('Vertical gradient');
    subplot(133)
    imshow(image1); title('Interest points person_toy');
    hold on;
    plot(c1, r1, 'rd');
    hold off;
    
    % Plot pingpong/0000.jpeg gradients and interest points
    figure;
    subplot(131)
    imshow(mat2gray(Ix2)); title('Horizontal gradient');
    subplot(132)
    imshow(mat2gray(Iy2)); title('Vertical gradient');
    subplot(133)
    imshow(image2); title('Interest points pingpong');
    hold on;
    plot(c2, r2, 'rd');
    hold off;
end

