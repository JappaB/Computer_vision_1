function [ imOut ] = denoise( image, kernel_type, varargin)

switch kernel_type
    case 'box'
        if length(varargin) == 1
            box_size = varargin{1};
        elseif isempty(varargin)
            % matlab default
            box_size = 3;
        else
            fprintf("This kernel optionally takes 1 argument, 2 or more were supplied.")
            return
        end
        
        imOut = imboxfilt(image, box_size);
        
    case 'median'
        
        if length(varargin) == 1
            neigborhood_dims = varargin{1};
        elseif isempty(varargin)
            % matlab default
            neighborhood_dims = [3 3];
        else
            fprintf("This kernel optionally takes 1 argument, 2 or more were given.")
            return
        end
        
        imOut = medfilt2(image, neigborhood_dims);
        
    case 'gaussian'
        
        if isempty(varargin)
            fprintf("This kernel requires 2 input arguments, none were given.");
            return
        else
            sigma = varargin{1};
            kernel_size = varargin{2};
        end
        
        imOut = imfilter(image, gauss2D(sigma, kernel_size));
%         imOut = imgaussfilt(image, sigma, 'FilterSize', kernel_size);
        
end
end
