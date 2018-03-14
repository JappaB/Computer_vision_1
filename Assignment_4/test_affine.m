%%

d_out = [0 0; -100 300; -100 -100]';
d_in = [0 100; 200 0; 0 0]';

% M = createProjectionMatrix(d_out, d_in);
M = createAffineTransformation(d_out, d_in);

trans = M * [d_in; ones(1, size(d_in, 2))];
trans(1,:) = trans(1,:) ./ trans(3,:);
trans(2,:) = trans(2,:) ./ trans(3,:);

plot(trans(1,:), trans(2,:))
hold on
plot(d_out(1,:), d_out(2,:))
hold on
plot(d_in(1,:), d_in(2,:))
hold off

distance = hypot(trans(1,:) - d_out(1,:), trans(2,:)-d_out(2,:))

%% On unit square

input = [0 0; 1 0; 0 1; 1 1]' * -1;
output = [0 0; 2 0; 0 2.5; 1 1]';

A = createProjectionMatrix(output, input)
transA = A * [input; ones(1, size(input, 2))]

plot(input(1,:), input(2,:), 'rd');
hold on
plot(transA(1,:), transA(2,:), 'yd');
hold on
plot(output(1,:), output(2,:), 'gd');

distanceA = hypot(transA(1,:) - output(1,:), transA(2,:)-output(2,:))