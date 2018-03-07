function [Vx, Vy, i_r, i_c] = lucas_kanade(image1, image2, time_step, i_r, i_c)


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

[ rows, cols ] = size(image1_gray); %Images should be equal size

% Define hard-coded regions to track
if nargin < 4
    % Divide input images on non-overlapping regions, each region being 15×15
    num_rows = floor(rows/region_size); % Floor (vs ceil) to prevent going out of the image
    num_cols = floor(cols/region_size);

    % define diagonal [ a b c ], [ a b c ]
    i_r = ((ceil(region_size/2)):region_size+1:rows)';
    i_c = ((ceil(region_size/2)):region_size+1:cols);
    
    % repeat the row indices and reshape to [a a a b b b c c c]
    i_r = repmat(i_r, 1, num_rows)';
    i_r = i_r(:)';
    
    % repeat the col indices and reshape to [a b c a b c a b c]
    i_c = repmat(i_c, 1, num_cols)';
    i_c = i_c(:)';
end

% Test plot to show boundaries of regions
% figure;
% imshow(image1);
% hold on;
% plot(region_centers_col, region_centers_row, 'rd');
% hold off;

% 2. For each region compute A, A T and b. Then, estimate optical flow as
% given in Equation 20.

% First create a vector for the T dimension
% T = ones(rows, cols);
% T = T*time_step;

% put the two images in one 3d matrix behind each other
I = image1_gray;
I(:,:,2) = image2_gray;

[Ix,Iy,It] = gradient(I);
Ix = Ix(:,:,1);
Iy = Iy(:,:,1);
It = It(:,:,1);

n_points = size(i_c, 1);

% Initiate V, for each pixel in the x and the y direction
Vx = zeros(n_points);
Vy = zeros(n_points);

i = 1;
% Calculate for each region
for idx = [i_r; i_c]

    % Ensure coords are integers
    row = round(idx(1));
    col = round(idx(2));
    
    % specify boundaries
    row_start = min(max(1, row - boundary_offset),rows);
    row_stop = min(row + boundary_offset-1,rows);
    col_start = min(max(1, col - boundary_offset), cols);
    col_stop = min(col + boundary_offset-1, cols);

    % Create window arround gradients
    windowIx = Ix(row_start:row_stop,col_start:col_stop);
    windowIy = Iy(row_start:row_stop,col_start:col_stop);
    windowIt = It(row_start:row_stop,col_start:col_stop);

    % If the timestep is larger than one, multiply 
    windowIt = windowIt*time_step;

    % Unroll gradient intensities to create 1D vectors 
    windowIx = windowIx(:);
    windowIy = windowIy(:);
    windowIt = windowIt(:);

    % Build elements of system to solve
    A = [windowIx windowIy];
    b = -windowIt;

    % Solve the equation using the pseudo-inverse of A
    V = pinv(A) * b;

    % Find index of interest point
    x = find(i_r==row);
    y = find(i_c==col);
    
    % Assign V(1) and V(2) to vectors OUTSIDE of the loop        
    Vx(i) = V(1);
    Vy(i) = V(2);
    
    i = i + 1;
end



% 3. When you have estimation for optical flow (V x , V y ) of each region, you
% should display the results. There is a MATLAB function quiver which
% plots a set of two-dimensional vectors as arrows on the screen. Try to
% figure out how to use this to plot your optical flow results.

% size(region_centers_col)
% size(region_centers_row)
% size(Vx)
% size(Vy)

end


