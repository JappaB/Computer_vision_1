function [ height_map ] = construct_surface( p, q, path_type )
%CONSTRUCT_SURFACE construct the surface function represented as height_map
%   p : measures value of df / dx
%   q : measures value of df / dy
%   path_type: type of path to construct height_map, either 'column',
%   'row', or 'average'
%   height_map: the reconstructed surface


if nargin == 2
    path_type = 'column';
end

[h, w] = size(p);
height_map = zeros(h, w);

switch path_type
    case 'column'
        % =================================================================
        % YOUR CODE GOES HERE
        % top left corner of height_map is zero
        
        
        % for each pixel in the left column of height_map
        %   height_value = previous_height_value + corresponding_q_value
        previous_height_value = 0;
        for r = 1:h
            height_value = previous_height_value + q(r,1);
            height_map(r,1) = height_value;
            previous_height_value = height_value;
        end
        
        % for each row
        %   for each element of the row except for leftmost
        %       height_value = previous_height_value + corresponding_p_value
        for r=1:h
            previous_height_value = height_map(r, 1);
            for c=2:w
                height_value = previous_height_value + p(r, c);
                height_map(r, c) = height_value;
                previous_height_value = height_value;
            end
        end

       
        % =================================================================
               
    case 'row'
        
        % =================================================================
        % YOUR CODE GOES HERE (switched rows and columns)
        previous_height_value = 0;
        for c = 1:w
            height_value = previous_height_value + q(r,1);
            height_map(r,1) = height_value;
            previous_height_value = height_value;
        end
        
        for c=1:w
            previous_height_value = height_map(r, 1);
            for c=2:h
                height_value = previous_height_value + p(r, c);
                height_map(r, c) = height_value;
                previous_height_value = height_value;
            end
        end

        % =================================================================
          
    case 'average'
        
        % =================================================================
        % YOUR CODE GOES HERE

        
        % =================================================================
end


end

