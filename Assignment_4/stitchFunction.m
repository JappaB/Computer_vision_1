function stitchedImage = stitchFunction(image1,image2, A)
    %STITCHFUNCTION Summary of this function goes here
    %   Detailed explanation goes here
    [w, h] = calculateCanvasSizeStitch(image2, A);
    
    stitchedImage = zeros(ceil(h), ceil(w), size(image2, 3));
    
    for x=1:h
        for y=1:w
            % calculate the coordinate of the pixel that would land at (x,y)
            cord = [x; y; 1];
            oldCord = A \ cord;
            oldCord = oldCord(1:2) ./ oldCord(3);

            % Check if the coordinate was inside the canvas of the source image
            [xdim, ydim , ~] = size(image2);
            
            if all(oldCord > 1) && all(oldCord < [xdim; ydim])
                newColor = image2(round(oldCord(1)), round(oldCord(2)), :);
                stitchedImage(x, y, :) = newColor;
            end
        end 
    end
end

