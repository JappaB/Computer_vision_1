function [H, r, c, local_minima, Ix, Iy] = harris_corner_detector ( image, threshold ) 
    [H, Ix, Iy] = cornerness(image);
    
    % imerode applies non-linear filter that picks the minimum value
    % of a window around the current pixel. If that value doesn't change
    % it was a local maximum in the original.
    local_minima = imdilate(H, ones(3, 3)) == H;
    [r, c] = find( H > threshold & local_minima );

    % Plot image gradients
    figure;
    subplot(131)
    imshow(mat2gray(Ix)); title('Horizontal gradient');
    subplot(132)
    imshow(mat2gray(Iy)); title('Vertical gradient');
    subplot(133)
    
    % Plot image with circles around the detected corners
    imshow(image); title('Interest points');
    hold on;
    plot(c, r, 'rd');
    hold off;
end