%%%%%%%%%%%%%separating data%%%%%%%%%%%%%%%%
notTrainReal = (randperm(100,10));
testReal = measFeats(notTrainReal,:);
notTrainFake = (randperm(100,10))+100;
testFake = measFeats(notTrainFake,:);
testindicies = [notTrainReal,notTrainFake];

testdata = [testReal;testFake];
trainingdata = measFeats;
trainingdata(testindicies,:) = [];


%%%%%%%%%%%%%doing naive bayes with all of the data%%%%%%%%%%%%%%%%%%%%
if (mod(length(trainingdata),2)==1)
    real = zeros(round(length(trainingdata)/2)-1, 1);
    fake = ones(round(length(trainingdata)/2), 1);
else
    real = zeros(round(length(trainingdata)/2), 1);
    fake = ones(round(length(trainingdata)/2), 1); 
end
classifications = [real; fake];
mdl = fitcnb(trainingdata, classifications);

%%%%%%%%%%%%check error%%%%%%%%%%%%%%%%%%
idxTrain = predict(mdl,trainingdata);
trainingErrors = zeros(length(trainingdata),1);

for i = 1:length(trainingdata)
   if (idxTrain(i)==0)
       if(i > (length(trainingdata)/2))
          trainingErrors(i)=1; 
       end
   end
   
   if (idxTrain(i)==1)
       if(i <= (length(trainingdata)/2))
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



idxTest = predict(mdl,testdata);
errors = zeros(length(testdata),1);
for i = 1:length(testdata)
   if (idxTest(i)==0)
       if(i > (length(testdata)/2))
          errors(i)=1; 
       end
   end
   
   if (idxTest(i)==1)
       if(i <= (length(testdata)/2))
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

%%%%%%%%%%%%%%%%%%%%doing naive bayes with cols 4 and 6%%%%%%%%%%%%%
mdl = fitcnb(trainingdata(:,[4 6]), classifications);

%%%%%%%%%%%%check error%%%%%%%%%%%%%%%%%%
idxTrain = predict(mdl,trainingdata(:,[4 6]));
trainingErrors = zeros(length(trainingdata),1);

for i = 1:length(trainingdata)
   if (idxTrain(i)==0)
       if(i > (length(trainingdata)/2))
          trainingErrors(i)=1; 
       end
   end
   
   if (idxTrain(i)==1)
       if(i <= (length(trainingdata)/2))
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
disp("Only cols 4 and 6")
disp(trainErrorProb);



idxTest = predict(mdl,testdata(:,[4 6]));
errors = zeros(length(testdata),1);
for i = 1:length(testdata)
   if (idxTest(i)==0)
       if(i > (length(testdata)/2))
          errors(i)=1; 
       end
   end
   
   if (idxTest(i)==1)
       if(i <= (length(testdata)/2))
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


%%%%%%%%%%%%%%%%%%%%%%plotting%%%%%%%%%%%%%%%%%%%%%%%
figure;
plot(trainingdata(idxTrain==0,4),trainingdata(idxTrain==0,6),'ro','MarkerSize',5)
hold on
plot(trainingdata(idxTrain==1,4),trainingdata(idxTrain==1,6),'bo','MarkerSize',5)
plot(trainingdata(1:90,4),trainingdata(1:90,6),'r*','MarkerSize',5)
plot(trainingdata(91:180,4),trainingdata(91:180,6),'b*','MarkerSize',5)


plot(testdata(idxTest==0,4), testdata(idxTest==0,6),'k.','MarkerSize', 25)
plot(testdata(idxTest==1,4), testdata(idxTest==1,6),'m.','MarkerSize', 25)
plot(testdata(1:10,4),testdata(1:10,6),'r.','MarkerSize',12)
plot(testdata(11:20,4),testdata(11:20,6),'b.','MarkerSize',12)

legend('Train Real Assign','Train Fake Assign','Train Real','Train Fake',...
        'Test Real Assign','Test Fake Assign','Test Real','Test Fake',...
        'Location','SW')
title 'Naive Bayes Cluster Assignments(measFeats)'

hold off
