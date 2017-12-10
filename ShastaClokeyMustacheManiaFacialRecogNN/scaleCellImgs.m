function [resizedImages] = scaleCellImgs(targetCell,scale)
    tempCell = {};
    for i = 1:size(targetCell,2)
        tempCell{i} = imresize(targetCell{i},scale);
    end
    resizedImages = tempCell;
end