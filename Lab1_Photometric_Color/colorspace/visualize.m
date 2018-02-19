function visualize(input_image)

dims = size(input_image)
if dims(3) == 3
    
    figure;
    subplot(2,2,1);
    imshow(input_image);

    subplot(2,2,2);
    imshow(input_image(:,:,1));

    subplot(2,2,3);
    imshow(input_image(:,:,2));

    subplot(2,2,4);
    imshow(input_image(:,:,3));
else
        
    figure;
    subplot(2,2,1);
    imshow(input_image(:,:,4));

    subplot(2,2,2);
    imshow(input_image(:,:,1));

    subplot(2,2,3);
    imshow(input_image(:,:,2));

    subplot(2,2,4);
    imshow(input_image(:,:,3));
end

end

