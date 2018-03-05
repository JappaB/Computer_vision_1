function [H, r, c, local_minima, Ix, Iy] = harris_corner_detector ( image, threshold ) 
    [H, Ix, Iy] = cornerness(image);
    local_minima = imerode(H, ones(3, 3)) == H;
    [r, c] = find( H > threshold & local_minima );
end