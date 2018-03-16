function [newImage] = transformImage(inputImage,transformationMatrix)
%TRANSFORMIMAGE change the orientation of the input image according to
% the specified transformation matrix.

    % calculate size of new canvas
    [h, w, xmin, ymin] = calculateCanvasSize(inputImage, transformationMatrix, "transform")
    newImage = zeros(ceil(h), ceil(w), size(inputImage, 3));
    
    % For each pixel in the new image, calculate the pixel value of
    % the location it originated from (inverse tranformation)
    for x = 1:w
        for y = 1:h
            
            % calculate the coordinate of the pixel that would land at (x,y)
            cord = [x + xmin; y + ymin; 1];
            oldCord = transformationMatrix \ cord;
            oldCord = oldCord(1:2) ./ oldCord(3);

            % Check if the coordinate was inside the canvas of the source image
            [xdim, ydim , ~] = size(inputImage);
            
            if all(oldCord > 1) && all(oldCord < [ydim; xdim])
                newColor = inputImage(round(oldCord(2)), round(oldCord(1)), :);
                newImage(y, x, :) = newColor;
            end
            
        end 
    end
end

