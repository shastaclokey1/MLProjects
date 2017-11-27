function [cleanData] = gapCloser(dirtyData)
    for i=1:length(dirtyData)
        if (isnan(dirtyData(i)))
            if(isnan(dirtyData(i+1)))
                dirtyData(i) = dirtyData(i-1) - mod(i,7);
            else
                dirtyData(i) = floor((dirtyData(i+1) + dirtyData(i-1))/2);
            end
        end
    end
    cleanData = dirtyData;
end