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
%% Load unseen images for training

n_samples = 50;
[training_set, ~] = load_images_bow("train", n_samples, used_images);
[test_set, ~] = load_images_bow("test", 50, cell(1,4));

%% Quantize features and represent image by frequencies
[training_features, training_labels] = create_binary_dataset(training_set, centers, colorspace, dense);
[test_features, test_labels] = create_binary_dataset(test_set, centers, colorspace, dense);

%% Train SVM (per class)

predictions = [];
for class = [1 2 3 4]
    model = train(double(training_labels == class), sparse(training_features), '-s 0');
    [~,~,probs] = predict(double(test_labels == class), sparse(test_features), model);
    predictions = [predictions probs];
end

%% Evaluation 
