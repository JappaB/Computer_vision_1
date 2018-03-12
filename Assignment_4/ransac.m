%% this function is a modified version of the ransac_demo() function on wikipedia

function transformation = ransac(dataIn, dataOut, sampleSize, iterationCount, threshDist, inlierRatio)
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
        M = createAffineTransformation(xy, xaya);
        
        %% Compute the total squared distances of the whole set
        
        % Convert points in homogeneous coordinate system
        transformedPoints = M * [xy; ones(1, size(xy, 2))];
            
        % and convert back
        transformedPoints(1,:) = transformedPoints(1,:) ./ transformedPoints(3,:);
        transformedPoints(2,:) = transformedPoints(2,:) ./ transformedPoints(3,:);
        
        xPointsTarget = xaya(1,:)
        yPointsTarget = xaya(2,:);
        xPointsTrans = transformedPoints(1,:)
        yPointsTrans = transformedPoints(2,:);
        
        % TODO: Analyse why there are very high values for distance
        distance = sum(sqrt((xPointsTarget - xPointsTrans).^2 + (yPointsTarget - yPointsTrans).^2))
        
        inlierIdx = find(abs(distance)<=threshDist);
        inlierNum = length(inlierIdx);
        
        %% if the total distance is the least we've seen, save the set of inliers within epsilon    
        if inlierNum>=round(inlierRatio*number) && inlierNum>bestInNum
            bestInNum = inlierNum;
            transformation = M;
        end
    end
end