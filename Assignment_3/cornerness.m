function [H, Ix, Iy] = cornerness(image)
%CORNERNESS Calculate the H value for the Harris Corner Detector
    image = im2double(image);
    
    % Define guassian filter
    G = fspecial('gauss', [10 10], 1);
    
    % Compute derivatives 
    [Gx, Gy] = gradient(G);

    Ix = imfilter(image, Gx, 'replicate', 'conv');
    Iy = imfilter(image, Gy, 'replicate', 'conv');
    
    % Harris components 
    A = imfilter(Ix .^ 2, G, 'conv');
    C = imfilter(Iy .^ 2, G, 'conv');
    B = imfilter(Ix .* Iy, G, 'conv');

    H = (A .* C - B .^ 2) - 0.04*(A + C) .^ 2;
end

