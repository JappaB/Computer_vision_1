% accuracies_path = 
% predictions_path = 
% times_path = 

% paths = ["accuracies/*","predictions/*","times/*"];
%Load all variables
clear all
files = dir('**/*.mat');
disp(files)
settings = {}
for j = 1:size(files,1);
    disp(j)
    filename = (strcat(files(j).folder,'/',files(j).name))
%     filename = strcat(files(j).folder,files(j).name)
%     load(filename);
    settings{j} = load(filename)
end

