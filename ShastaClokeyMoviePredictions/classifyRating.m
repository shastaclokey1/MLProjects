function [ratingClassifications] = classifyRating(Rating)
    temp = ones(length(Rating),1);
    for i = 1:length(Rating)
        if (Rating(i) >= 7.5)
            temp(i) = 2;
        end
    end
    ratingClassifications = temp;
end