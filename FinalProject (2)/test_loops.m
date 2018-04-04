% Run all
% Hyperparameters

vl_threads

% BONUS TODO: we kunnen nog harris corner features gebruiken => is slechter maar
% sneller => tic toc opslaan

% BONUS TODO: nog k-neares neighbour ipv k-means: https://nl.mathworks.com/help/stats/knnsearch.html

clear all
close all


% Vary Dense/Keypoint
k = 400;
n_training_samples = 50;
colorspace = "gray";
for dense = [false true]
    dense, n_training_samples, k, colorspace
end

% Vary k
dense = false;
n_training_samples = 50;
colorspace = "gray";
for k = [400 800 1600 2000]
   dense, n_training_samples, k, colorspace
end


% Vary n
k = 400;
dense = false;
colorspace = "gray";
for n_training_samples = [ 50 100 200 250 ]
    dense, n_training_samples, k, colorspace
end


% Vary Colorspace
k = 400;
n_training_samples = 50;
dense = false;
for colorspace = ["gray", "opponent", "RGB", "normalized_rgb"]
    dense, n_training_samples, k, colorspace
end
