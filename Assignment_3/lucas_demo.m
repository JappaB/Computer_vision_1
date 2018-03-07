function lucas_demo(image1,image2)
    % Demo of feature tracking over 2 frames
    [Vx, Vy, i_r, i_c] = lucas_kanade(image1, image2, 1);
    
    figure
    imshow(image1)
    hold on
    quiver(i_c, i_r, Vx, Vy);
    hold off
end

