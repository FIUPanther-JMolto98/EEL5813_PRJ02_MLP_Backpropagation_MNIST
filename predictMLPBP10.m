% predictMLPBP10.m - Function to predict MLP for 1-DETECTOR using RSV data
%
% SYNTAX: [overallAcc, numCorrect, numIncorrect, MSE_Array] = predictMLPBP10(W1, W2, b1, b2, thr);
%
function [overallAcc, numCorrect, numIncorrect, MSE_Array] = predictMLPBP10(W1, W2, b1, b2, thr)
    
    % LOAD THE TESTING DATA FROM TSTXX
    load('RSV_MNIST_SPLIT_P2.mat','TSTXX');
    PP = TSTXX; % we assign the training data to a variable PP (784 x 10000)
    % LOAD THE HOT-ONE ENCODED TARGETS FROM RSV_MNIST.mat, RSVY1 VARIABLE
    load('RSV_MNIST_SPLIT_P3.mat', 'TST10Y');
    TT = TST10Y; % we assign the targets to a variable TT (1 x 100000)

    numPatterns = size(PP, 2); % assuming PP is of size [features x patterns]
    correctPredictions = 0; % will hold the number of accurate predictions
    MSE_Array = zeros(1, numPatterns); % will hold the MSE for each pattern by
                                      % first creating an array of zeroes
                                      % of size (1, numPatterns)
    classificationResults = zeros(1, numPatterns);
    % BEGINNING OF PREDICTION LOOP
    for i = 1:numPatterns % for as long as we have patterns to be computed
      
        p = PP(:, i); % extract the pattern at the present iteration
        t = TT(:, i); % extract the target at the present iteration

        % FORWARD PROPAGATION
        n1 = W1 * p + b1;
        a1 = tansig(n1);
        n2 = W2 * a1 + b2;
        a2 = tansig(n2);

        % COMPUTE THE MEAN-SQUARED ERROR
        MSE_Array(i) = sum((t - a2) .^ 2) / length(t);

       % DETERMINE PREDICTED CLASS
       [~, predictedClassIndex] = max(a2);
       predictedClass = -ones(size(t));
       predictedClass(predictedClassIndex) = 1;

       % STORE THE CLASSIFICATION RESULT
       classificationResults(i) = predictedClassIndex;
       if predictedClassIndex == 10
           classificationResults(i) = 0; % adjust for the digit '0' being in the 10th row
       end

       % CHECK WHETHER THE PREDICTION WAS CORRECT
       if all(t == predictedClass)
           correctPredictions = correctPredictions + 1;
        end
    end

    % CALCULATE THE OVERALL ACCURACY AND NUMBER OF CORRECT/INCORRECT PREDICTIONS
    numCorrect = correctPredictions;
    numIncorrect = numPatterns - correctPredictions;
    overallAcc = numCorrect / numPatterns;
    fprintf('CORRECT CLASSIFICATIONS: %d\n', numCorrect);
    fprintf('INCORRECT CLASSIFICATIONS: %d\n', numIncorrect);
    fprintf('OVERALL ACCURACY: %f\n', overallAcc);

    % SAVE THE RESULTS TO A .mat FILE
    save('predictMLPBP10_results.mat', 'classificationResults', 'MSE_Array', 'numCorrect', 'numIncorrect', 'overallAcc');
end