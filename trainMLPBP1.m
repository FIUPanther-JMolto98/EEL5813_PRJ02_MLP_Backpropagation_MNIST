% trainMLPBP1.m - Function to train MLP classifier using BP for the number '1'
%
% SYNTAX: [W1,W2,b1,b2] = trainMLPBP1(alpha, epochs);
%
function [W1,W2,b1,b2] = trainMLPBP1(alpha, epochs)
    
    % LOAD THE TRAINING DATA FROM TRN_MNIST.mat, TRNXX VARIABLE
    load('TRN_MNIST.mat','TRNXX');
    PP = TRNXX; % we assign the training data to a variable PP (784 x 5000)
    disp(['Size of PP (JUST LOADED FROM TRN_MNIST.mat FILE, TRNXX MATRIX): ', mat2str(size(PP))]);
    % LOAD THE HOT-ONE ENCODED TARGETS FROM TRN_MNIST.mat, TRNY1 VARIABLE
    load('TRN_MNIST.mat', 'TRNY1');
    TT = TRNY1; % we assign the targets to a variable TT (1 x 5000)
    disp(['Size of TT (JUST LOADED FROM TRN_MNIST.mat FILE, TRNY1 MATRIX): ', mat2str(size(TT))]);

    % INITIALIZE PARAMETERS (WEIGHT MATRICES AND BIAS SCALARS)
    NUM_HIDDEN_NEURONS = 50; % use 50 hidden neurons or processing elements as the minimum
    W1 = randn(NUM_HIDDEN_NEURONS, 784) / 6; % random Gaussian Distribution matrix for small values W1 (Weight Matrix for LAYER 1)
    W2 = randn(1, NUM_HIDDEN_NEURONS) / 6; % random Gaussian Distribution matrix for small values W1 (Weight Matrix for LAYER 1)
    b1 = randn(NUM_HIDDEN_NEURONS, 1) / 6; % bias vector for the hidden layer, one for each processing element/neuron
    b2 = randn(1 , 1) / 6; % bias for the output layer

    % SELECT 5 RANDOM WEIGHTS FROM W1 FOR PARAMETER EVOLUTION PLOTTING
    NUM_WEIGHTS_TO_TRACK = 5; % adjustable depending on how many weights/parameters we want to keep track of per epoch
    randomRowIndices = randi(NUM_HIDDEN_NEURONS, NUM_WEIGHTS_TO_TRACK, 1);
    randomColIndices = randi(784, NUM_WEIGHTS_TO_TRACK, 1);
    weightEvolutions = zeros(NUM_WEIGHTS_TO_TRACK, epochs); % initialize an array of zeroes with dimensions (NUM_WEIGHTS_TO_TRACK, epochs)
                                                            % where each row represents the values of the weights/parameters we are monitoring 
                                                            % and each column represents the current iteration/epoch number
    
    % INITIALIZE AN ARRAY TO STORE MSE VALUES FOR EACH EPOCH
    MSE_values_epoch = zeros(1, epochs);

    % BEGINNING OF TRAINING LOOP
    for epoch = 1:epochs % iterates for as many epoch in epochs (we pass epochs as a parameter when calling the function)
        fprintf('BEGINNING EPOCH #%d\n', epoch); % display current epoch
        sumSquaredError = 0; % initializes the total sum of the squared errors for the k patterns presented at the current epoch
        for i = 1:size(PP, 2) % will run for each column in PP (PP, 2); the number 2 represents the 2nd dimension (i.e., columns)
            fprintf('BEGINNING ITERATION (K) #%d\n', i); %display current iteration number
            input = PP(:,i); % extract all the rows from the ith column as the input at iteration k
            target = TT(:,i); % extract all the rows from the ith column as the target at iteration k

                % FORWARD PROPAGATION (LINEAR COMBINATION COMPUTATION AND ACTIVATION)
                    % LINER COMBINATION AT HIDDEN LAYER
                   n1 = W1 * input + b1; % n1 is the net input that will go towards the corresponding neuron in the hidden layer
                                         % since size(W1) = NUM_HIDDEN_NEURONS x 784 and 
                                         % since size(input) = 5,000 x 784
                    % ACTIVATION AT HIDDEN LAYER
                    a1 = tansig(n1); % compute the tansig of the net input corresponding to the first layer
                    % LINEAR COMBINATION AT OUTPUT LAYER
                    n2 = W2 * a1 + b2; % n2 is the net input that will go towards the corresponding neuron in the output layer
                                          % we will use the output from the first layer (hidden layer) as the input for the net-input computation of the output layer
                    % ACTIVATION AT OUTPUT LAYER
                    a2 = tansig(n2); % compute the tansig of the net input corresponding to the second layer (output layer)
                    % ERROR COMPUTATION
                    e = target - a2; % expected output - computed output e = (t-a) per pattern
                                     % at the end of the epoch, we should expect E[(t-a)^2]

                    % ACCUMULATE SQUARED ERROR AT THE PRESENT ITERATION
                    sumSquaredError = sumSquaredError + sum(e .^ 2);

                % BACKWARD PROPAGATION (SENSITIVITY CALCULATION AND GRADIENT DESCENT)
                    % SENSITIVITY FOR OUTPUT (OUTERMOST) LAYER
                    Fprime_n2 = 1 - a2.^2;
                    s2 = (-2 * Fprime_n2) .* e; % here, we are following the formula -2*F^m(n^m)*(t-a)
                                                % where F^m(n^m) is the diagonal matrix consisting of the partial derivatives of tanh with respect to n 
                                                % and (t-a) the error of the current pattern presented
                                                % we can use the dot (.) operator to perform these computations element-wise
                    % SENSITIVITY FOR NEXT LAYER (HIDDEN LAYER)
                    Fprime_n1 = 1 - a1.^2; % diagonal matrix F^m(n^m) with the proper partial derivatives using dot (.) operator
                    s1 = Fprime_n1 .* (W2'* s2); % s^m = F^m(n^m)*(W^(m+1))^T*s^(m+1)

                % UPDATE THE PARAMETERS (WEIGHT AND BIAS UPDATE) USING THE SENSITIVITIES BACKWARDS
                delta_W2 = alpha * (s2 * a1'); % W^m(k+1) = W^m(k) - alpha * s^m * (a^(m-1))^T
                W2 = W2 - delta_W2;
                delta_W1 = alpha * (s1 * input'); % W^m(k+1) = W^m(k) - alpha * s^m * (a^(0))^T
                W1 = W1 - delta_W1;
                b2 = b2 - alpha * s2; % b^m(k+1) = b^m(k) - alpha * s^m
                b1 = b1 - alpha * s1; % b^m(k+1) = b^m(k) - alpha * s^m
                % STORE THE CURRENT VALUES OF THE SELECTED WEIGHTS
                for j = 1:NUM_WEIGHTS_TO_TRACK
                    weightEvolutions(j, epoch) = W1(randomRowIndices(j), randomColIndices(j));
                end
        end
        % STORE THE MSE FOR THIS EPOCH
        MSE_values_epoch(epoch) = sumSquaredError/ size(PP, 2);
    end
    % PRINT THE MSE VALUES FOR ALL EPOCHS AFTER TRAINING LOOP HAS FINALIZED
    fprintf('\nMSE Values for Each Epoch:\n');
    for epoch = 1:epochs
        fprintf('Epoch %d: MSE = %f\n', epoch, MSE_values_epoch(epoch));
    end
    
    % PLOT MSE vs EPOCH GRAPH
    figure; % creates new figure
    plot(1:epochs, MSE_values_epoch, 'b-o'); % plots the MSE values (y-axis) against epochs (x-axis)
    xlabel('Epoch'); % label for the x-axis
    ylabel('Mean Squared Error (MSE)'); % label for the y-axis
    title('MSE vs Epoch Performance Curve'); % title of the plot
    grid on; % renders the gridlines for better readability

    % PLOT PARAMETER EVOLUTION VS EPOCH GRAPH
    figure; % creates new figure for weight evolution
    hold on;
    for idx = 1:NUM_WEIGHTS_TO_TRACK
        plot(1:epochs, weightEvolutions(idx, :), '-o', ...
            'DisplayName', sprintf('Weight (%d, %d)', ...
            randomRowIndices(idx), randomColIndices(idx)));
    end
    hold off;
    xlabel('Epoch');
    ylabel('Weight Value');
    title('Weight Evolution vs Epoch Graph');
    legend show;
    grid on;
end