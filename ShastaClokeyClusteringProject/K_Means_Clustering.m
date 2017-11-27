%%%%%%%%%%%%%separating data%%%%%%%%%%%%%%%%
notTrainReal = (randperm(100,10));
testReal = measFeats(notTrainReal,:);
notTrainFake = (randperm(100,10))+100;
testFake = measFeats(notTrainFake,:);
testindicies = [notTrainReal,notTrainFake];

testdata = [testReal;testFake];
trainingdata = measFeats;
trainingdata(testindicies,:) = [];

%%%%%%%%%%%%%%%doing kmeans for all of the data%%%%%%%%%%%%%%%
[idx,C] = kmeans(trainingdata, 2,'Replicates',5);
shouldSwapCount = 0;
for i = 1:length(idx)
   if (idx(i) == 1)
       if (i > 100)
          shouldSwapCount = shouldSwapCount + 1;
       end   
   end
end

if (shouldSwapCount > 50)
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




%%%%%%%%%%%%%%computing errors%%%%%%%%%%%%%%%
trainingErrors = zeros(length(trainingdata),1);

for i = 1:length(trainingdata)
   if (idx(i)==1)
       if(i > (length(trainingdata)/2))
          trainingErrors(i)=1; 
       end
   end
   
   if (idx(i)==2)
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

countTestErrors = 0;

for i= 1:length(errors)
   if (errors(i) == 1)
       countTestErrors = countTestErrors + 1;
   end
end

testErrorProb = countTestErrors/length(testdata);
disp(testErrorProb);

%%%%%%%%%%%%%%%doing kmeans for columns four and six%%%%%%%%%%%%%%%
[idx,C] = kmeans(trainingdata(:,[4 6]), 2,'Replicates',5);

shouldSwapCount = 0;
for i = 1:length(idx)
   if (idx(i) == 1)
       if (i > 100)
          shouldSwapCount = shouldSwapCount + 1;
       end   
   end
end

if (shouldSwapCount > 50)
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

%%%%%%%%%%%%%%computing errors%%%%%%%%%%%%%%%
trainingErrors = zeros(length(trainingdata),1);

for i = 1:length(trainingdata)
   if (idx(i)==1)
       if(i > (length(trainingdata)/2))
          trainingErrors(i)=1; 
       end
   end
   
   if (idx(i)==2)
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
disp("Only columns 4 and 6")
disp(trainErrorProb);


%test data being compared to centroid one and centroid 2
cenDist = pdist2(testdata(:,[4 6]),C);
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

countTestErrors = 0;

for i= 1:length(errors)
   if (errors(i) == 1)
       countTestErrors = countTestErrors + 1;
   end
end

testErrorProb = countTestErrors/length(testdata);
disp(testErrorProb);


%%%%%%%%%%%%%%%%%%plotting 2 of the collumns against eachother%%%%%%%%%
figure;
plot(testdata(whichCent==1,4), testdata(whichCent==1,6),'k.','MarkerSize', 25)
hold on
plot(testdata(whichCent==2,4), testdata(whichCent==2,6),'m.','MarkerSize', 25)
plot(testdata(1:10,4),testdata(1:10,6),'r.','MarkerSize',12)
plot(testdata(11:20,4),testdata(11:20,6),'b.','MarkerSize',12)

plot(trainingdata(idx==1,4),trainingdata(idx==1,6),'r.','MarkerSize',25)
plot(trainingdata(idx==2,4),trainingdata(idx==2,6),'b.','MarkerSize',25)
plot(C(1,1),C(1,2),'kx','MarkerSize',15,'LineWidth',3)
plot(C(2,1),C(2,2),'kx','MarkerSize',15,'LineWidth',3)
plot(trainingdata(1:90,4),trainingdata(1:90,6),'g.','MarkerSize',12)
plot(trainingdata(91:180,4),trainingdata(91:180,6),'y.','MarkerSize',12)

legend('Test Assignment Real','Test Assignment Fake','Test Real','Test Fake',...
    'Training Assignment Real','Training Assignment Fake','Centroid Real','Centroid Fake','Training Real','Training Fake',...
       'Location','SW')
title 'K Means Cluster Assignments and Centroids(measFeats cols 4v6)'

hold off