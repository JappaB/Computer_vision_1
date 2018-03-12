function projectionMatrix = createProjectionMatrix (xy, uv)
    x = xy(1,:)';
    y = xy(2,:)';
    u = uv(1,:)';
    v = uv(2,:)';
    l = ones(size(x));
    o = zeros(size(x));
    
    % zelf opnieuw opgesteld
    BoddRows =  [ u, v, l, o, o, o, -x.*u, -x.*v, -x ];
    BevenRows = [ o, o, o, u, v, l, -y.*u, -y.*v, -y ];
    B = [ BoddRows; BevenRows ];
    
    [U,S,V] = svd(B);
    m = V(:,end);
    projectionMatrix = reshape(m,3,3)';
end