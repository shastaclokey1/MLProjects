function [classArray] = logMaxClassify(predictionProbs)
    temp = zeros(length(predictionProbs),1);
    for i = 1:length(predictionProbs)
        max = 1;
        for j = 2:size(predictionProbs,2)
            if (predictionProbs(i,j) > predictionProbs(i,max))
                max = j;
            end
        end
        temp(i) = max;
    end
    classArray = temp;
end