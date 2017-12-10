function [predictions, imgs] = removeChaplins(badPred, badImgs)
    tempImgs = {};
    count = 1;
    for i = 1:size(badPred,1)
        if ((badPred(i,1)+badPred(i,3)) >= 511 || (badPred(i,2)+badPred(i,4)) >= 511)
            disp('REMOVED')
            disp(i)
        elseif (badPred(i,1) <= 1 || badPred(i,2) <= 1 || badPred(i,3) <= 1 || badPred(i,4) <= 1)
            disp('REMOVED')
            disp(i)
        else
            tempImgs{count} = badImgs{i};
            tempPred(count,:) = badPred(i,:);
            count = count + 1;
        end
    end
    predictions = tempPred;
    imgs = tempImgs;
end