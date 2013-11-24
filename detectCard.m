function [ masked_image, center ] = detectCard( file_path )
% DETECTCARD Detects card in given image and mask image to just show
% detected card
% AUTHOR Bernd Artmueller (1127846)

I = imread(file_path);
[image_width image_height] = size(I);

% convert to graylevel image
grayImage = rgb2gray(I);

% color thresholds
R_lower = 1;
G_lower = 40;
B_lower = 32;

R_upper = 55;
G_upper = 120;
B_upper = 80;

Image_red   = I(:,:,1);
Image_green = I(:,:,2);
Image_blue  = I(:,:,3);

% apply color threshold and calculate image mask
result_lower = (Image_red > R_lower) & (Image_green > G_lower) & (Image_blue > B_lower);
result_upper = (Image_red < R_upper) & (Image_green < G_upper) & (Image_blue < B_upper);

result = result_lower & result_upper;

% reduce noise with median filter
med_result = medfilt2(result);

% get rid of areas outside of card
med_result = bwareaopen(med_result, 4000, 4);

% fill area within detected border in image mask
med_result = imfill(med_result, 'holes');

% calculate center point of card mask
stats = regionprops(med_result, 'centroid');

% apply binary mask to greylevel image 
masked_image = uint8(grayImage) .* uint8(med_result);

% assign center point to return value
center = [stats.Centroid(1) stats.Centroid(2)];

end

