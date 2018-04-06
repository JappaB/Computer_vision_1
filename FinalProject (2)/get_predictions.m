%SVM TRAINING
% copied from train_svm in part2
function [predictions, accuracy] = get_predictions(data)

best = train(data.trainset.labels, data.trainset.features, '-C -s 0');
model = train(data.trainset.labels, data.trainset.features, sprintf('-c %f -s 0', best(1))); % use the same solver: -s 0
[predictions, accuracy, ~] = predict(data.testset.labels, data.testset.features, model);


end
