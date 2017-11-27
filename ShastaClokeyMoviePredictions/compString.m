function [compedString] = compString(targetStringArray)
    for i = 1:length(targetStringArray)
        targetStringArray(i) = strcat(targetStringArray(i),',');
    end
    compedString = strjoin(targetStringArray);
end