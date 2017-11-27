load("kMeansProject.mat");
disp("performing kMeans on measFeats:")
disp("probabilites of error(training,test)")
K_Means_Clustering;
disp("performing kMeans on wavCurr:")
disp("probabilites of error(training,test)")
kmeanswavcurr;
disp("performing KNN on measFeats:")
disp("probabilites of error(training,test)")
k_Nearest_Neighbors;
disp("performing KNN on wavCurr:")
disp("probabilites of error(training,test)")
knnwavcurr;
disp("performing naive bayes on measFeats:")
disp("probabilites of error(training,test)")
NaiveBayesMeasFeats;
disp("performing naive bayes on wavCurr:")
disp("probabilites of error(training,test)")
NaiveBayesWavCurr;