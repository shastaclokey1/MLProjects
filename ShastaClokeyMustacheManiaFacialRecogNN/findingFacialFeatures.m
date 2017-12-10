clear;
reqToolboxes = {'Computer Vision System Toolbox', 'Image Processing Toolbox'};
if( ~checkToolboxes(reqToolboxes) )
 error('detectFaceParts requires: Computer Vision System Toolbox and Image Processing Toolbox. Please install these toolboxes.');
end


% Get list of all BMP files in this directory
% DIR returns as a structure array.  You will need to use () and . to get
% the file names.
imagefiles = dir('*.jpg');      
nfiles = length(imagefiles);    % Number of files found
for j=1:nfiles
   currentfilename = imagefiles(j).name;
   currentimage = imresize(imread(currentfilename), [512,512]);
   GWBImages{j} = currentimage;
end

lena = imread('lena.png');

%GWBImages = imageDatastore('D:\Occidental Sr Year\Machine Learning\FinalProject\detectFaceParts20160607\lfw','IncludeSubfolders',true,'FileExtensions', '.jpg','LabelSource','foldernames');

detector = buildDetector();
for i = 1:nfiles
    [boxCordinates{i}, boxedImages{i}, faces{i}, bbfaces{i}] = detectFaceParts(detector,GWBImages{i},2);
    if (mod(i,25)==0)
        disp(i);
    end
end

save SAP.mat