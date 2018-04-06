function [features, labels] = create_binary_dataset_MSER( image_set, centers, colorspace )
    %CREATE_BINARY_DATASET matrix containing the MSER features for
    % the images in image_set
    % Quantize Features Using Visual Vocabulary  

% Initialize an empty arrays to store the hist count and labels
labels = [];
features = [];

% For each catagory, for each image
for i = 1:size(image_set, 1)
    for j= 1:size(image_set, 2)
        
        % get the descriptors
        descriptors = extract_MSER_features_per_image(image_set{i,j}, colorspace);

        % Project the data to the k-means clusters
        quantized_features = vl_ikmeanspush(descriptors, centers);

        % Representing images by frequencies of visual words (normalized
        % between 0 and 1)
        normed_counts = histcounts(quantized_features, size(centers, 2), 'Normalization', 'count');

        features = [features; normed_counts];
        labels = [labels; i];
    end
end
    
end