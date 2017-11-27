function [errorValue] = computeTotalError(predictedLabels, trueLabels)
    temp = 0;
    for i = 1:length(predictedLabels)
        temp = temp + abs(predictedLabels(i) - trueLabels(i));
    end
    errorValue = temp;
end