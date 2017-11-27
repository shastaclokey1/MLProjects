%%%%%%%%%%%%%%%%%%%%%Loading data and setting up predictor/outcomes%%%%%%
clear;
load('multiReg.mat')

day = table2array(day);
independentVars = day(:,1:11);
dependentVars = day(:,12:14);
chosenDependentVars = day(:,14);

%%%%%%%%%%%%%%%%%%%%Generating model(multiple linear reg)%%%%%%%%%%%%%%%%
disp('ORIGINAL DATA')
mdl = fitlm(independentVars, chosenDependentVars);
disp(mdl)


%%%%%%%%%%%%%%%%Testing model on good and bad days%%%%%%%%%%%%%%%%%%%
%did "day" predictions at end after generating final model with good predictors
goodDay = [3,0,10,0,4,0,1,.54,.435,.15,.05];
badDay = [3,1,8,0,1,1,3,.24,.14,.56,.5];
goodPredict = predict(mdl,goodDay);
badPredict = predict(mdl,badDay);
%disp('Good/Bad Day Prediction:')
%disp(goodPredict)
%disp(badPredict)


%%%%%%%%%%%%%%%Testing model on predictors and plotting aginst residuals%%%
predictedData = predict(mdl,independentVars);
residuals = chosenDependentVars - predictedData;
figNum = 1;
for i = 1:11
    pre(figNum) = figure;
    plot(independentVars(:,i),residuals, 'm.')
    curTit = strcat('col',int2str(i),' residual');
    title(curTit)
    figNum = figNum + 1;
end


