function train_and_save_bonus_parts(n_training_samples, k, colorspace, maxiters)
    [image_set, used_images] = load_images_bow("train", n_training_samples);

    % Extract MSER features
    tic
    descriptors = extract_MSER_features(image_set, colorspace);
    time_extract_features = toc;

    tic
    % Cluster
    % use elkan to speed up
    if nargin > 3
        centers = vl_ikmeans(descriptors, k, 'method', 'elkan', 'verbose', 'maxiters', maxiters);
    else
        centers = vl_ikmeans(descriptors, k, 'method', 'elkan', 'verbose');
    end
    
    time_to_cluster = toc

    [training_set, ~] = load_images_bow("train", n_training_samples, used_images);
    [test_set, ~] = load_images_bow("test", 50, cell(1,4));

    % Quantize features and represent image by frequencies
    [training_features, training_labels] = create_binary_dataset_MSER(training_set, centers, colorspace);
    [test_features, test_labels] = create_binary_dataset_MSER(test_set, centers, colorspace);

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

        % Train classifier for this class
        model = train(double(training_labels == class), sparse(training_features), '-s 0');
        [~,acc,probs] = predict(double(test_labels == class), sparse(test_features), model, '-b 1');
        predictions = [predictions probs(:,2)];
        accuracies = [accuracies acc];

        binary_test_labels = [binary_test_labels test_labels == class];

        % save trained model
        filename = sprintf('models/stride-20_n-%i_k-%i-_colorspace-%s-class-%i2.mat', n_training_samples, k, colorspace, class);
        save(filename, '-mat', 'model');
    end

    % Save AP
    AP = average_precision(predictions, binary_test_labels);
    filename = sprintf('average_precision/stride-20_n-%i_k-%i_colorspace-%s-MSER2.mat', n_training_samples, k, colorspace);
    save(filename, '-mat', 'AP');

    % Save predictions
    filename = sprintf('predictions/stride-20_n-%i_k-%i_colorspace-%s_MSER2.mat', n_training_samples, k, colorspace);
    save(filename, '-mat', 'predictions');

    % Save accuracies
    filename = sprintf('accuracies/stride-20_n-%i_k-%i_colorspace-%s_MSER2.mat', n_training_samples, k, colorspace);
    save(filename, '-mat', 'accuracies');

    % Save labels
    filename = sprintf('labels/stride-20_n-%i_k-%i_colorspace-%s_MSER2.mat', n_training_samples, k, colorspace);
    save(filename, '-mat', 'binary_test_labels');
% 
%     % Save execution times
%     times = [time_extract_features, time_to_cluster];
%     filename = sprintf('times/stride-20_n-%i_k-%i_colorspace-%s_MSER2.mat', n_training_samples, k, colorspace);
%     save(filename, '-mat', 'times');

    % Save features
%     all_features = {training_features,training_labels,test_features,test_labels}
%     filename = sprintf('features/stride-20_n-%i_k-%i_colorspace-%s_MSER2.mat', n_training_samples, k, colorspace);
%     save(filename, '-mat', 'all_features');


end
