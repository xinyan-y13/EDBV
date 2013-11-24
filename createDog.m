function dogArray = createDog( grImg, octaves, intervals )
%--------------------------------------------------------------%
%---------------------- DoG Pyramid for SIFT-------------------%

% DOG creates the Difference-of-Gaussians image pyramid needed
% for SIFT operation
% 
% INPUT PARAMS:
% 
% grImg       a grayscale image
% octaves     the number of octaves to be created in the pyramid
% intervals   the number of intervals to be created for
%             each octave 
%
%
% OUTPUT PARAMS:
% 
% dogArray - array containing the different octaves in each row
%
%
% AUTHOR Balint Kovacs (1227520)
%--------------------------------------------------------------%

startingSigma = 1.6;
k = 1.414

% Get images of different resolution
r = 1;
for i = 1:octaves,
    grImgArray(i,1) = {imresize(grImg, r)};
    r = r/2;
end

% figure
% for i = 1:octaves,
%     subplot(2,2,i), subimage(cell2mat(grImgArray(i,1)))
% end

% Creating gaussian octaves
for i = 1:octaves,
    grImg = cell2mat(grImgArray(i,1));
    sigma = startingSigma;
    for j = 1:intervals+1,
        sigma = startingSigma * k^(j-1);
        gaussFilter = fspecial('gaussian', 40, sigma);
        gaussImg = imfilter(grImg, gaussFilter);
        gaussImgArray(i,j) = {gaussImg};
    end
end

% figure
% for j = 1:intervals+1,
%     subplot(2,3,j), subimage(cell2mat(gaussImgArray(1,j)))
% end


% Creating DoG array
for i = 1:octaves,
    for j = 1:intervals,
        dogArray(i,j) = {cell2mat(gaussImgArray(i,j)) - cell2mat(gaussImgArray(i,j+1))};
    end
end

% figure
% for j = 1:intervals,
%     subplot(2,3,j), subimage(cell2mat(dogArray(1,j)))
% end


end


