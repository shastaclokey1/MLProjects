%%%%%%%%%%%%%separating data%%%%%%%%%%%%%%%%
notTrainReal = (randperm(762,76));
testReal = wavCurr(notTrainReal,:);
notTrainFake = (randperm((1372-762),76))+762;
testFake = wavCurr(notTrainFake,:);
testindicies = [notTrainReal,notTrainFake];

testdata = [testReal;testFake];
trainingdata = wavCurr;
trainingdata(testindicies,:) = [];


%%%%%%%%%%%%%%%do kmeans for all of the data%%%%%%%%%%%%%%%%%%%%%
[idx,C] = kmeans(trainingdata, 2,'Replicates',5);
shouldSwapCount = 0;
for i = 1:length(idx)
   if (idx(i) == 1)
       if (trainingdata(i,5) == 1)
          shouldSwapCount = shouldSwapCount + 1;
       end   
   end
   if (idx(i) == 2)
       if (trainingdata(i,5) == 0)
           shouldSwapCount = shouldSwapCount + 1;
       end
   end
end

if (shouldSwapCount > 600)
    temp = C(1,:);
    C(1,:) = C(2,:);
    C(2,:) = temp;
    for i=1:length(idx) 
        if(idx(i) == 1)
            idx(i) = 2;
        else
            idx(i) = 1;
        end
    end
end



%%%%%%%%%%%%%%%find errors%%%%%%%%%%%%%%%%%%%%
trainingErrors = zeros(length(trainingdata),1);

for i = 1:length(trainingdata)
   if (idx(i)==1)
       if(trainingdata(i,5) == 1)
          trainingErrors(i)=1; 
       end
   end
   
   if (idx(i)==2)
       if(trainingdata(i,5) == 0)
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
disp(trainErrorProb)

%test data being compared to centroid one and centroid 2
cenDist = pdist2(testdata,C);
whichCent = zeros(length(testdata),1);
errors = zeros(length(testdata),1);
for i =1:length(testdata)
    if (cenDist(i,1) < cenDist(i,2))
        whichCent(i) = 1;
        if (i > (length(testdata)/2))
           errors(i) = 1; 
        end
    else
        whichCent(i) = 2;
        if (i <= (length(testdata)/2))
           errors(i) = 1; 
        end
    end
end

%disp(errors);

countTestErrors =0;

for i= 1:length(errors)
   if (errors(i) == 1)
       countTestErrors = countTestErrors + 1;
   end
end

testErrorProb = countTestErrors/length(testdata);
disp(testErrorProb);


%%%%%%%%%%%%%%%do kmeans for columns one and two%%%%%%%%%%%%%%%%%%%%%
[idx,C] = kmeans(trainingdata(:,[1 2]), 2,'Replicates',5);
shouldSwapCount = 0;
for i = 1:length(idx)
   if (idx(i) == 1)
       if (trainingdata(i,5) == 1)
          shouldSwapCount = shouldSwapCount + 1;
       end   
   end
   if (idx(i) == 2)
       if (trainingdata(i,5) == 0)
           shouldSwapCount = shouldSwapCount + 1;
       end
   end
end

if (shouldSwapCount > 600)
    temp = C(1,:);
    C(1,:) = C(2,:);
    C(2,:) = temp;
    for i=1:length(idx) 
        if(idx(i) == 1)
            idx(i) = 2;
        else
            idx(i) = 1;
        end
    end
end



%%%%%%%%%%%%%%%find errors%%%%%%%%%%%%%%%%%%%%
trainingErrors = zeros(length(trainingdata),1);

for i = 1:length(trainingdata)
   if (idx(i)==1)
       if(trainingdata(i,5) == 1)
          trainingErrors(i)=1; 
       end
   end
   
   if (idx(i)==2)
       if(trainingdata(i,5) == 0)
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
disp("Only columns 1 and 2")
disp(trainErrorProb);

%test data being compared to centroid one and centroid 2
cenDist = pdist2(testdata(:,[1 2]),C);
whichCent = zeros(length(testdata),1);
errors = zeros(length(testdata),1);
for i =1:length(testdata)
    if (cenDist(i,1) < cenDist(i,2))
        whichCent(i) = 1;
        if (i > (length(testdata)/2))
           errors(i) = 1; 
        end
    else
        whichCent(i) = 2;
        if (i <= (length(testdata)/2))
           errors(i) = 1; 
        end
    end
end

%disp(errors);

countTestErrors =0;

for i= 1:length(errors)
   if (errors(i) == 1)
       countTestErrors = countTestErrors + 1;
   end
end

testErrorProb = countTestErrors/length(testdata);
disp(testErrorProb);


%%%%%%%%%%%%%plot results from favorite columns%%%%%%%%%
figure;
testTruth = testdata(:,5);
plot(testdata(whichCent==1,1), testdata(whichCent==1,2),'k.','MarkerSize', 25)
hold on
plot(testdata(whichCent==2,1), testdata(whichCent==2,2),'m.','MarkerSize', 25)
plot(testdata(testTruth==0,1),testdata(testTruth==0,2),'r.','MarkerSize',12)
plot(testdata(testTruth==1,1),testdata(testTruth==1,2),'b.','MarkerSize',12)

trainTruth = trainingdata(:,5);
plot(trainingdata(idx==1,1),trainingdata(idx==1,2),'r.','MarkerSize',25)
plot(trainingdata(idx==2,1),trainingdata(idx==2,2),'b.','MarkerSize',25)
plot(C(1,1),C(1,2),'kx','MarkerSize',15,'LineWidth',3)
plot(C(2,1),C(2,2),'kx','MarkerSize',15,'LineWidth',3)
plot(trainingdata(trainTruth==0,1),trainingdata(trainTruth==0,2),'g.','MarkerSize',12)
plot(trainingdata(trainTruth==1,1),trainingdata(trainTruth==1,2),'y.','MarkerSize',12)

legend('Test Assignment Real','Test Assignment Fake','Test Real','Test Fake',...
    'Training Assignment Real','Training Assignment Fake','Centroid Real','Centroid Fake','Training Real','Training Fake',...
       'Location','SW')
title 'K Means Cluster Assignments and Centroids(wavCurr)'

hold off