function drawFinalImageWithCube( img, position, transformation_matrix )
% DRAWFINALIMAGEWITHCUBE Displays the image with correct
% rotated/translated cube on the card
% 
% INPUT PARAMS:
% 
% image - keypoints found in image
% position    - current image octave
% transformation_matrix     - scale of current octave
%
% AUTHOR Bernd Artmueller (1127846)


fig1 = figure;
h1=imshow(img); 
h2=axes;

% calculate cube blob object
[x,y,z] = ndgrid(-1:.025:1);
blob = z <= 0 & z >= -0.9 & x <= 0.8 & x > 0 & y <= 0.8 & y > 0;

% calculate blob center point
blob_center = (size(blob) + 1) / 2;

% retrieve image size/width
img_size   = size(img);
img_width  = img_size(2);
img_height = img_size(1);

% retrieve fig1 position and size
fig1_position = get(fig1, 'Position');
fig1_width    = fig1_position(3);
fig1_height   = fig1_position(4);

resize_factor = fig1_height / img_height;

img_width = img_width * resize_factor;
img_height = img_height * resize_factor;
position = position * resize_factor;

% calc left and bottom padding of figure
fig1_leftpadding   = (fig1_width  - img_width)  / 2;
fig1_bottompadding = (fig1_height - img_height) / 2;

% calculate position of cube
patch_position_left   = (position(1) + fig1_leftpadding - blob_center(1))   / fig1_width;
patch_position_bottom = (position(2) - fig1_bottompadding) / fig1_height;


tform = maketform('affine', transformation_matrix);


R = makeresampler('linear', 'fill');

% map dimension of input array to dimensions of tform
TDIMS_A = [1 2 3];

% map dimensions of output array to dimensions of the transformation
TDIMS_B = [1 2 3];

% size of the output array
TSIZE_B = size(blob);

TMAP_B = [];

F = 0;

% apply transformation matrix to cube
blob2 = tformarray(blob, tform, R, TDIMS_A, TDIMS_B, TSIZE_B, TMAP_B, F);

% set position of cube (axis of cube)
h3 = axes('Position',[patch_position_left patch_position_bottom 0.1 0.1]); 

% show cube
p = patch(isosurface(blob2,0.5));
set(p, 'FaceColor', 'blue', 'EdgeColor', 'none');
camlight
lighting gouraud

% hide axes
set(h2,'Visible','off'); 
set(h3,'Visible','off'); 

end

