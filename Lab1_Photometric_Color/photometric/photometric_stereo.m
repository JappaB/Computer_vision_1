close all
clear all
clc
 
disp('Part 1: Photometric Stereo')

% obtain many images in a fixed view under different illumination
disp('Loading images...')
image_dir = 'photometrics_images/MonkeyGray';   % TODO: get the path of the script
%image_ext = '*.png';

[image_stack, scriptV] = load_syn_images(image_dir);
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);

% compute the surface gradient from the stack of imgs and light source mat
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV);
% imwrite(albedo, 'albedo_no_trick_25.png', 'png');

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map = construct_surface( p, q, 'average');

%% Display
show_results(albedo, normals, SE);
show_model(albedo, height_map);


%% Face
[image_stack, scriptV] = load_face_images('photometrics_images/yaleB02_pruned/');
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, false);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map = construct_surface( p, q, 'average');

show_results(albedo, normals, SE);
show_model(albedo, height_map);

%% Colored Monkeys

folder = 'photometrics_images/SphereColor';

[image_stack_red, scriptV_red] = load_syn_images(folder, 1);
[image_stack_green, scriptV_green] = load_syn_images(folder, 2);
[image_stack_blue, scriptV_blue] = load_syn_images(folder, 3);

[h, w, n] = size(image_stack_red);
n = n * 3;

fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')

albedo = zeros(h, w, 3);
normals = zeros(h, w, 3, 3);

[albedo(:, :, 1), normals(:, :, :, 1)] = estimate_alb_nrm(image_stack_red, scriptV_red, false);
[albedo(:, :, 2), normals(:, :, :, 2)] = estimate_alb_nrm(image_stack_green, scriptV_green, false);
[albedo(:, :, 3), normals(:, :, :, 3)] = estimate_alb_nrm(image_stack_blue, scriptV_blue, false);

% Replace NaN with 0 because otherwise avg_normals will be NaN everywhere
normals(isnan(normals)) = 0;
avg_normals = mean(normals, 4);
avg_normals = avg_normals ./ vecnorm(avg_normals, 2, 3);
%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(avg_normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map = construct_surface( p, q, 'average');

A = imread('peppers.png');
albedo(isnan(albedo)) = 0;
show_results(albedo, avg_normals, SE);
show_model(albedo, height_map);
