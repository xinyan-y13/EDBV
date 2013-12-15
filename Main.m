
% Masking image to remove unnecessary 
[maskedI center] = detectCard('./test/katze1.jpg');

% Creating Difference-of-Gaussian array
octaves = 4;
intervals = 4;

dogArray = createDog(maskedI, octaves, intervals );


% Transforming each octave to 3d matrix
octave1 = cell2mat(dogArray(1,1));
for i = 2:intervals
     octave1(:,:,i) = cell2mat(dogArray(1,i));
end

octave2 = cell2mat(dogArray(2,1));
for i = 2:intervals,
     octave2(:,:,i) = cell2mat(dogArray(2,i));
end

octave3 = cell2mat(dogArray(3,1));
for i = 2:intervals,
     octave3(:,:,i) = cell2mat(dogArray(3,i));
end

octave4 = cell2mat(dogArray(4,1));
for i = 2:intervals,
     octave4(:,:,i) = cell2mat(dogArray(4,i));
end


%Looking for extremes in each octave
oct1ext = localExt(octave1,7);
oct2ext = localExt(octave2,5);
oct3ext = localExt(octave3,3);
oct4ext = localExt(octave4,1);

%Localizing extrema with subpixel precision
oct1extSp = subpixel(oct1ext,octave1,0.5,10);
oct2extSp = subpixel(oct2ext,octave2,0.5,10);
oct3extSp = subpixel(oct3ext,octave3,0.5,10);
oct4extSp = subpixel(oct4ext,octave4,0.5,10);

%Calculating orientation
%frames1 = orientation(oct1ext, octave1, 1, 1.6);

% TODO Create unique interest point descriptor



% NOTE: This step is only necessary for plotting the found interest points
% on the correct position of the image
oct1InteresPoints = calculateRelativePixelPosition(oct1ext, 1);
oct2InteresPoints = calculateRelativePixelPosition(oct2ext, 2);
oct3InteresPoints = calculateRelativePixelPosition(oct3ext, 3);
oct4InteresPoints = calculateRelativePixelPosition(oct4ext, 4);

%Calculating orientation
%frames1 = orientation(oct1ext, octave1, 1, 1.6);


% plot found interest points on image, different colors indicate IP's found 
% on different octaves
% blue   - IP's on octave 1
% red    - IP's on octave 2
% green  - IP's on octave 3
% yellow - IP's on cotave 4
figure
imshow(maskedI)
hold on; 
plot(oct1InteresPoints(1,:),oct1InteresPoints(2,:),'b.','MarkerSize',10) 
hold on;
plot(oct2InteresPoints(1,:),oct2InteresPoints(2,:),'r.','MarkerSize',10) 
hold on;
plot(oct3InteresPoints(1,:),oct3InteresPoints(2,:),'g.','MarkerSize',10) 
hold on;
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



























