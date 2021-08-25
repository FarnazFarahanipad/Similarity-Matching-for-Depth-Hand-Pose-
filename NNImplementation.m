clc, close all, clear all

tic

% put the generated image in Ref folder and the original images in the same folder as the .m file

RefImageList = dir('Ref/*.png');

ReferenceImage = (imread(['Ref/',RefImageList.name]));

GrayReferenceImage = uint16(ReferenceImage(:,:,3)) + bitsll(uint16(ReferenceImage(:,:,2)),8);

BWReferenceImage = imbinarize(GrayReferenceImage);

EdgeReferenceImage = edge(BWReferenceImage,'canny');

DistanceRef = bwdist(EdgeReferenceImage);

RefIndices = find(EdgeReferenceImage == 1);

ListOfImages = dir('*.png');

BestSimilarity = size(GrayReferenceImage,1) * size(GrayReferenceImage,2) * (2^16);

BestImageIndex = 1;

for i = 1:length(ListOfImages)

   CurrentImage = (imread(ListOfImages(i).name));

   GrayCurrentImage = uint16(CurrentImage(:,:,3)) + bitsll(uint16(CurrentImage(:,:,2)),8);

   %% Do similarity calculation in here:

  

   %L1:

%    Method = 'L1';

%    AbsoluteDif = abs(GrayCurrentImage-GrayReferenceImage);

%    Similarity = sum(AbsoluteDif(:));

 

   %L2:

%    Method = 'L2';

%    Dif = GrayCurrentImage-GrayReferenceImage;

%    SquaredDif = Dif.^2;

%    Similarity = sqrt(sum(SquaredDif(:)));

 

   %Champfer:

   Method = 'Chamfer';

   BWCurrentImage = imbinarize(GrayCurrentImage);

   EdgeCurrentImage = edge(BWCurrentImage,'canny');

   DistanceCurrent = bwdist(EdgeCurrentImage);

   CurrentIndices = find(EdgeCurrentImage == 1);

   CurrentToRefDistance = sum(DistanceRef(CurrentIndices))/length(CurrentIndices);

   RefToCurrentDistance = sum(DistanceCurrent(RefIndices))/length(RefIndices);

   Similarity = CurrentToRefDistance + RefToCurrentDistance;

   

   

   %% Similarity comparison

   if Similarity < BestSimilarity

       BestSimilarity = Similarity;

       BestImageIndex = i;

   end

end

disp(['Closest image found to be ',ListOfImages(BestImageIndex).name])

TotalTime = toc;

disp(['Total time spent using "',Method,'" for searching among ',num2str(length(ListOfImages)),' images is equal to ',num2str(TotalTime),' seconds.'])

 
