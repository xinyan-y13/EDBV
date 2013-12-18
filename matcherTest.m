clear
origin1 = [490 649 0];
origin2 = [517 589 0];
origin2min = [417 489 0];
origin2max = [617 689 0];
desc1 = dlmread('testE2desc.txt');
desc2 = dlmread('testE4desc.txt');
ips1 = dlmread('testE2ips.txt');
ips2 = dlmread('testE4ips.txt');
img1 = imread('./test/testE2.png');
img2 = imread('./test/testE4.png');

[matches1,matches2] = matcher(desc1, ips1, desc2, ips2);

img3 = [img1 img2];

% Show a figure with lines joining the accepted matches.
% figure('Position', [100 100 size(img3,2) size(img3,1)]);
% colormap('gray');
% imagesc(img3);
figure
imshow(img3)
hold on;
offset = size(img1,2);
for i=1:size(matches1,2)
    plot(matches1(1,i),matches1(2,i),'b.','MarkerSize',10)
    
    plot(matches2(1,i)+offset,matches2(2,i),'b.','MarkerSize',10)
    p1 = [matches1(1,i) matches1(2,i)];
    p2 = [matches2(1,i)+offset matches2(2,i)];
    plot([p1(1),p2(1)],[p1(2),p2(2)],'Color','r','LineWidth',1)
    %plot(matches1(1,:),matches1(2,:),'b.','MarkerSize',10)
    %line([matches1(1,i),matches(2,i)], ...
    %    [matches2(1,i)+offset,matches(2,i)], 'Color', 'y');
end


matches1 = matches1';
matches2 = matches2';

[tform,inlierPtsDistorted,inlierPtsOriginal] = ...
    estimateGeometricTransform(matches2,matches1,'Affine');
alvar = imread('./test/ALVAR-0.png');
outputView = imref2d(size(img1));
img3 = imwarp(alvar, tform);

figure
imshow(img2)
hold on;
imshow(img3)
%drawCube(origin1, 200)
%drawCube(origin2, 200)
