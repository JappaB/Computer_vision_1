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
        nets.fine_tuned = load(fullfile('models','batch-%i_epoch-%i', 'net-epoch-50.mat')); nets.fine_tuned = nets.fine_tuned.net;
        nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net; 
        data = load(fullfile(expdir, 'imdb-caltech.mat'));

        % NB: liblinear-2.1 should be added to path, otherwise train/predict
        % are not known by matlab
        train_svm(nets, data);
    end
end



