function [H] = cornerness(image)
%CORNERNESS Calculate the H value for the Harris Corner Detector

    % Define guassian filters
    G = fspecial('gauss', [3 3], 0.5);
    [Gx, Gy] = gradient(G);
    
    % Compute derivatives 
    Ix = imfilter(image, Gx);
    Iy = imfilter(image, Gy);
    
    % Harris components 
    A = imfilter(Ix .^ 2, G);
    C = imfilter(Iy .^ 2, G);
    B = imfilter(Ix .* Iy, G);
   
    H = (A .* C - B .^ 2) - 0.04*(A + C) .^ 2;
end

