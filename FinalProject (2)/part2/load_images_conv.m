function [data, labels] = load_images_bow(dataset, n)
% Outputs a 4D array of n randomly sampled images  from the specified
% dataset. The images are resized to match the pre-trained model.
%   Dataset = "train" or "test"
%   n = samplesize
%   
% Retuns data -> 32x32x3x4N matrix containing all images


% Imagesets are paths to all pictures per set
imageSets_path = '../Caltech4/ImageSets/';
train_image_path = '../Caltech4/ImageData/';
sets_train = {'airplanes_train.txt','cars_train.txt','faces_train.txt','motorbikes_train.txt'};
sets_test = {'airplanes_test.txt','cars_test.txt','faces_test.txt','motorbikes_test.txt'};

if dataset == "train";
    sets = sets_train;
end

if dataset == "test";
    sets = sets_test;
end

data = zeros(32, 32, 3, 4*n, 'single');
labels = zeros(1, 4*n);

% counter for the index in data(:,:,:,im_number)
im_number = 1;

for i = 1:4
    set_paths = strcat(imageSets_path,sets{i});
    
    % randomly sample n paths to the images from this set
    all_from_set = importdata(set_paths, '\n');
    if length(all_from_set) < n;
        sample = all_from_set;
    else
        indices = randperm(length(all_from_set),n);
        sample = all_from_set(indices);
    end
    
    % Load the images and stack them in an array
    for j = 1 : length(sample)
        % First create the full path from curr dir
        path = strcat(fullfile(train_image_path,sample{j}),'.jpg');
        
        % Normalize and convert to single (network expects single)
        im = single(im2double(imread(path)));
        
        % Resize the image to 32x32 as needed for pretrained model
        % TODO: Experiment with smart ways to do this (bonus)
        % (ex. preserve aspect ratio and crop in different places)
        im = imresize(im, [32 32]);
        
        % Repeat 1-channel images 3 times in the 3rd dimension
        if size(im, 3) == 1
            im = repmat(im, [1 3]);
            im = reshape(im, [32 32 3]);
        end
        
        data(:,:,:,im_number) = im;
        labels(im_number) = i;
        im_number = im_number + 1;
    end

end

% Some indices get skipped by the loop/counter construction
% Quickfix: just remove all data with a 0 label
data = data(:,:,:,labels > 0);
labels = labels(labels > 0);

end

