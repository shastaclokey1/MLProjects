function [errorRate] = computeBoolError(predictedLabels, trueLabels)
    errorCount = 0;
    for i = 1:length(predictedLabels)
        if (predictedLabels(i) ~= trueLabels(i))
            errorCount = errorCount + 1;
        end
    end
    errorRate = errorCount/length(predictedLabels);
end