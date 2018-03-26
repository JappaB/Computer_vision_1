% Run all
% Hyperparameters

% colorspaces = ["gray", "opponent", "RGB", "normalized_rgb"] 

vl_threads
%kernel_choices = ["linear", 'rbf']

% BONUS TODO: we kunnen nog harris corner features gebruiken => is slechter maar
% sneller => tic toc opslaan

% BONUS TODO: nog k-neares neighbour ipv k-means: https://nl.mathworks.com/help/stats/knnsearch.html

clear all
close all

% Run everything for gray, use the rest for the colors
% for n_training_samples = [50,100,250,200]
%     for k = [400, 800, 1600, 2000, 4000]
%         for dense = [false, true]
for n_training_samples = [50]
    for k = [400]
        for dense = [false]    
            % Extract images
            [image_set, used_images] = load_images_bow("train", n_training_samples);

            colorspace = "gray";

            % Extract SIFT features

            tic
            descriptors = extract_sift_features(image_set, colorspace, dense);
            time_extract_features = toc


            tic
            % Cluster    
            % use elkan to speed up
            centers = vl_ikmeans(descriptors, k, 'method', 'elkan', 'verbose');
            time_to_cluster = toc
            
            [training_set, ~] = load_images_bow("train", n_training_samples, used_images);
            [test_set, ~] = load_images_bow("test", 50, cell(1,4));

            % Quantize features and represent image by frequencies
            [training_features, training_labels] = create_binary_dataset(training_set, centers, colorspace, dense);
            [test_features, test_labels] = create_binary_dataset(test_set, centers, colorspace, dense);

            % Train SVM (per class)

            predictions = [];
            accuracies = [];
            
            for class = [1 2 3 4]

                % Shuffle data
                new_order = randperm(size(training_features, 1));
                training_labels = training_labels(new_order);
                training_features = training_features(new_order,:);

                while training_labels(1,1) == class
                    new_order = randperm(size(training_features, 1));
                    training_labels = training_labels(new_order);
                    training_features = training_features(new_order,:);
                end

                model = train(double(training_labels == class), sparse(training_features), '-s 0');
                [preds,acc,probs] = predict(double(test_labels == class), sparse(test_features), model, '-b 1');
                predictions = [predictions probs(:,2)];
                accuracies = [accuracies acc];
            end
            
            filename = sprintf('predictions/n-%i_k-%i_dense-%i.mat', n_training_samples, k, dense);
            save(filename, '-mat', 'predictions');

            filename = sprintf('accuracies/n-%i_k-%i_dense-%i.mat', n_training_samples, k, dense);
            save(filename, '-mat', 'accuracies');
        end
    end
end
    