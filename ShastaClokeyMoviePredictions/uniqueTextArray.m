function [uniqueArray, frequencyArray] = uniqueTextArray(badArray)
    count = 2;
    tempArray(1) = badArray(1);
    for i = 2:length(badArray)
        [isPresent,index] = searchStringArray(tempArray, badArray(i));
        if (isPresent == 0)
            tempArray(count) = badArray(i);
            frequencyArray(count) = 0;
            count = count + 1;
        else
            frequencyArray(index) = frequencyArray(index) + 1;
        end
    end
    uniqueArray = tempArray;
end

function [found,index] = searchStringArray(targetArray,targetString)
    found = 0;
    index = 0;
    for j = 1:length(targetArray)
        if (targetArray(j) == targetString)
            found = 1;
            index = j;
        end
    end 
end