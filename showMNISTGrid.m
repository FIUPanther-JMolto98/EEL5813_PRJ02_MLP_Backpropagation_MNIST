% showMNISTGrid.m - Function to call show1mnist.m function in a loop
% showMNISTGrid.m will call the show1mnist.m function in a loop so that it
% can visualize 10 different patterns (one for each target value 0-9)
% 10 different times (i.e., each target value will be visualized 10 times)
% in a matrix of subplots
%
% SYNTAX: showMNISTGrid(data);
%
% where 'data' is a 784x100 matrix, where m/i = feature and n/j = pattern
function showMNISTGrid(data)

figure; % create a new figure

%FOR-LOOP ITERATING THROUGH ALL 100 VISUALIZATIONS
    for i = 1:100
        subplot(10, 10, i); % create a subplot in a 10x10 grid for all ith iterations
        show1mnist(data(:,i)); % call the show1mnist function that will take all the rows from the ith column and perform the visualization
        axis on; % control whether the axis is on or off
    end
end