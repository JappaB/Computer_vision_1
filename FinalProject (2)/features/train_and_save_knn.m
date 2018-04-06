files = dir('stride-*.mat');
for j = 1:size(files,1)
    featurespacename = files.name
    features = load(files(j).name);
    
%     features = {training_features,training_labels,test_features,test_labels}

    % Train KNN (per class)
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
        filename = sprintf('models/%s-class-%i_knn.mat', featurespacename, class);
        save(filename, '-mat', 'model');
    end
    
    AP = average_precision(predictions, binary_test_labels);
    filename = sprintf('average_precision/%s_knn.mat', featurespacename);
    save(filename, '-mat', 'AP');

    filename = sprintf('predictions/%s_knn.mat', featurespacename);
    save(filename, '-mat', 'predictions');

    filename = sprintf('accuracies/%s_knn.mat', featurespacename);
    save(filename, '-mat', 'accuracies');
    
    filename = sprintf('labels/%s_knn.mat', featurespacename);
    save(filename, '-mat', 'binary_test_labels');

    times = [time_extract_features, time_to_cluster];
    filename = sprintf('times/%s_knn.mat', featurespacename);
    save(filename, '-mat', 'times');
    
    all_features = {training_features,training_labels,test_features,test_labels}
    filename = sprintf('features/%s_knn.mat', featurespacename);
    save(filename, '-mat', 'all_features');
end