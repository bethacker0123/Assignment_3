clc;clear;
imageSizeX = 480;
imageSizeY = 480;
[columnsInImage , rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
currentImage = imread('Rotor_Images/rotor09.jpg');
figure;
imshow(currentImage);
currentImage = rgb2hsv(currentImage);
currentImage= currentImage(:,:,3);
BW = edge(currentImage,'canny', [.05 .8]);
figure;
imshow(BW);
SE1 = strel('line',2,0);
SE2 = strel('line',1,90);
BW2 = imdilate(BW,[SE1 SE2]);
figure;

[BW3, locations_out] = imfill (BW2, 'holes');
imshow(BW3);
hold on;
iStats = regionprops('table',BW3,'Centroid', 'MajorAxisLength','MinorAxisLength');
centers = iStats.Centroid;
diameters = mean([iStats.MajorAxisLength iStats.MinorAxisLength],2);
radii = diameters/2;


circlePixels = (rowsInImage - centers(2)).^2 + (columnsInImage - centers(1)).^2 <= radii.^2;
figure;
imshow(circlePixels);
diff = (circlePixels - BW3);
figure;
imshow(diff);
iNewStats = regionprops(diff, 'basic','Centroid');
oldArea = sum(sum(BW3));
newArea = sum(sum(diff));
percentOfBlackSpace = newArea/oldArea*100;
disp('% of space between rotors');
disp(percentOfBlackSpace);
            