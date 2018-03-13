function affineTransformation = createAffineTransformation (uv, xy)
    x = xy(1,:)';
    y = xy(2,:)';
    u = uv(1,:)';
    v = uv(2,:)';
    l = ones(size(x));
    o = zeros(size(x));
    
    % zelf opnieuw opgesteld
    AoddRows =  [ x, y, o, o, l, o ];
    AevenRows = [ o, o, x, y, o, l ];
    A = [ AoddRows; AevenRows ];
    b = [u v];
    b = reshape(b', [], 1);
    x = pinv(A) * b;
    
    affineTransformation = reshape(x,2,3);
    affineTransformation = [affineTransformation; 0 0 1];
end