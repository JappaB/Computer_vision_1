function [ PSNR ] = myPSNR( orig_image, approx_image )
    
    % Compute MSE
    MSE = immse(orig_image, approx_image);    
    
    % Compute PSNR by formula (16)
    I_max = double(max(max(orig_image)));
    PSNR = 20 * log10( I_max / sqrt(MSE) );

end

