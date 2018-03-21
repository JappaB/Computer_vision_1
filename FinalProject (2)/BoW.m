%% Load images
% Load images
clear all
close all


samples_per_catagory = 10
[image_set, used_images] = load_images_bow("train", samples_per_catagory)

%https://dsp.stackexchange.com/questions/14616/what-is-the-output-of-bow-after-an-image-has-been-trained-with-sift-algorithm-an

%% Get Sift descriptors

colorspace = "gray";
dense = false;
descriptors = extract_sift_features(image_set, colorspace, dense);

%% Build Visual Vocabulary
k = 400;

% Tic toc to time how long it takes to run
tic
% use elkan to speed up
centers = vl_ikmeans(descriptors, k, 'method', 'elkan', 'verbose');
toc

% Sample a part of the features, so k-means can converge

%% Quantize Features Using Visual Vocabulary
% other option: dsearchn (nearest neighbour)

% extract Sift descriptors again (from other images)
samples_per_catagory2 = 10
[image_set2, used_images2] = load_images_bow("train", samples_per_catagory, used_images)
descriptors2 = extract_sift_features(image_set2, colorspace, dense);

% Project the data to the k-means clusters
quantized_features = vl_ikmeanspush(descriptors2, centers);


%% Representing images by frequencies of visual words
% hist count (bow)



%% Classification (SVM)

%% Evaluation 
