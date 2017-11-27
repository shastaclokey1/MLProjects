%C1 = Title, C2 = Genre, C3 = Description, C4 = Director, C5 = Actors,
%C6 =Year, C7 = Runtime (min), C8 = Metascore, C9 = Votes, C10 = Rating, 
%C11 = Revenue (M),C12 = Rank
clear;
load('Project3.mat');
load('synthesizedText.mat');

warning('off','all')
warning
%%%%%%%%%%%%%%%%Blocking together quantitative predictors%%%%%%%%%%%%%
TitleLength = strlength(table2array(MovieData(:,1)));
DescriptionLength = strlength(table2array(MovieData(:,3)));
GenreWords = UarrayOfGenres;
Genre = cleanTextArray(string(table2array(MovieData(:,2))));
DirectorWords = UDirectorsCut;
Director = cleanTextArray(string(table2array(MovieData(:,4))));
ActorWords = UActorsCut;
Actor = cleanTextArray(extractBefore(string(table2array(MovieData(:,5))),','));
Year = gapCloser(table2array(MovieData(:,6)));
Runtime = gapCloser(table2array(MovieData(:,7)));
Metascore = gapCloser(table2array(MovieData(:,8)));
Votes = gapCloser(table2array(MovieData(:,9)));
RatingPure = gapCloser(table2array(MovieData(:,10)));
Revenue = gapCloser(table2array(MovieData(:,11)));
RankPure = gapCloser(table2array(MovieData(:,12)));

RatingClass = classifyRating(RatingPure);
RankClass = classifyRank(RankPure);

quantitativeMovieData = [Year,Runtime,Metascore,Votes,TitleLength,DescriptionLength];
[actorDMat,actRowsToDelete] = transposer(Actor,ActorWords);
[genreDMat,genRowsToDelete] = transposer(Genre,GenreWords);
[directorDMat, dirRowsToDelete] = transposer(Director,DirectorWords);
qualitativeMovieData = [actorDMat,genreDMat,directorDMat]; 
totalMovieData = [quantitativeMovieData];%,qualitativeMovieData];
%{
allRowsToDelete = [actRowsToDelete,genRowsToDelete,dirRowsToDelete];
allRowsToDelete = unique(allRowsToDelete);
if (allRowsToDelete(1) == 0)
    allRowsToDelete(1) = [];
end
totalMovieData(allRowsToDelete,:) = [];
RatingClass(allRowsToDelete) = [];
RankClass(allRowsToDelete) = [];
Revenue(allRowsToDelete) = [];
%}

%quantitative predictors with labels attatched for rating
QPLabelsRating = [totalMovieData,RatingClass];

%quantitative predictors with labels attatched for rank
QPLabelsRank = [totalMovieData,RankClass];
[rankTraining, rankTest] = separateData(QPLabelsRank, 100);

%%%%%%%%%%%%%%%%%%%%%Logistic Regression for rank%%%%%%%%%%%%%%%%%%%%%%%
%{
    chose logistic regression for rank because rank is a class label with
    10 classes, so we couldn't use svm on it. Logistic regression works
%}
[rankLogModel,dev,stats] = mnrfit(rankTraining(:,1:(size(rankTraining,2)-1)),rankTraining(:,size(rankTraining,2)));
rankPredictions = mnrval(rankLogModel,rankTest(:,1:(size(rankTest,2)-1)));
rankLabels = logMaxClassify(rankPredictions);
errorProbability = computeBoolError(rankLabels, rankTest(:,size(rankTest,2)));
totalError = computeTotalError(rankLabels, rankTest(:,size(rankTest,2)));
[avgerr, errMat, avgTotError, totErrMat] = logregcv(QPLabelsRank(:,1:(size(QPLabelsRank,2)-1)),...
    QPLabelsRank(:,size(QPLabelsRank,2)),10);
