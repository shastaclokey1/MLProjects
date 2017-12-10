function [staches, remainingGWs] = generateStaches(cleanBC, imageFilesPrime)
    tempMat = zeros(size(cleanBC,2),4);
    count = 1;
    count2 = 1;
    tempGWs = {};
    for i = 1:size(cleanBC,2)
        tempMat(i,3) = cleanBC{i}(19)/1.3;
        tempMat(i,4) = cleanBC{i}(20)*2;
        tempMat(i,1) = cleanBC{i}(17) + tempMat(i,3) + 5;
        tempMat(i,2) = cleanBC{i}(18) - tempMat(i,4)/2;
        if (tempMat(i,3) == 0)
            zeroIndis(count) = i;
            count = count + 1;
        else
            tempGWs{count2} = imageFilesPrime{count2};
            count2 = count2 + 1;
        end
    end
    tempMat(zeroIndis,:) = [];
    staches = tempMat;
    remainingGWs = tempGWs;
end