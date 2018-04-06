% Run all
% Hyperparameters

vl_threads


clear all
close all
%
% runAt = datetime(2018, 3, 30, 23, 59, 0);
%
% while datetime < runAt
%     ;
% end

% Run everything for gray, use the rest for the colors
% for k = [400, 800, 1600, 2000, 4000]
%     for n_training_samples = [200, 250]
%         for dense = [false, true]
for colorspace = ["opponent", "RGB", "normalized_rgb"]
    %best hyperparameters
    n_training_samples = 100;
    dense = true;
    k=800;
    
    [image_set, used_images] = load_images_bow("train", n_training_samples);

    % Extract SIFT features
    tic
    descriptors = extract_sift_features(image_set, colorspace, dense);
    time_extract_features = toc;


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


    filename = sprintf('predictions/stride-20_n-%i_k-%i_dense-%i-colorspace-%i.mat', n_training_samples, k, dense, colorspace);
    save(filename, '-mat', 'predictions');

    filename = sprintf('accuracies/stride-20_n-%i_k-%i_dense-%i-colorspace-%i.mat', n_training_samples, k, dense, colorspace);
    save(filename, '-mat', 'accuracies');

    times = [time_extract_features, time_to_cluster]
    filename = sprintf('times/stride-20_n-%i_k-%i_dense-%i-colorspace-%i.mat', n_training_samples, k, dense, colorspace);
    save(filename, '-mat', 'times');
end
