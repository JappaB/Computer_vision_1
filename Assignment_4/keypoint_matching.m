function [fa, fb, matchIdx] = keypoint_matching( image1, image2 )
    %KEYPOINT_MATCHING find matching interest points between
    % image1 and image2

    % The matrix f has a column for each frame
    % A frame is a disk of center f(1:2), scale f(3) and orientation f(4)
    [fa, da] = vl_sift(image1) ;
    [fb, db] = vl_sift(image2) ;

    % matches is an array with indices of the matching interest points
    % dim(1) = fa; dim(2) = fb
    [matchIdx, ~] = vl_ubcmatch(da, db) ;
end
