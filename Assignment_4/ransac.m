%% this function is a modified version of the ransac_demo() function on wikipedia

function [transformation, inliers] = ransac(dataIn, dataOut, sampleSize, iterationCount, threshDist, inlierRatio)
    % dataIn: a 2xn dataset with #n input points
    % dataOut: a 2xn dataset with #n output points
    % sampleSize: the minimum number of points. For line fitting problem, num=2
    % iterationCount: the number of iterations
    % threshDist: the threshold of the distances between points and the fitting line
    % inlierRatio: the threshold of the number of inliers 
 
    %% Plot the data points
    number = size(dataIn,2); % Total number of points
    bestInNum = 0; % inliers of sample with most inliers
    transformation = eye(3);
    for i=1:iterationCount
        %% Randomly select 4 points
        sampleIndices = randperm(number,sampleSize);
        
        %% Compute the projection matrix with sample 
        xy = dataIn(:,sampleIndices);
        xaya = dataOut(:,sampleIndices);

%         createProjectionMatrix heeft teveel degrees of freedom voor dit
%         probleem.. Komt pas van pas bij stitching geloof ik. Het kan ook
%         met projective, maar volgens de opdracht moet het met affine.
%         M = createProjectionMatrix(xaya, xy);
        M = createAffineTransformation(xaya, xy);
        %% Compute the total squared distances of the whole set
        
        % Convert points in homogeneous coordinate system
        transformedPoints = M * [dataIn; ones(1, size(dataIn, 2))];
            
        % and convert back (not needed for affine, last cord is 1)
        transformedPoints(1,:) = transformedPoints(1,:) ./ transformedPoints(3,:);
        transformedPoints(2,:) = transformedPoints(2,:) ./ transformedPoints(3,:);
        
        xPointsTarget = dataOut(1,:);
        yPointsTarget = dataOut(2,:);
        xPointsTrans = transformedPoints(1,:);
        yPointsTrans = transformedPoints(2,:);
        
        % TODO: Analyse why there are very high values for distance
        distance = hypot(xPointsTarget-xPointsTrans, yPointsTarget-yPointsTrans);
        
        inlierIdx = find(abs(distance)<=threshDist);
        inlierNum = sum(inlierIdx);
        
        %% if the total distance is the least we've seen, save the set of inliers within epsilon    
        if inlierNum>=round(inlierRatio*number) && inlierNum>bestInNum
            bestInNum = inlierNum;
            transformation = M;
            inliers = inlierIdx;
        end
    end
end