%%%%%%%%%%%%%%%%%%%Examining Confidence intervals%%%%%%%%%%%%%%%%
CI = coefCI(mdl);
CISize = abs(CI(:,1) - CI(:,2))/2;
%noticed that 6 and 11 had smaller p-values(therefore smaller CI's)


%%%%%%%%%%%%%%%%%%Determining which predictors to exclude graphically%%%%%%%%%%%
disp('DETERMINING WHICH PREDICTORS TO CUT OUT GRAPHICALLY')
%{
figNum = 1;
for i = 1:11
   for j = 1:11 
        if (i ~= j && j < i)
            pred(figNum) = figure;
            plot(independentVars(:,i),independentVars(:,j), 'm.')
            curTit = strcat('col',int2str(i),' col',int2str(j));
            title(curTit)
            figNum = figNum + 1;
        end
   end
end
%}
lin(1) = figure;
plot(independentVars(:,7),independentVars(:,10), 'm.')
curTit = strcat('col',int2str(7),' col',int2str(10));
title(curTit)
lin(2) = figure;
plot(independentVars(:,9),independentVars(:,8), 'm.')
curTit = strcat('col',int2str(9),' col',int2str(8));
title(curTit)
lin(3) = figure;
plot(independentVars(:,1),independentVars(:,3), 'm.')
curTit = strcat('col',int2str(1),' col',int2str(3));
title(curTit)
%determined that predictors 3, 7 and 8 should be eliminated because they were
%colinear with 1, 10 and 9 respectively


%%%%%%%%%%%%%%%%%%%Preforming multi reg again after cutting out the bad data%%%%%%%%%%%%%%%%%%%
newIndiVars = independentVars(:,[1,2,4,5,6,9,10,11]);
newmdl = fitlm(newIndiVars, chosenDependentVars);
disp(newmdl)



%%%%%%%%%%%%%%%%Testing new model on good and bad days%%%%%%%%%%%%%%%%%%%
%did "day" predictions at end after generating final model with good predictors
newGoodDay = goodDay([1,2,4,5,6,9,10,11]);
newBadDay = badDay([1,2,4,5,6,9,10,11]);
newGoodPredict = predict(newmdl,newGoodDay);
newBadPredict = predict(newmdl,newBadDay);
%disp('Good/Bad Day Prediction:')
%disp(newGoodPredict)
%disp(newBadPredict)


%%%%%%%%%%%%%%%%%%%calculating and plotting residuals from new model%%%%%%
newPredictedData = predict(newmdl,newIndiVars);
newResiduals = chosenDependentVars - newPredictedData;
figNum = 1;
for i = 1:8
    post(figNum) = figure;
    plot(newIndiVars(:,i),newResiduals, 'm.')
    curTit = strcat('col',int2str(i),' newResidual');
    title(curTit)
    figNum = figNum + 1;
end



%%%%%%%%%%%%%%%%doing lasso on original data(not Specifying lambda)%%%%%%%%%%%%%%%%%%%
disp('DETERMINING WHICH PREDICTORS TO CUT OUT WITH LASSO')
[lassoRegBetas, FitInfo] = lasso(independentVars,chosenDependentVars);
%this zeroes out 3,4,5,6,and 10 by the 78th iteration(78th collumn)
%a good value of lambda looks like it would be 156
newIndependentVars = independentVars(:,[1,2,7,8,9,11]);

lassoMdl = fitlm(newIndependentVars, chosenDependentVars);
disp(lassoMdl)

%%%%%%%%%%%%%%%%Testing lasso model on good and bad days%%%%%%%%%%%%%%%%%%%
%did "day" predictions at end after generating final model with good predictors
lassoGoodDay = goodDay([1,2,7,8,9,11]);
lassoBadDay = badDay([1,2,7,8,9,11]);
lassoGoodPredict = predict(lassoMdl,lassoGoodDay);
lassoBadPredict = predict(lassoMdl,lassoBadDay);
%disp('Good/Bad Day Prediction:')
%disp(lassoGoodPredict)
%disp(lassoBadPredict)

%%%%%%%%%%%%%%%%%%calculating and plotting residuals for lasso model%%%%%%
lassoPredictedData = predict(lassoMdl,newIndependentVars);
lassoResiduals = chosenDependentVars - lassoPredictedData;
figNum = 1;
for i = 1:6
    lasso(figNum) = figure;
    plot(newIndependentVars(:,i),lassoResiduals, 'm.')
    curTit = strcat('col',int2str(i),' lassoResidual');
    title(curTit)
    figNum = figNum + 1;
end
%%%%%%%%%%%%%%doing ridge regression%%%%%%%%%%%%%%%%%%%%%
disp('DETERMINING WHICH PREDICTORS TO CUT OUT WITH RIDGE REGRESSION')
ridgeLowExtreme_oldData = ridge(chosenDependentVars,independentVars,0,0);
ridgeHighExtreme_oldData = ridge(chosenDependentVars,independentVars,4000,0);
%determined that 0 was too low a value for lambda and 4000 was much too
%high a variable for lambda. Proceeding by testing values from 100 to 500

i = 100;
while i < 500
    ridgeTest_oldData = ridge(chosenDependentVars,independentVars,i,0);
    %disp(i)
    %disp(ridgeTest_oldData)
    i = i + 100;
end
%Lambda equals 300 gives a nice distinction of the predictors which get
%very small as lambda increases. 
%Determined from ridge regression that predictors 3 5 and 6 should be
%eliminated

newIndependentVars = independentVars(:,[1,2,4,7,8,9,10,11]);
ridgeMdl = fitlm(newIndependentVars, chosenDependentVars);
disp(ridgeMdl)

%%%%%%%%%%%%%%%%Testing ridge model on good and bad days%%%%%%%%%%%%%%%%%%%
%did "day" predictions at end after generating final model with good predictors
ridgeGoodDay = goodDay([1,2,4,7,8,9,10,11]);
ridgeBadDay = badDay([1,2,4,7,8,9,10,11]);
ridgeGoodPredict = predict(ridgeMdl,ridgeGoodDay);
ridgeBadPredict = predict(ridgeMdl,ridgeBadDay);
%disp('Good/Bad Day Prediction:')
%disp(ridgeGoodPredict)
%disp(ridgeBadPredict)

%%%%%%%%%%%%%%%%%%calculating and plotting residuals for ridge model%%%%%%
ridgePredictedData = predict(ridgeMdl,newIndependentVars);
ridgeResiduals = chosenDependentVars - ridgePredictedData;
figNum = 1;
for i = 1:8
    ridge(figNum) = figure;
    plot(newIndependentVars(:,i),ridgeResiduals, 'm.')
    curTit = strcat('col',int2str(i),' ridgeResidual');
    title(curTit)
    figNum = figNum + 1;
end


%%%%%%%%%%%%%%%%%%Comparing all elimination techniques to determine which predictors I should keep for final model%%%%%%%%%%%%%
disp('COMPARING ALL ELIMINATION TECHNIQUES AND FORMING A FINAL MODEL TO PREDICT NUMBER OF RIDERS ON A RANGE OF DAYS')
%Determined from ridge regression that predictors 3 5 and 6 should be
%eliminated
%lasso zeros out 3,4,5,6,and 10 by the 78th iteration(78th collumn)
%determined that predictors 7 and 8 should be eliminated because they were
%colinear with 10 and 9 respectively

%Because colinearity is very disruptive in linear regression, I will
%eliminate predictors 10 and 8. Because predictors 3, 5, and 6 were found
%to be extraneous by both ridge and lasso, I will eliminate all of these
%three predictors. I will not eliminate predictor 4 because it took a higer
%value of lambda in the lasso regression to zero it out, and it is not
%reinforced in the ridge regression or the graphical elimination scheme
%predictors to eliminate:3,5,6,8,10


%%%%%%%%%%%%%%%%eliminating predictors and generating final model%%%%%%%%%
finalIndependentVars = independentVars(:,[1,2,4,7,9,11]);
finalMdl = fitlm(finalIndependentVars, chosenDependentVars);
disp(finalMdl)

%%%%%%%%%%%%%%%creating typical winter/spring/summer/autumn days in LA%%%%%%
%{
	1- season : season (1:springer, 2:summer, 3:fall, 4:winter)
	2- yr : year (0: 2011, 1:2012)
	3- holiday : weather day is holiday or not (extracted from http://dchr.dc.gov/page/holiday-schedule)
	4+ weathersit : 
		- 1: Clear, Few clouds, Partly cloudy, Partly cloudy
		- 2: Mist + Cloudy, Mist + Broken clouds, Mist + Few clouds, Mist
		- 3: Light Snow, Light Rain + Thunderstorm + Scattered clouds, Light Rain + Scattered clouds
		- 4: Heavy Rain + Ice Pallets + Thunderstorm + Mist, Snow + Fog
	5- atemp: Normalized feeling temperature in Celsius. The values are divided to 50 (max)
	6- windspeed: Normalized wind speed. The values are divided to 67 (max)

	- cnt: count of total rental bikes including both casual and registered
%}
%W/S/S/A holidays and non holidays for 2011
winterDay11hol = [4,0,1,1,20/50,13/67];
springDay11hol = [1,0,1,3,16/50,12/67];
summerDay11hol = [2,0,1,1,30/50,8/67];
autumnDay11hol = [3,0,1,1,27/50,9/67];

winterDay11nonhol = [4,0,0,1,20/50,13/67];
springDay11nonhol = [1,0,0,3,16/50,12/67];
summerDay11nonhol = [2,0,0,1,30/50,8/67];
autumnDay11nonhol = [3,0,0,1,27/50,9/67];

%W/S/S/A holidays and non holidays for 2012
winterDay12hol = [4,1,1,1,20/50,13/67];
springDay12hol = [1,1,1,3,16/50,12/67];
summerDay12hol = [2,1,1,1,30/50,8/67];
autumnDay12hol = [3,1,1,1,27/50,9/67];

winterDay12nonhol = [4,1,0,1,20/50,13/67];
springDay12nonhol = [1,1,0,3,16/50,12/67];
summerDay12nonhol = [2,1,0,1,30/50,8/67];
autumnDay12nonhol = [3,1,0,1,27/50,9/67];

%W/S/S/A holidays and non holidays average
winterDayAvghol = (winterDay12hol + winterDay11hol) ./ 2;
springDayAvghol = (springDay12hol + springDay11hol) ./ 2;
summerDayAvghol = (summerDay12hol + summerDay11hol) ./ 2;
autumnDayAvghol = (autumnDay12hol + autumnDay11hol) ./ 2;

winterDayAvgnonhol = (winterDay12nonhol + winterDay11nonhol) ./ 2;
springDayAvgnonhol = (springDay12nonhol + springDay11nonhol) ./ 2;
summerDayAvgnonhol = (summerDay12nonhol + summerDay11nonhol) ./ 2;
autumnDayAvgnonhol = (autumnDay12nonhol + autumnDay11nonhol) ./ 2;

%%%%%%%%%%%%%%%%using final model to predict riders%%%%%%%%%%%%%%%%%%%%%%
%W/S/S/A holidays
ridersWiH = predict(finalMdl,winterDayAvghol);
ridersSpH = predict(finalMdl,springDayAvghol);
ridersSuH = predict(finalMdl,summerDayAvghol);
ridersAuH = predict(finalMdl,autumnDayAvghol);
text = strcat('Riders on holiday durring the winter: ',int2str(ridersWiH));
disp(text);
text = strcat('Riders on holiday durring the spring: ',int2str(ridersSpH));
disp(text);
text = strcat('Riders on holiday durring the summer: ',int2str(ridersSuH));
disp(text);
text = strcat('Riders on holiday durring the autumn: ',int2str(ridersAuH));
disp(text);

%W/S/S/A non holidays
ridersWiNH = predict(finalMdl,winterDayAvgnonhol);
ridersSpNH = predict(finalMdl,springDayAvgnonhol);
ridersSuNH = predict(finalMdl,summerDayAvgnonhol);
ridersAuNH = predict(finalMdl,autumnDayAvgnonhol);
text = strcat('Riders not on holiday durring the winter: ',int2str(ridersWiNH));
disp(text);
text = strcat('Riders not on holiday durring the spring: ',int2str(ridersSpNH));
disp(text);
text = strcat('Riders not on holiday durring the summer: ',int2str(ridersSuNH));
disp(text);
text = strcat('Riders not on holiday durring the autumn: ',int2str(ridersAuNH));
disp(text);
