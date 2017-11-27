%%%%%%%%%%%%%separating data%%%%%%%%%%%%%%%%
notTrainReal = (randperm(762,76));
testReal = wavCurr(notTrainReal,:);
notTrainFake = (randperm((1372-762),76))+762;
testFake = wavCurr(notTrainFake,:);
testindicies = [notTrainReal,notTrainFake];

testdata = [testReal;testFake];
trainingdata = wavCurr;
trainingdata(testindicies,:) = [];

%%%%%%%%%%%%%doing naive bayes with all of the data%%%%%%%%%%%%%%%%%%%%
classifications = trainingdata(:,5);
mdl = fitcnb(trainingdata(:,1:4), classifications);

%%%%%%%%%%%%check error%%%%%%%%%%%%%%%%%%
idxTrain = predict(mdl,trainingdata(:,1:4));
trainingErrors = zeros(length(trainingdata),1);

for i = 1:length(trainingdata)
   if (idxTrain(i)==0)
       if(trainingdata(i,5)==1)
          trainingErrors(i)=1; 
       end
   end
   
   if (idxTrain(i)==1)
       if(trainingdata(i,5)==0)
          trainingErrors(i)=1; 
       end
   end
end

countTrainErrors =0;

for i= 1:length(trainingErrors)
   if (trainingErrors(i) == 1)
       countTrainErrors = countTrainErrors + 1;
   end
end

trainErrorProb = countTrainErrors/length(trainingdata);
disp("All of the data")
disp(trainErrorProb);



idxTest = predict(mdl,testdata(:,1:4));
errors = zeros(length(testdata),1);
for i = 1:length(testdata)
   if (idxTest(i)==0)
       if(testdata(i,5)==1)
          errors(i)=1; 
       end
   end
   
   if (idxTest(i)==1)
       if(testdata(i,5)==0)
          errors(i)=1; 
       end
   end
end

countTestErrors = 0;

for i= 1:length(errors)
   if (errors(i) == 1)
       countTestErrors = countTestErrors + 1;
   end
end

testErrorProb = countTestErrors/length(testdata);
disp(testErrorProb);

%%%%%%%%%%%%%%%%%%%doing naive bayes with only cols 1 and 2%%%%%%%%%%%%
mdl = fitcnb(trainingdata(:,[1 2]), classifications);

%%%%%%%%%%%%check error%%%%%%%%%%%%%%%%%%
idxTrain = predict(mdl,trainingdata(:,[1 2]));
trainingErrors = zeros(length(trainingdata),1);

for i = 1:length(trainingdata)
   if (idxTrain(i)==0)
       if(trainingdata(i,5)==1)
          trainingErrors(i)=1; 
       end
   end
   
   if (idxTrain(i)==1)
       if(trainingdata(i,5)==0)
          trainingErrors(i)=1; 
       end
   end
end

countTrainErrors =0;

for i= 1:length(trainingErrors)
   if (trainingErrors(i) == 1)
       countTrainErrors = countTrainErrors + 1;
   end
end

trainErrorProb = countTrainErrors/length(trainingdata);
disp("Only cols 1 and 2")
disp(trainErrorProb);



idxTest = predict(mdl,testdata(:,[1 2]));
errors = zeros(length(testdata),1);
for i = 1:length(testdata)
   if (idxTest(i)==0)
       if(testdata(i,5)==1)
          errors(i)=1; 
       end
   end
   
   if (idxTest(i)==1)
       if(testdata(i,5)==0)
          errors(i)=1; 
       end
   end
end

countTestErrors = 0;

for i= 1:length(errors)
   if (errors(i) == 1)
       countTestErrors = countTestErrors + 1;
   end
end

testErrorProb = countTestErrors/length(testdata);
disp(testErrorProb);


%%%%%%%%%%%%%%%%%%%%plotting%%%%%%%%%%%%%%%%%%%%%%
figure;
trainTruth = trainingdata(:,5);
plot(trainingdata(idxTrain==0,1),trainingdata(idxTrain==0,2),'ro','MarkerSize',5)
hold on
plot(trainingdata(idxTrain==1,1),trainingdata(idxTrain==1,2),'bo','MarkerSize',5)
plot(trainingdata(trainTruth==0,1),trainingdata(trainTruth==0,2),'r*','MarkerSize',5)
plot(trainingdata(trainTruth==1,1),trainingdata(trainTruth==1,2),'b*','MarkerSize',5)

testTruth = testdata(:,5);
plot(testdata(idxTest==0,1), testdata(idxTest==0,2),'k.','MarkerSize', 25)
plot(testdata(idxTest==1,1), testdata(idxTest==1,2),'m.','MarkerSize', 25)
plot(testdata(testTruth==0,1),testdata(testTruth==0,2),'r.','MarkerSize',12)
plot(testdata(testTruth==1,1),testdata(testTruth==1,2),'b.','MarkerSize',12)

legend('Train Real Assign','Train Fake Assign','Train Real','Train Fake',...
        'Test Real Assign','Test Fake Assign','Test Real','Test Fake',...
        'Location','SW')
title 'Naive Bayes Cluster Assignments(wavCurr)'

hold off