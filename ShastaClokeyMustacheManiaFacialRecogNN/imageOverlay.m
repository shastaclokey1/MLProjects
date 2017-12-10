clear;
load('cleanNNData.mat')
for i = 1:length(remainingGW)
    imageNum = i;

    testMustacheDim = round(stacheBC(imageNum,:),0);

    imMat = uint8(zeros(512,512,3));

    temp = imresize(imread('Stache.png'),[testMustacheDim(3),testMustacheDim(4)]);

    imMat(testMustacheDim(1):(testMustacheDim(1) + testMustacheDim(3) - 1),testMustacheDim(2):(testMustacheDim(2)+testMustacheDim(4) - 1),:) = temp;

    tempGW = remainingGW{imageNum};
    tempGW = tempGW + imMat;
    imshow(tempGW)
end