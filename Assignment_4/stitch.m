function stitchedImage = stitch(image1,image2, A, t)
    %STITCHFUNCTION Summary of this function goes here
    %   Detailed explanation goes here
    [h, w, ~, ~] = calculateCanvasSize(image2, A, "stitch");
    
    stitchedImage = zeros(ceil(h), ceil(w), size(image2, 3));
    
    % Add the first image to the canvas
    [h1, w1, ~] = size(image1);
    stitchedImage(1:h1, 1:w1, :) = image1;
    
    % Add the second image to the canvas (using the supplied tranformation)
    for x=1:w
        for y=1:h
            % calculate the coordinate of the pixel that would land at (x,y)
            cord = [x; y];
            oldCord = A \ [cord; 1];
            oldCord = oldCord(1:2);

            % Check if the coordinate was inside the canvas of the source image
            [xdim, ydim , ~] = size(image2);
            
            if all(oldCord > 1) && all(oldCord < [ydim; xdim])
                newColor = image2(round(oldCord(2)), round(oldCord(1)), :);
                stitchedImage(y, x, :) = newColor;
            end
        end 
    end
    
end