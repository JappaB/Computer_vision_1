function imOut = compute_LoG(image, LOG_type)
    switch LOG_type
        case 1
            gauss2_kernel = gauss2D(1/2,5);
            smoothed_im = conv2(gauss2_kernel,image);
            imOut = del2(smoothed_im);
        case 2
            filter = fspecial('log');
            imOut = conv2(image, filter);
        case 3
            %Differnce of gaussians
            DoG1 = fspecial('gaussian', [5 5], 1);
            DoG2 = fspecial('gaussian', [5 5], 2);
            filter = DoG1-DoG2;
            imOut = conv2(image, filter);
    end
end

