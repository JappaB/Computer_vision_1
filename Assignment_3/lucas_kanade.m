function lucas_kanade(image1, image2, time_step, interest_points)

% hyper params
region_size = 15;


% Convert the image to grayscale if needed

if length(size(image1)) == 3
    image1_grey = im2double(rgb2gray(image1));
    image2_grey = im2double(rgb2gray(image2));
else
    image1_grey = im2double(image1);
    image2_grey = im2double(image2);    
end 

% Divide input images on non-overlapping regions, each region being 15×15
[ rows, cols ] = size(image1_grey) %Images should be equal size
num_rows = floor(rows/region_size) % Floor (vs ceil) to prevent going out of the image
num_cols = floor(cols/region_size)

% Indices of the boundaries between regions
x_region_bounds = 1:region_size:rows;
y_region_bounds = 1:region_size:cols;


% if nargin < 3  
%     interest_points = 
% else
%     
% end

% Test plot to show boundaries of regions
figure;
imshow(image1);
hold on;
scatter(x_region_bounds,y_region_bounds);


% 2. For each region compute A, A T and b. Then, estimate optical flow as
% given in Equation 20.

% First create a vector for the T dimension
T = ones(rows, cols);
T = T*time_step;

% Partial derivatives Ix, Iy and It


% Matrix A, Matrix A transposed and vector b

% vector v


% 3. When you have estimation for optical flow (V x , V y ) of each region, you
% should display the results. There is a MATLAB function quiver which
% plots a set of two-dimensional vectors as arrows on the screen. Try to
% figure out how to use this to plot your optical flow results.
 



end


