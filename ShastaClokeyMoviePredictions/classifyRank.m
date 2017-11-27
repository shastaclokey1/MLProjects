function [rankClassifications] = classifyRank(Rank)
    temp = zeros(length(Rank),1);
    for i = 1:length(Rank)
        if (Rank(i) > 0 && Rank(i) <= 100)
            temp(i) = 1;
        elseif (Rank(i) > 100 && Rank(i) <= 200)
            temp(i) = 2;
        elseif (Rank(i) > 200 && Rank(i) <= 300)
            temp(i) = 3;
        elseif (Rank(i) > 300 && Rank(i) <= 400)
            temp(i) = 4;
        elseif (Rank(i) > 400 && Rank(i) <= 500)
            temp(i) = 5;
        elseif (Rank(i) > 500 && Rank(i) <= 600)
            temp(i) = 6;
        elseif (Rank(i) > 600 && Rank(i) <= 700)
            temp(i) = 7;
        elseif (Rank(i) > 700 && Rank(i) <= 800)
            temp(i) = 8;
        elseif (Rank(i) > 800 && Rank(i) <= 900)
            temp(i) = 9;
        elseif (Rank(i) > 900 && Rank(i) <= 1000)
            temp(i) = 10;
        end
    end
    rankClassifications = temp;
end