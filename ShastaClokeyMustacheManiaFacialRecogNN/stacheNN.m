clear;
load('cleanNNData.mat')

convSize = 20;
numFilters = 25;
convSize2 = 10;
numFilters2 = 10;

resizedSBC = stacheBC./2;
layers = [imageInputLayer([256 256 3])
          convolution2dLayer(convSize,numFilters)
          reluLayer
          convolution2dLayer(convSize2,numFilters2)
          reluLayer
          maxPooling2dLayer([2 2],'Stride',2)
          fullyConnectedLayer(4)
          regressionLayer];
      
%tempWeights = randn([convSize, convSize, 3, numFilters]) * 0.0001;
%layers(2).Weights = tempWeights;
% layers(4).Weights = tempWeights;
% layers(6).Weights = tempWeights;
      
options = trainingOptions('sgdm','InitialLearnRate',.0000000001,'LearnRateSchedule','piecewise',...
    'LearnRateDropFactor',.8,'LearnRateDropPeriod',10,'MaxEpochs',70);

imageContainer = imgCell2Mat(scaleCellImgs(remainingGW,.5));

net = trainNetwork(imageContainer,resizedSBC,layers,options);

YPred = predict(net,imageContainer);

save 'NNCoords.mat'

