function newImage = transformImage(inputImage,transformationMatrix)
%TRANSFORMIMAGE change the orientation of the input image according to
% the specified transformation matrix.

    % calculate size of new canvas
    [h, w, xmin, ymin] = calculateCanvasSize(inputImage, transformationMatrix)
    newImage = zeros(ceil(w), ceil(h));

    % For each pixel in the new image, calculate the pixel value of
    % the location it originated from (inverse tranformation)
    for x = 1:size(newImage, 2)
        for y = 1:size(newImage, 1)
            % calculate the coordinate of the pixel that would land at (x,y)
            cord = [x - xmin; y - ymin; 1];
            oldCord = transformationMatrix \ cord;
            oldCord = oldCord(1:2) ./ oldCord(3);

            % Check if the coordinate was inside the canvas of the source image
            if all(oldCord > 1) & all(oldCord < size(inputImage))
                newImage(x, y) = inputImage(round(oldCord(1)), round(oldCord(2)));
            end
        end 
    end
end

