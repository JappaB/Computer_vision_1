function X = reduce_features( data, path_to_net )
    % REDUCE_FEATURES runs T-SNE with default parameters on the provided data set.
    % if labels = [], no intermediate results are plotted

    % Load network
    net = load(path_to_net);
    net = net.net;

    % set loss function to softmax, because we are just evaluating
    % loaded setting requires labels
    net.layers{end}.type = 'softmax';
    
    % get final layer activations 
    [training, test] = get_svm_data(data, net);
    
    % concatenate features
    features = [training.features; test.features];
    labels = [training.labels; test.labels];

    X = tsne(full(features), labels);
end