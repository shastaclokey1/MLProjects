clear;
load SAP.mat;
IF = struct2cell(imagefiles);
[cleanBC, remainingGW] = cleanBoxCordinates(boxCordinates, GWBImages);
[stacheBC, remainingGW] = generateStaches(cleanBC, remainingGW);
save SAP.mat;
save('cleanNNData.mat','stacheBC','remainingGW')
%gwTest = GWBImages{1};
%gwTest(231:281,256:284,:) = mustache;
%{
figure;
imshow(gwTest);
hold on
imshow(mustache);
%}