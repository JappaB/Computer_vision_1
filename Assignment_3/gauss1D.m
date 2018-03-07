function G = gauss1D( sigma , kernel_size )
    G = zeros(1, kernel_size);
    if mod(kernel_size, 2) == 0
        error('kernel_size must be odd, otherwise the filter will not have a center to convolve on')
    end
    % Compute the range
    plus_minus_range = floor(kernel_size / 2);
    kernel = (-plus_minus_range:plus_minus_range);
    
    % Compute the 1d Gaussian
    G = 1 / (sigma * sqrt(2 * pi)) * exp(- kernel .^ 2 / (2 * sigma ^ 2));
    % Normalize the filter so the intensity doesn't change
    G = G / sum(G);
    
end
