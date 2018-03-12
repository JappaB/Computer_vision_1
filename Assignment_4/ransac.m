%% this function is a modified version of the ransac_demo() function on wikipedia

function inliers = ransac(dataIn, dataOut, sampleSize, iterationCount, threshDist, inlierRatio)
    % dataIn: a 2xn dataset with #n input points
    % dataOut: a 2xn dataset with #n output points
    % sampleSize: the minimum number of points. For line fitting problem, num=2
    % iterationCount: the number of iterations
    % threshDist: the threshold of the distances between points and the fitting line
    % inlierRatio: the threshold of the number of inliers 
 
    %% Plot the data points
    number = size(dataIn,2); % Total number of points
    smallestTotalSquareDistance = 1e15; % Best fitting set with largest number of inliers
    bestInliers = []; % inliers of sample with most inliers
    for i=1:iterationCount
        %% Randomly select 4 points
        sampleIndices = randperm(number,sampleSize);
        
        %% Compute the projection matrix with sample 
        xy = dataIn(:,sampleIndices);
        xaya = dataOut(:,sampleIndices);
        M = createProjectionMatrix(xaya, xy);
        
        %% Compute the total squared distances of the whole set
        inlierIdx = find(abs(distance)<=threshDist);
        inlierNum = length(inlierIdx);
        
        %% if the total distance is the least we've seen, save the set of inliers within epsilon    
        if inlierNum>=round(inlierRatio*number) && inlierNum>bestInNum
            bestInNum = inlierNum;
            parameter1 = (sample(2,2)-sample(2,1))/(sample(1,2)-sample(1,1));
            parameter2 = sample(2,1)-parameter1*sample(1,1);
            bestParameter1=parameter1; bestParameter2=parameter2;
        end
    end
end