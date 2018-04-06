% accuracies_path = 
% predictions_path = 
% times_path = 

% paths = ["accuracies/*","predictions/*","times/*"];
%Load all variables
clear all
files = dir('archive/stride-*.mat');
best_model.filename = "";
best_model.accuracy = 0;

for j = 1:size(files,1)
    model = load(fullfile('archive',files(j).name));
    accuracies = model.accuracies;
    avg_accuracy = mean(accuracies(1,:));
    
    if avg_accuracy > best_model.accuracy
        best_model.filename = files(j).name;
        best_model.accuracy = avg_accuracy;
    end
end

best_model.filename
best_model.accuracy

