clear;
load('NNCoords.mat');

adjustedAnswers = YPred*2;

[cleanAdjPred, cleanImgs] = removeChaplins(adjustedAnswers,remainingGW);

for i = 1:length(cleanImgs)
    imageNum = i;

    testMustacheDim = round(cleanAdjPred(imageNum,:),0);

    imMat = uint8(zeros(512,512,3));

    temp = imresize(imread('Stache.png'),[testMustacheDim(3),testMustacheDim(4)]);
    
    if (i ==23)
        disp('we made it')
    end

    imMat(testMustacheDim(1):(testMustacheDim(1) + testMustacheDim(3) - 1),testMustacheDim(2):(testMustacheDim(2)+testMustacheDim(4) - 1),:) = temp;

    tempGW = cleanImgs{imageNum};
    tempGW = tempGW + imMat;
    imshow(tempGW)
end