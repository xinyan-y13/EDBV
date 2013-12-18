
% Masking image to remove unnecessary 
[maskedI center] = detectCard('./test/testE4.png');

%maskedI = double(rgb2gray(imread('./test/markGC.jpg')));
% Creating Difference-of-Gaussian array
octaves = 4;
intervals = 5;

dogArray = createDog(maskedI, octaves, intervals );

%Rearranging octaves for further processing
ocataveArray = cell(1,octaves);
for i = 1:octaves
octave = cell2mat(dogArray(i,1));
    for j = 2:intervals
        octave(:,:,j) = cell2mat(dogArray(i,j));
    end
   ocataveArray(1,i) = {octave};
end

%Looking for extremes in each octave and
%localizing extrema with subpixel precision
thresholds = [0.20 0.15 0.1 0.08];
extArray = cell(1,octaves);
 for i = 1:octaves
    extrema = localExt(cell2mat(ocataveArray(i)),thresholds(i));
    extremaSp = subpixel(extrema, cell2mat(ocataveArray(i)), 0.5, 10);
    extArray(1,i) = {extremaSp};
end

%Calculating orientation
oriArray = cell(1,octaves);
ips = zeros(5,0);
for i = 1:octaves
   ori = orientation(cell2mat(extArray(i)), cell2mat(ocataveArray(i)), 1.6);
   oriArray(1,i) = {ori};
   
   %IP locations calculated back to original coordinates
   ori (1,:) = ori(1,:)*2^(i-1);
   ori (2,:) = ori(2,:)*2^(i-1);
   ips = cat(2,ips,ori);
end


% TODO Create unique interest point descriptor
descriptors = description(cell2mat(ocataveArray(1)),cell2mat(oriArray(1)));
for i = 2:octaves
    descriptors = cat(2,descriptors,description(cell2mat(ocataveArray(i)),cell2mat(oriArray(i))));
end



%NOTE: This step is only necessary for plotting the found interest points
%on the correct position of the image
relIP = cell(1,octaves);
relips = zeros(2,0);
for i=1:octaves
    relIP = calculateRelativePixelPosition(cell2mat(extArray(i)), i);
    relIPArray(1,i) = {relIP};
    relips = cat(2,relips,relIP);
end


dlmwrite('testE4desc.txt',descriptors);
dlmwrite('testE4ips.txt',ips);


% plot found interest points on image, different colors indicate IP's found 
% on different octaves
% blue   - IP's on octave 1
% red    - IP's on octave 2
% green  - IP's on octave 3
% yellow - IP's on cotave 4
figure
imshow(maskedI)
hold on;
oct1InteresPoints = cell2mat(relIPArray(1));
plot(oct1InteresPoints(1,:),oct1InteresPoints(2,:),'b.','MarkerSize',10) 
hold on;
oct2InteresPoints = cell2mat(relIPArray(2));
plot(oct2InteresPoints(1,:),oct2InteresPoints(2,:),'r.','MarkerSize',10) 
hold on;
oct3InteresPoints = cell2mat(relIPArray(3));
plot(oct3InteresPoints(1,:),oct3InteresPoints(2,:),'g.','MarkerSize',10) 
hold on;
oct4InteresPoints = cell2mat(relIPArray(4));
plot(oct4InteresPoints(1,:),oct4InteresPoints(2,:),'y.','MarkerSize',10) 
%hold on;
%quiver( frames1(1,:), frames1(2,:), frames1(4,:), frames1(5,:));

%frames2 = orientation(oct2extSp, octave2);
%frames3 = orientation(oct3extSp, octave3);
%frames4 = orientation(oct4extSp, octave4);




%fImage = imread('./test/test8.jpg');

% rotate about the second dimension.

%theta = 0.1;
%T2 = [cos(theta)  0      -sin(theta)   0
%    0             1              0     0
%    sin(theta)    0       cos(theta)   0
%    0             0              0     1];

%T = T2;

%drawFinalImageWithCube(fImage, center, T);



























