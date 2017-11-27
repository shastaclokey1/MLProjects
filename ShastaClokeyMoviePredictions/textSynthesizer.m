%C1 = Title, C2 = Genre, C3 = Description, C4 = Director, C5 = Actors,
%C6 =Year, C7 = Runtime (min), C8 = Metascore, C9 = Votes, C10 = Rating, 
%C11 = Revenue (M),C12 = Rank
%{
    The goal of this script is to creat unique lists of words to be used as
    predictors that only contain words with lenght greater than 3.
%}
clear;
load('movieData.mat');
%%%%%%%%%%%%%%%%%%%%%%Pulling in data from MovieData .mat file%%%%%%%%%%%
Title = table2array(MovieData(:,1));
%Title = strjoin(Title,'blabadigook');
Genre = string(table2array(MovieData(:,2)));
Description = table2array(MovieData(:,3));
Director = cleanTextArray(string(table2array(MovieData(:,4))));
Actor = cleanTextArray(extractBefore(string(table2array(MovieData(:,5))),','));
Year = table2array(MovieData(:,6));
Runtime = table2array(MovieData(:,7));
Metascore = table2array(MovieData(:,8));
Votes = table2array(MovieData(:,9));
Rating = table2array(MovieData(:,10));
Revenue = table2array(MovieData(:,11));
Rank = table2array(MovieData(:,12));

%%%%%%%%preparing to create unique lists of words for each section%%%%%%%%
titleStringComp = strjoin(Title(:));
descriptionStringComp = strjoin(Description(:));
actorStringComp = compString(Actor);
genreStringComp = compString(Genre);

arrayOfTitles = strsplit(titleStringComp,' ')';
arrayOfDescriptions = strsplit(descriptionStringComp,' ')';
arrayOfActors = strsplit(actorStringComp,',')';
arrayOfGenres = strsplit(genreStringComp,',')';

%%%%%%%%%%%%%%%%%%%cleaning the words of junk and stuff%%%%%%%%%%%%%%
arrayOfTitles = lower(cleanTextArray(arrayOfTitles));
arrayOfDescriptions = lower(cleanTextArray(arrayOfDescriptions));
arrayOfActors = lower(cleanTextArray(arrayOfActors));
arrayOfGenres = lower(cleanTextArray(arrayOfGenres));
Director = lower(cleanTextArray(Director));

%%%%%%%%%%%creating unique lists of words for each text catagory%%%%%%%%%%
[UarrayOfTitles, freqTitles] = uniqueTextArray(arrayOfTitles);
[UarrayOfDescriptions, freqDescriptions] = uniqueTextArray(arrayOfDescriptions);
[UarrayOfActors, freqActors] = uniqueTextArray(arrayOfActors);
[UarrayOfGenres, freqGenres] = uniqueTextArray(arrayOfGenres);
[UarrayOfDirectors, freqDirectors] = uniqueTextArray(Director);
UActorsSorted = sortStrings(UarrayOfActors,freqActors);
UDirectorsSorted = sortStrings(UarrayOfDirectors,freqDirectors);

UActorsCut = UActorsSorted(1:25)';
UDirectorsCut = UDirectorsSorted(1:25)';

%{
disp('Array Of Titles')
disp(arrayOfTitles)
disp('Array Of Descriptions')
disp(arrayOfDescriptions)
%}

save synthesizedText.mat