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
%% Quantize features and represent image by frequencies

% Quantize Features Using Visual Vocabulary  
% extract Sift descriptors again (from other images)
samples_per_catagory2 = 10
[image_set2, used_images2] = load_images_bow("train", samples_per_catagory, used_images)

% Initialize an empty cell array to store the hist count per catagory per
% image
histcounts_array = {};
% For each catagory, for each image
for i = 1:4;
    for j= 1: size(image_set2,2);
        
        % get the descriptors
        descriptors2 = extract_sift_features_per_image(image_set2{i,j}, colorspace, dense);

        % Project the data to the k-means clusters
        quantized_features = vl_ikmeanspush(descriptors2, centers);

        % Representing images by frequencies of visual words (normalized
        % between 0 and 1)
        normed_counts = histcounts(quantized_features,400, 'Normalization', 'probability');

        histcounts_array{i,j} = normed_counts;
        
    end
end
%% Train SVM (per class)
%nX400 feature vector and a nx1 (met [1-4]) label vector

% Unpack histcounts

[predictions, accuracy] = get_predictions(data)

best = train(data.trainset.labels, data.trainset.features, '-C -s 0');
model = train(data.trainset.labels, data.trainset.features, sprintf('-c %f -s 0', best(1))); % use the same solver: -s 0
[predictions, accuracy, ~] = predict(data.testset.labels, data.testset.features, model);


end



%% Evaluation 
