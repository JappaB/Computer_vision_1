function train_and_save_svm(n_training_samples, k, colorspace, dense, maxiters)
    [image_set, used_images] = load_images_bow("train", n_training_samples);

    % Extract SIFT features
    tic
    descriptors = extract_sift_features(image_set, colorspace, dense);
    time_extract_features = toc;

    tic
    % Cluster
    % use elkan to speed up
    if nargin > 4
        centers = vl_ikmeans(descriptors, k, 'method', 'elkan', 'verbose', 'maxiters', maxiters);
    else
        centers = vl_ikmeans(descriptors, k, 'method', 'elkan', 'verbose');
    end
    
    time_to_cluster = toc

    [training_set, ~] = load_images_bow("train", n_training_samples, used_images);
    [test_set, ~] = load_images_bow("test", 50, cell(1,4));

    % Quantize features and represent image by frequencies
    [training_features, training_labels] = create_binary_dataset(training_set, centers, colorspace, dense);
    [test_features, test_labels] = create_binary_dataset(test_set, centers, colorspace, dense);

    % Train SVM (per class)
    predictions = [];
    accuracies = [];
    binary_test_labels = [];

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
        
        binary_test_labels = [binary_test_labels test_labels == class];
        
        % save trained model
        filename = sprintf('models/stride-20_n-%i_k-%i_dense-%i_colorspace-%s-class-%i.mat', n_training_samples, k, dense, colorspace, class);
        save(filename, '-mat', 'model');
    end


    filename = sprintf('predictions/stride-20_n-%i_k-%i_dense-%i_colorspace-%s.mat', n_training_samples, k, dense, colorspace);
    save(filename, '-mat', 'predictions');

    filename = sprintf('accuracies/stride-20_n-%i_k-%i_dense-%i_colorspace-%s.mat', n_training_samples, k, dense, colorspace);
    save(filename, '-mat', 'accuracies');
    
    filename = sprintf('labels/stride-20_n-%i_k-%i_dense-%i_colorspace-%s.mat', n_training_samples, k, dense, colorspace);
    save(filename, '-mat', 'binary_test_labels');

    times = [time_extract_features, time_to_cluster];
    filename = sprintf('times/stride-20_n-%i_k-%i_dense-%i_colorspace-%s.mat', n_training_samples, k, dense, colorspace);
    save(filename, '-mat', 'times');
end

