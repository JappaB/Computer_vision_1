function [ p, q, SE ] = check_integrability( normals )
%CHECK_INTEGRABILITY check the surface gradient is acceptable
%   normals: normal image
%   p : df / dx
%   q : df / dy
%   SE : Squared Errors of the 2 second derivatives

% initalization
p = zeros(size(normals));
q = zeros(size(normals));
SE = zeros(size(normals));

% ========================================================================
% YOUR CODE GOES HERE
% Compute p and q, where
% p measures value of df / dx
[h,w,~] = size(normals);
for r = 1:h
    for c = 1:w
        % as mentioned in the chapter: p at this point is N1/N3
        p(r,c) = normals(r,c,1)/normals(r,c,3);
        
        % and q ia N2/N3
        q(r,c) = normals(r,c,2)/normals(r,c,3);
    end
end

        



% ========================================================================



p(isnan(p)) = 0;
q(isnan(q)) = 0;

% TODO As mentioned in the chapter: check if (dp/dy-dq/dx)² is small everywhere


% ========================================================================
% YOUR CODE GOES HERE
% approximate second derivate by neighbor difference
% and compute the Squared Errors SE of the 2 second derivatives SE

[nablaX,~] = gradient(q);
[~,nablaY] = gradient(p);
SE = (nablaX-nablaY).^2;
% ========================================================================




end

