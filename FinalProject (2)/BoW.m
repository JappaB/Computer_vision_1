%% Load images
% Load images
clear all
close all


samples_per_catagory = 5
image_set = load_images_bow("train", samples_per_catagory)


%% Get Sift descriptors

colorspace = "opponent";
features = extract_sift_features(image_set, colorspace, false);

%% Build Visual Vocabulary

% For all imagesets
    % For all images