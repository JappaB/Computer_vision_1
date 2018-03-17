function affineTransformation = createAffineTransformation (uv, xy)

    % Prepare vectors
    x = xy(1,:)';
    y = xy(2,:)';
    u = uv(1,:)';
    v = uv(2,:)';
    l = ones(size(x));
    o = zeros(size(x));
    
    % Define system of equations
    AoddRows =  [ x, y, l, o, o, o ];
    AevenRows = [ o, o, o, x, y, l ];
    A = [ AoddRows; AevenRows ];
    b = [ u; v];
    
    % Solve
    x = pinv(A) * b;
    
    % Change to homogenous coordinate matrix
    affineTransformation = reshape(x, 3, 2)';
    affineTransformation = [affineTransformation; 0 0 1];
end