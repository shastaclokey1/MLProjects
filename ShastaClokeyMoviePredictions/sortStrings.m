function [sortedStrings] = sortStrings(stringArray,freqArray)
    
    for i = 1:size(stringArray,1)
        maxIndi = i;
        for j=1:size(stringArray,1)
            if (freqArray(j) > freqArray(maxIndi))
                maxIndi = j;
            end
        end
        
        stringTemp = stringArray(i);
        freqTemp = freqArray(i);
        stringArray(i) = stringArray(maxIndi);
        freqArray(i) = freqArray(maxIndi);
        stringArray(maxIndi) = stringTemp;
        freqArray(maxIndi) = freqTemp;      
    end
    sortedStrings = stringArray;
end