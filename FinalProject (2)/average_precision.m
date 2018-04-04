function AP = average_precision(model_name)
    predictions = load(fullfile('predictions', model_name)); predictions = predictions.predictions;
    labels = load(fullfile('labels', model_name)); labels = labels.binary_test_labels;
    
    % needed for vl_pr
    labels(labels == 0) = -1;
    
    AP = [];
    
    for class = [ 1 2 3 4 ]
        [~,~,info] = vl_pr(labels(:,class), predictions(:,class));
        AP = [AP info.ap];
    end
    
    filename = sprintf('average_precision/%s.mat', model_name);
    save(filename, '-mat', 'AP');

end

