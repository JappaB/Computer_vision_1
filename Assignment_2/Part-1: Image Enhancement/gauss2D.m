function G = gauss2D( sigma , kernel_size )
    % solution
    % 1D Gaussian
    G1D = gauss1D(sigma, kernel_size);
    % 2D Gaussian
    G = transpose(G1D) * G1D;
end
