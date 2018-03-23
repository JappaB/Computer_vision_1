%% fine-tune cnn
clear all

for batchSize=[50 100]
    for numEpochs=[40 80 100]
        [net, info, expdir] = finetune_cnn(batchSize, numEpochs);
    end
end
%% extract features and train svm

for batchSize=[50 100]
    for numEpochs=[40 80 100]
        % TODO: Replace the name with the name of your fine-tuned model
        model_setting = sprintf('batch-%i_epochs-%i', batchSize, numEpochs);
        last_epoch = sprintf('net-epoch-%i.mat', numEpochs);
        nets.fine_tuned = load(fullfile('models',model_setting, last_epoch)); nets.fine_tuned = nets.fine_tuned.net;
        nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net; 
        data = load(fullfile('data/cnn_assignment-lenet', 'imdb-caltech.mat'));

        % NB: liblinear-2.1 should be added to path, otherwise train/predict
        % are not known by matlab
        train_svm(nets, data);
    end
end

%% T-SNE batchSize = 50; numEpochs = 40;

data = load(fullfile('data/cnn_assignment-lenet', 'imdb-caltech.mat'));

fine_reduced = reduce_features(data, 'models/batch-50_epochs-40/net-epoch-40.mat');
pre_reduced = reduce_features(data, 'data/pre_trained_model.mat');

%% Visualze reduced vectors

training_set = data.images.set == 1;
test_set = data.images.set == 2;

labels = [data.images.labels(1, training_set) data.images.labels(1, test_set)];
labels = transpose(labels);

subplot(2,1,1); title('Fine-tuned features');
gscatter(fine_reduced(:,1), fine_reduced(:,2), labels);
subplot(2,1,2); title('Pre-trained features');
gscatter(pre_reduced(:,1), pre_reduced(:,2), labels);
