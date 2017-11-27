function [avgBoolErr, boolErr, avgTotErr, totErr] = logregcv(X, y, k)
% computes k-fold cross validation for logistic regressions on labeled data
% X (nxp) with labels y (nx1) where labels are values in [1,...,r]

test_n = floor(size(X,1)/k);
totErr = zeros(k,1);
boolErr = zeros(k,1);
indshuffle = transpose(randperm(size(X,1)));
X = X(indshuffle);
y=y(indshuffle);

for jj=1:k
    testinds = (jj-1)*test_n+1:jj*test_n;
    traininds = 1:size(X,1);
    traininds(testinds)=[];
    B = mnrfit(X(traininds, :), y(traininds));
    pihat = mnrval(B, X(testinds,:));
    labels = logMaxClassify(pihat);
    errorProbability = computeBoolError(labels, y(testinds));
    totalError = computeTotalError(labels, y(testinds));
    totErr(jj) = totalError;
    boolErr(jj) = errorProbability;
end%for

avgBoolErr = sum(boolErr)/k;
avgTotErr = sum(totErr)/k;
    

end

