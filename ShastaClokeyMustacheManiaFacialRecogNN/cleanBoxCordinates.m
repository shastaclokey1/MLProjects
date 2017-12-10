function [cleanFaceFeats, remainingGWs] = cleanBoxCordinates(boxCordinates, imageFiles)
    tempBoxCell = {};
    count = 1;
    tempLoc = {};
    for i = 1:size(boxCordinates,2)
        if (size(boxCordinates{i},1) == 1)
            tempBoxCell{count} = boxCordinates{i};
            tempLoc{count} = imageFiles{count};
            count = count + 1;
        end
    end
    cleanFaceFeats = tempBoxCell;
    remainingGWs = tempLoc;
end