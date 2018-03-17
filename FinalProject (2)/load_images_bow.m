function [image_set] = load_images_bow(dataset, n)
% Outputs a struct of the n randomly sampled images from the specified
% dataset
%   Dataset = 'train' or 'test'
%   n = samplesize
%   


% Imagesets are paths to all pictures per set
imageSets_path = 'Caltech4/ImageSets/';
train_image_path = 'Caltech4/ImageData/';
sets_train = {'airplanes_train.txt','cars_train.txt','faces_train.txt','motorbikes_train.txt'};
sets_test = {'airplanes_test.txt','cars_test.txt','faces_test.txt','motorbikes_test.txt'};

if dataset == "train";
    sets = sets_train;
end

if dataset == "test";
    sets = sets_test;
end

%Init cell aray to store images
image_set = {};
for i = 1:4;
    set_paths = strcat(imageSets_path,sets{i})
    
    % randomly sample n paths to the images from this set
    all_from_set = importdata(set_paths, '\n');
    if length(all_from_set) < n;
        sample = all_from_set
    else
        indices = randperm(length(all_from_set),n);
        sample = all_from_set(indices)
    end
    
    % Load the images and stack them in an array
    for j = 1 : length(sample);
        % First create the full path from curr dir
        path = strcat(fullfile(train_image_path,sample{j}),'.jpg');
        im = im2double(imread(path));
        image_set{i, j} = im;
    end

end
end

