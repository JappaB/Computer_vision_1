%% this function is a modified version of the ransac_demo() function on wikipedia

function [transformation, inliers] = ransac(dataIn, dataOut, P, N, threshDist, inlierRatio)
    % dataIn: a 2xn dataset with #n input points
    % dataOut: a 2xn dataset with #n output points
    % P: the minimum number of points. For line fitting problem
    % N: the number of iterations
    % threshDist: the threshold of the distances between points and the fitting line
    % inlierRatio: the threshold of the number of inliers 

    number = size(dataIn,2); % Total number of points
    bestInNum = 0; % inliers of sample with most inliers
    transformation = eye(3);
    for i=1:N
        % Randomly select P points
        sampleIndices = randperm(number,P);
        
        % Compute the projection matrix with sample 
        xy = dataIn(:,sampleIndices);
        xaya = dataOut(:,sampleIndices);
        A = createAffineTransformation(xaya, xy);
            
        % Transoform ALL points (in homogeneous coordinate system)
        transformedPoints = A * [dataIn; ones(1, size(dataIn, 2))];
            
        % and convert back (not really needed for affine, last cord is 1)
        transformedPoints(1,:) = transformedPoints(1,:) ./ transformedPoints(3,:);
        transformedPoints(2,:) = transformedPoints(2,:) ./ transformedPoints(3,:);
        
        % Make coordinate vectors for input/output points
        xPointsTarget = dataOut(1,:);
        yPointsTarget = dataOut(2,:);
        xPointsTrans = transformedPoints(1,:);
        yPointsTrans = transformedPoints(2,:);
        
        % Compute the error between transformed points and location
        % of matches in the target image
        distance = hypot(xPointsTarget-xPointsTrans, yPointsTarget-yPointsTrans);
        
        % Locate and count inliers
        inlierIdx = find(abs(distance)<=threshDist);
        inlierNum = sum(inlierIdx);
        
        % if the total distance is the least we've seen, save the set of inliers within epsilon    
        if inlierNum>=round(inlierRatio*number) && inlierNum>bestInNum
            bestInNum = inlierNum;
            transformation = A;
            inliers = inlierIdx;
        end
    end
end