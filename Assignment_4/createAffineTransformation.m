function affineTransformation = createAffineTransformation (uv, xy)
    x = xy(1,:)';
    y = xy(2,:)';
    u = uv(1,:)';
    v = uv(2,:)';
    l = ones(size(x));
    o = zeros(size(x));
    
    AoddRows =  [ x, y, l, o, o, o ];
    AevenRows = [ o, o, o, x, y, l ];
    A = [ AoddRows; AevenRows ];
    b = [ u; v];
    x = pinv(A) * b;
    
    affineTransformation = reshape(x, 3, 2)';
    affineTransformation = [affineTransformation; 0 0 1];
end