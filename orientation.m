function final_keypoints = orientation(keypoints, octave, starting_sigma)
% ORIENTATION Computes the "dominant" orientation for each keypoint
% 
% INPUT PARAMS:
% 
% keypoints - keypoints found in image
% octave    - current image octave
% scale     - scale of current octave
% sigma     - sigma value used for gaussian filter of current octave
%
% OUTPUT PARAMS:
% 
% final_keypoints - keypoints with "dominant" orientation
%
% AUTHOR Bernd Artmueller (1127846)

BINS = 36;

final_keypoints = [];                  
window_factor = 1.5;  
histogram = zeros(1, BINS);
[octave_height, octave_width, s_num] = size(octave); % M is the height of image, N is the width of image; num_level is the number of scale level of the octave

% create empty matrix for magnitudes and angles
magnitudes = ones(size(octave));
angles     = ones(size(octave));

% iterate all intervalls of given octave and compute magnitude and angles
for sl = 1:s_num
    image = octave(:,:,sl);
    
    dx_filter = [-1 0 1];
    dy_filter = [1;0;-1];
    
    dx = imfilter(image, dx_filter);
    dy = imfilter(image, dy_filter);
    
    dx = abs(dx);
    dy = abs(dy);
    
    magnitudes(:,:,sl) = sqrt( dx.^2 + dy.^2 );
    angles(:,:,sl)     = atan2( dy, dx );
end

% retrieve keypoint informations for easier access
keypoints_x_axis = keypoints(1,:);
keypoints_y_axis = keypoints(2,:) ;
keypoints_scale = keypoints(3,:);

rounded_keypoints_x_axis = floor(keypoints_x_axis + 0.5);
rounded_keypoints_y_axis = floor(keypoints_y_axis + 0.5);
rounded_keypoints_scale = floor(keypoints_scale + 0.5);

% amount of keypoints
key_num = size(keypoints, 2);

% iterate each keypoint and apply window
for keypoint=1:key_num
    % keypoint coords
    keypoint_x = rounded_keypoints_x_axis(keypoint);
    keypoint_y = rounded_keypoints_y_axis(keypoint);
    keypoint_s = rounded_keypoints_scale(keypoint);
    
    sigma_gauss_window = window_factor * (starting_sigma * 1.414^(keypoint_s - 1));
    window_radius = floor(sigma_gauss_window);
    
    % iterate over all pixels in window
    for xs = keypoint_x - window_radius : keypoint_x + window_radius
        for ys = keypoint_y - window_radius : keypoint_y + window_radius
            dx = abs(xs - keypoint_x);
            dy = abs(ys - keypoint_y);
            
            % only continue with points which are inside the window
            if dx^2 + dy^2 <= window_radius^2
               % calculate gaussian exponent
               gaussian_falloff = exp(-(dx^2 + dy^2)/(2 * sigma_gauss_window^2));
               
               % calculate the correct bin
               bin = round( BINS *  angles(ys, xs, keypoint_s)/(2*pi) + 0.5);
             
               histogram(bin) = double(histogram(bin) + gaussian_falloff * magnitudes(ys, xs, keypoint_s));
            end
        end
    end
    
    % retrieve highest peak(s) in histogram -> "dominant" orientation
    theta_max = max(histogram);
    theta_bin_peaks_indices = find(histogram > 0.8 * theta_max);
    theta_bin_peaks_count = size(theta_bin_peaks_indices, 2);

    % iterate all bins with peaks
    for i = 1 : theta_bin_peaks_count
        % angle of dominant magnitude
        dominant_angle     = ( (2 * pi) * theta_bin_peaks_indices(i) ) / BINS;
        
        % length of dominant magnitude
        dominant_magnitude = double(histogram(theta_bin_peaks_indices(i)));
        
        % add keypoint with "dominant" orientation
        final_keypoints = [final_keypoints, [keypoints_x_axis(keypoint); keypoints_y_axis(keypoint); keypoints_scale(keypoint); dominant_angle; dominant_magnitude]];        
    end  
 
    % reset histogram
    histogram = zeros(1, BINS);
end
