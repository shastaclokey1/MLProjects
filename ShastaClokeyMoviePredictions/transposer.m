function [decisionSpaceMat,rowsToDelete] = transposer(colOfObs, uniqueWords)
    tempMat = ones(length(colOfObs),length(uniqueWords));
    count = 1;
    lookForDelete = 0;
    for i=1:length(colOfObs)
       rowHasWord = 0;
       for j=1:length(uniqueWords)
           if (contains(colOfObs(i),uniqueWords(j),'IgnoreCase',true))
               tempMat(i,j) = 2;
               rowHasWord = 1;
           end
       end
       if (rowHasWord == 0)
           tempDelete(count) = i;
           count = count + 1;
           lookForDelete = 1;
       end
    end
    if (lookForDelete == 1)
        rowsToDelete = tempDelete;
    else
        rowsToDelete = 0;
    end
    decisionSpaceMat = tempMat;
    
end