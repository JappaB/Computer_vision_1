%% this function is a modified version of the ransac_demo() function on wikipedia

function [transformation, inliers] = ransac(dataIn, dataOut, P, N, threshDist, inlierRatio, im1, im2)
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
        transformedPoints(1:2,:) = transformedPoints(1:2,:) ./ transformedPoints(3,:);
        
        % Make coordinate vectors for input/output points
        xPointsTarget = dataOut(1,:);
        yPointsTarget = dataOut(2,:);
        xPointsTrans = transformedPoints(1,:);
        yPointsTrans = transformedPoints(2,:);
        
        if i==0
            [r, c] = size(im1)
            [r2, c2] = size(im2)
            padr = max(0, r-r2);
            padc = max(0, c-c2);
            im2 = padarray(im2, [padr padc], 0, 'pre');
            size(im2)
            figure;
            imshow([im1 im2]);
            hold on
            %Plot the lines
            for j = 1:size(transformedPoints, 2)
                p1 = [dataIn(2, j), dataIn(1, j)];
                p2 = [yPointsTrans(j),xPointsTrans(j)];
                plot([p1(2),p2(2)] + padc,[p1(1),p2(1)] + padr,'color','r','LineWidth',2);
            end
        end
        
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
            
            [r, c] = size(im1)
            [r2, c2] = size(im2)
            padr = max(0, r-r2);
            padc = max(0, c-c2);
            im2 = padarray(im2, [0 padc], 0, 'pre');
            im2 = padarray(im2, [padr 0], 0, 'post');
            size(im2)
            figure;
            imshow([im1 im2]);
            hold on
            
            %Plot the lines
            for j = randperm(size(xPointsTrans, 2), 20)
                p1 = [dataIn(2, j), dataIn(1, j)];
                p2 = [yPointsTrans(j),xPointsTrans(j)] + [0, padc + c];
                plot([p1(2),p2(2)],[p1(1),p2(1)],'color','r','LineWidth',2);
            end
    end
end