function AP = average_precision(predictions, labels)
    %AVERAGE_PRECISION calculate the average precision by ranking the
    %predictions in descending order
    
    % needed for vl_pr
    labels(labels == 0) = -1;
    
    AP = [];
    
    for class = [ 1 2 3 4 ]
        [~,~,info] = vl_pr(labels(:,class), predictions(:,class));
        AP = [AP info.ap];
    end

end

