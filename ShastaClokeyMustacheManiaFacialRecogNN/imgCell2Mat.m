function [imageMat] = imgCell2Mat(targetCell)
    tempMat = uint8(zeros(128,128,3,size(targetCell,2)));
    for i = 1:length(targetCell)
        tempMat(1:256,1:256,1:3,i) = targetCell{i}(1:256, 1:256,1:3);
    end
    imageMat = tempMat;
end