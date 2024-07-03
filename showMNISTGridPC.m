% showMNISTGridPC.m - Function to call show1mnist.m function in a loop
% showMNISTGridPC will call the show1mnist.m function in a loop so that it
% can visualize patterns and arrange them in a subplot matrix (column-wise)
%
% SYNTAX: showMNISTGrid(data, columns);
%
% where data can be TRN_MNIST.mat or RSV_MNIST.mat files or the variables inside
function showMNISTGridPC(data, columns)

figure('Position', [100, 100, 1200, 800]); % create a new figure

%FOR-LOOP ITERATING THROUGH ALL N-COLUMN VISUALIZATIONS
    for i = 1:length(columns)
        subplot(3, 5, i); % create a subplot in a 10x10 grid for all ith iterations
        show1mnist(data(:,columns(i))); % call the show1mnist function that will take all the rows from the ith column and perform the visualization
        axis on; % control whether the axis is on or off
        title(sprintf('Pattern %d', columns(i))); % show a title for the pattern of the column it was extracted from
    end
end
%first 10 patterns containing a label of '1' are: [4, 7, 9, 15, 24, 25, 41, 60, 68, 71]