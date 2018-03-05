function [H, r, c, local_minima, Ix, Iy] = harris_corner_detector ( image, threshold ) 
    [H, Ix, Iy] = cornerness(image);
    
    % imerode applies non-linear filter that picks the minimum value
    % of a window around the current pixel. If that value doesn't change
    % it was a local maximum in the original.
    local_minima = imerode(H, ones(3, 3)) == H;
    temp = H > threshold & local_minima;
    size(temp)
    [r, c] = find( temp );
    
    figure;
    subplot(211)
    imshow(Ix)
    subplot(212)
    imshow(Iy)
    
    figure;
    imshow(image);
    hold on;
    plot(c, r, 'rd');
    hold off;
end