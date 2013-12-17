desc1 = dlmread('katze1desc.txt');
desc2 = dlmread('katze2desc.txt');
ips1 = dlmread('katze1ips.txt');
ips2 = dlmread('katze2ips.txt');
img1 = imread('./test/katze1.jpg');
img2 = imread('./test/katze2.jpg');

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