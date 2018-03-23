% Run all
% Hyperparameters
n_training_samples = [50,100,250,200]
% colorspaces = ["gray", "opponent", "RGB", "normalized_rgb"] 
colorspaces = ["gray"]
vocabulary_sizes = [400, 800, 1600, 2000, 4000] % k
dense_or_not = [false, true]

vl_threads
%kernel_choices = ["linear", 'rbf']

% BONUS TODO: we kunnen nog harris corner features gebruiken => is slechter maar
% sneller => tic toc opslaan

% BONUS TODO: nog k-neares neighbour ipv k-means: https://nl.mathworks.com/help/stats/knnsearch.html

clear all
close all

% Run everything for gray, use the rest for the colors
for i = 1:size(n_training_samples,1);
    samples_per_catagory = n_training_samples(i)
    
    % Extract images
    [image_set, used_images] = load_images_bow("train", samples_per_catagory)
    
    for j = 1:size(colorspaces,1);
        for k = 1:size(dense_or_not,1);  
            colorspace = colorspaces(j)
            dense = dense_or_not(k)
            
            % Extract SIFT features
            
            tic
            descriptors = extract_sift_features(image_set, colorspace, dense);
            time_extract_features = toc
            
            
            for l = 1:size(vocabulary_sizes,1);
                vocabulary_size = vocabulary_sizes(l) % k   
                
                tic
                % Cluster    
                % use elkan to speed up
                centers = vl_ikmeans(descriptors, k, 'method', 'elkan', 'verbose');
                time_to_cluster = toc
                
                
%               build vocabulary
                
                
                for m = 1:size(kernel_choices,1);
                    

                    % Train SVM
                    kernel_choice = kernel_choices(m)
                                     
                    % Classify test images and calculate 
                    
                    % For each descriptor type (combination of step-size
                    
                    
                    
                    % Doe sprintf voor de variable name en sla op als .mat
                    % (save('A.MAT','A')
                    
                    
                    % Write the times to an excel file
                    xlswrite(filename,M)
                    % Write the scores per image per SVM-classifier (with the hyerparameters) to an
                    % excel 
                    % file
                    
                    % Write 
                    
                end
            end
        end
    end
end
    