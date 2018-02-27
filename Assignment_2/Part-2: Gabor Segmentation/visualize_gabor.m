%% theta

thetas = [8 4 2 1];
n = size(thetas, 2);

for i=1:n
    gaborFilter = createGabor(1, pi/thetas(i), 4, 0, 1);
    subplot(1, n, i), imshow(gaborFilter(:,:,2),[]);
    title("pi / " + thetas(i));
end
%% sigma

sigmas = [1/2 1 2 4];
n = size(sigmas, 2);

for i=1:n
    gaborFilter = createGabor(sigmas(i), pi/2, 4, 0, 1);
    subplot(1, n, i), imshow(gaborFilter(:,:,2),[]);
    title(sigmas(i));
end

%% gamma

gammas = [1/4 1/2 1 2];
n = size(gammas, 2);

for i=1:n
    gaborFilter = createGabor(1, pi/2, 4, 0, gammas(i));
    subplot(1, n, i), imshow(gaborFilter(:,:,2),[]);
    title(gammas(i));
end