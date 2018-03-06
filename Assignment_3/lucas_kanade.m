function [Vx Vy] = lucas_kanade(image1, image2, time_step, i_r, i_c)

% hyper params
region_size = 15;
boundary_offset = region_size - ceil(region_size/2);

% Convert the image to grayscale if needed

if length(size(image1)) == 3
    image1_gray = im2double(rgb2gray(image1));
    image2_gray = im2double(rgb2gray(image2));
else
    image1_gray = im2double(image1);
    image2_gray = im2double(image2);    
end 

% Divide input images on non-overlapping regions, each region being 15×15
[ rows, cols ] = size(image1_gray); %Images should be equal size
num_rows = floor(rows/region_size); % Floor (vs ceil) to prevent going out of the image
num_cols = floor(cols/region_size);

% Define hard-coded regions to track
if nargin < 4
    % define diagonal [ a b c ], [ a b c ]
    i_r = ((ceil(region_size/2)):region_size+1:rows)';
    i_c = ((ceil(region_size/2)):region_size+1:cols);
    
    % repeat the row indices and reshape to [a a a b b b c c c]
    region_centers_row = repmat(i_r, 1, num_rows)';
    region_centers_row = region_centers_row(:)';
    
    % repeat the col indices and reshape to [a b c a b c a b c]
    region_centers_col = repmat(i_c, 1, num_cols)';
    region_centers_col = region_centers_col(:)';
end

% Test plot to show boundaries of regions
figure;
imshow(image1);
hold on;
plot(region_centers_col, region_centers_row, 'rd');
hold off;

% 2. For each region compute A, A T and b. Then, estimate optical flow as
% given in Equation 20.

% First create a vector for the T dimension
% T = ones(rows, cols);
% T = T*time_step;

% put the two images in one 3d matrix behind each other
I = image1_gray;
I(:,:,2) = image2_gray;

% Calculate for each region
for row = region_centers_row
    for col = region_centers_col
        
        % specify boundaries
        row_start = min(row - boundary_offset,rows);
        row_stop = min(row + boundary_offset-1,rows);
        col_start = min(col - boundary_offset, cols);
        col_stop = min(col + boundary_offset-1, cols);
        
        % Partial derivatives Ix, Iy and It
        % This representation of T assumes a time step of one
        [Ix, Iy, It] = gradient(I(row_start:row_stop,col_start:col_stop,:));
        
        % If the timestep is larger than one, multiply 
        It = It*time_step;
        
        % Unroll gradient intensities to create 1D vectors 
        Ix = Ix(:);
        Iy = Iy(:);
        It = It(:);
        
        % Build elements of system to solve
        A = [Ix Iy];
        b = -It;
        
        % Solve the equation using the pseudo-inverse of A
        V = pinv(A) * b
        
        % TODO: Assign V(1) and V(2) to vectors OUTSIDE of the loop
        Vx = V(1);
        Vy = V(2);
                
        end
end




% Matrix A, Matrix A transposed and vector b

% vector v


% 3. When you have estimation for optical flow (V x , V y ) of each region, you
% should display the results. There is a MATLAB function quiver which
% plots a set of two-dimensional vectors as arrows on the screen. Try to
% figure out how to use this to plot your optical flow results.
 



end


