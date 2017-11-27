function [trainingSet,testSet] = separateData(augMat, testSetSize)
    testSetIndi = randperm(size(augMat,1),testSetSize);
    testData = augMat(testSetIndi,:);
    
    trainingData = augMat;
    trainingData(testSetIndi,:) = [];
    
    trainingSet = trainingData;
    testSet = testData;
end