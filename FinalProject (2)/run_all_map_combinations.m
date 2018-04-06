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
    train_and_save_svm(n_training_samples, k, colorspace, dense);
end

% Vary k
dense = false;
n_training_samples = 50;
colorspace = "gray";

% k = 400 has already been run for this setting
for k = [800 1600 2000]
   train_and_save_svm(n_training_samples, k, colorspace, dense, 500);
end

% Vary n
k = 400;
dense = false;
colorspace = "gray";

% n = 50 has already been run in this setting
for n_training_samples = [ 100 200 250 ]
    train_and_save_svm(n_training_samples, k, colorspace, dense);
end
%%

dense = 0;
k = 800;
n = 100;
colorspace="gray";

train_and_save_svm(n, k, colorspace, dense);

%% MSER -----
k = 400;
n_training_samples = 50;

for colorspace = ["opponent", "RGB", "gray", "normalized_rgb"]
    train_and_save_bonus_parts(n_training_samples, k, colorspace);
end

