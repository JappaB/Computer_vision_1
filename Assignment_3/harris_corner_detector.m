function [H, r, c, Ix, Iy] = harris_corner_detector ( image, threshold ) 
    [H, Ix, Iy] = cornerness(image);
    
    % imerode applies non-linear filter that picks the minimum value
    % of a window around the current pixel. If that value doesn't change
    % it was a local maximum in the original.
    local_minima = imdilate(H, ones(3, 3)) == H;
    [r, c] = find( H > threshold & local_minima );

end