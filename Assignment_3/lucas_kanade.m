function lucas_kanade(image1, image2, time_step, interest_points)

% hyper params
region_size = 15;


% Convert the image to grayscale if needed

if length(size(image1)) == 3
    image1_gray = im2double(rgb2gray(image1));
    image2_gray = im2double(rgb2gray(image2));
else
    image1_gray = im2double(image1);
    image2_gray = im2double(image2);    
end 

% Divide input images on non-overlapping regions, each region being 15×15
[ rows, cols ] = size(image1_gray) %Images should be equal size
num_rows = floor(rows/region_size) % Floor (vs ceil) to prevent going out of the image
num_cols = floor(cols/region_size)

% Indices of the boundaries between regions
row_region_bounds = 1:region_size:rows;
column_region_bounds = 1:region_size:cols;


if nargin < 4  
    interest_points_rows =  (ceil(region_size/2)):region_size+1:rows
    interest_points_columns = (ceil(region_size/2)):region_size+1:cols
end

% Test plot to show boundaries of regions
figure;
imshow(image1);
hold on;
plot(column_region_bounds, row_region_bounds, 'rd');
hold off;


% 2. For each region compute A, A T and b. Then, estimate optical flow as
% given in Equation 20.



% First create a vector for the T dimension
% T = ones(rows, cols);
% T = T*time_step;

% put the two images in one 3d matrix behind each other
I = image1_gray;
I(:,:,2) = image2_gray;

% Initiate Matrix A
A = zeros(rows, cols)
b = zeros()
% Calculate for each region
for row = row_region_bounds
    for col = column_region_bounds
        % specify boundaries
        row_start = min(row,rows);
        row_stop = min(row + region_size - 1,rows);
        col_start = min(col, cols);
        col_stop = min(col + region_size -1, cols);
        
        % Partial derivatives Ix, Iy and It
        % This representation of T assumes a time step of one
        [Ix, Iy, It]= gradient(I(row_start:row_stop,col_start:col_stop,:))
        
        % If the timestep is larger than one, multiply 
        It = It*time_step;
        
        % Fill A with Ix and Iy
        A(row_start,col_start) = [Ix Iy]
        
        % Fill b
        
        
        
        
    end
end




% Matrix A, Matrix A transposed and vector b

% vector v


% 3. When you have estimation for optical flow (V x , V y ) of each region, you
% should display the results. There is a MATLAB function quiver which
% plots a set of two-dimensional vectors as arrows on the screen. Try to
% figure out how to use this to plot your optical flow results.
 



end