disp('Average boolean error of our log regress model for Rank:');
disp(avgerr);
disp('Average Total error of our log regress model for Rank:');
disp(avgTotError);
disp('Predictions made by logistic regression model for Rank(1=above7.5,2=below)');
disp(rankLabels)
%{
quantitativeMovieDataFS0 = [Year];
QPLabelsRankFS0 = [quantitativeMovieDataFS0,RankClass];
[avgerrFS0, errMatFS0, avgTotErrorFS0, totErrMatFS0] = logregcv(QPLabelsRankFS0(:,1),QPLabelsRankFS0(:,2),10);

quantitativeMovieDataFS1 = [Year,Runtime];
QPLabelsRankFS1 = [quantitativeMovieDataFS1,RankClass];
[avgerrFS1, errMatFS1, avgTotErrorFS1, totErrMatFS1] = logregcv(QPLabelsRankFS1(:,1:2),QPLabelsRankFS1(:,3),10);

quantitativeMovieDataFS2 = [Year,Metascore];
QPLabelsRankFS2 = [quantitativeMovieDataFS2,RankClass];
[avgerrFS2, errMatFS2, avgTotErrorFS2, totErrMatFS2] = logregcv(QPLabelsRankFS2(:,1:2),QPLabelsRankFS2(:,3),10);

quantitativeMovieDataFS3 = [Year,Runtime,Metascore];
QPLabelsRankFS3 = [quantitativeMovieDataFS3,RankClass];
[avgerrFS3, errMatFS3, avgTotErrorFS3, totErrMatFS3] = logregcv(QPLabelsRankFS3(:,1:3),QPLabelsRankFS3(:,4),10);
%}
%use text data to make this a better model because the quantitative data sucks



%%%%%%%%%%%%%%%%%%%%come back and do forward selection

%%%%%%%%%%%%%SVM for rating%%%%%%%%%%%%%
%{
    chose svm for rating because our decision for rating above or below 7.5
    is binara and that is what svm operates on
%}
svmmodelRBF1 = fitcsvm(totalMovieData, RatingClass,...
    'KernelFunction','RBF','KernelScale',...
    'auto', 'CrossVal', 'on');
%{
svmmodelStd1 = fitcsvm(QPLabelsRating(:,1:4), QPLabelsRating(:,5));
svmmodelPly1 = fitcsvm(QPLabelsRating(:,1:4), QPLabelsRating(:,5),...
    'KernelFunction','polynomial',...
    'PolynomialOrder',2); 
svmmodelPly2 = fitcsvm(QPLabelsRating(:,1:4), QPLabelsRating(:,5),...
    'KernelFunction','polynomial',...
    'PolynomialOrder',5); 
svmmodelPly3 = fitcsvm(QPLabelsRating(:,1:4), QPLabelsRating(:,5),...
    'KernelFunction','polynomial',...
    'PolynomialOrder',10); 

StdClasses1 = predict(svmmodelStd1,QPLabelsRating(:,1:4));
PlyClasses1 = predict(svmmodelPly1,QPLabelsRating(:,1:4));
PlyClasses2 = predict(svmmodelPly2,QPLabelsRating(:,1:4));
PlyClasses3 = predict(svmmodelPly3,QPLabelsRating(:,1:4));
%}
RBFClasses1 = kfoldPredict(svmmodelRBF1);
svmerror = computeBoolError(RBFClasses1, RatingClass);
disp('Average Boolean Error for radial SVM for Rating:');
disp(svmerror);
disp('Predictions made by radial SVM for Rating');
disp(RBFClasses1)
%computeBoolError(StdClasses1, QPLabelsRating(:,5));
%computeBoolError(PlyClasses1, QPLabelsRating(:,5));
%computeBoolError(PlyClasses2, QPLabelsRating(:,5));
%computeBoolError(PlyClasses3, QPLabelsRating(:,5));

%It is clear that radial svm classification produces the lowest error rate


%%%%%%%%%%%%Decision trees for Revenue%%%%%%%%%%%%%%%%
treeMdl = fitrtree(totalMovieData,Revenue);
treeMdl = prune(treeMdl);
treeValues = predict(treeMdl, totalMovieData);
treeError = computeTotalError(treeValues, Revenue);
avgTreeError = treeError/length(treeValues);
disp('Average tree regression error for Revenue:');
disp(avgTreeError);
view(treeMdl,'Mode','graph')
disp('Predictions made by regression tree for Revenue');
disp(treeValues)

