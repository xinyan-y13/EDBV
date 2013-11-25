function final_keypoints = orientation(keypoints, octave, scale, sigma)

BINS = 36;

final_keypoints = [];                  
window_factor = 1.5;  
histogram = zeros(1, BINS);
[octave_height, octave_width, s_num] = size(octave); % M is the height of image, N is the width of image; num_level is the number of scale level of the octave

% amount of keypoints
key_num = size(keypoints, 2);

% create empty matrix for magnitudes and angles
magnitudes = zeros(size(octave));
angles     = zeros(size(octave));

% iterate all intervalls of given octave and compute magnitude and angles
for sl = 1:s_num
    image = octave(:,:,sl);
    
    dx_filter = [-1 0 1];
    dy_filter = [1;0;-1];
    
    dx = imfilter(image, dx_filter);
    dy = imfilter(image, dy_filter);
    
    magnitudes(:,:,sl) = sqrt( dx.^2 + dy.^2);
    angles(:,:,sl)     = atan(dy ./ dx);
end

% round off the cooridnates and 
keypoints_x_axis = oframes(1,:);
keypoints_y_axis = oframes(2,:) ;
keypoints_scale = oframes(3,:);

%x_round = floor(oframes(1,:) + 0.5);
%y_round = floor(oframes(2,:) + 0.5);
%scales = floor(oframes(3,:) + 0.5) - smin;

% iterate each keypoint and apply window
for keypoint=1:key_num
    % keypoint coords
    keypoint_x = keypoints_x_axis(keypoint);
    keypoint_y = keypoints_y_axis(keypoint);
    keypoint_s = keypoints_scale(keypoint);
    
    sigma_gauss_window = window_factor * sigma * 2^(double (keypoint_s / scale)) ;
    window_radius = floor(3.0* sigma_gauss_window);
    
    % iterate over all pixels in window
    for xs = keypoint_x - window_radius : keypoint_x + window_radius
        for ys = keypoint_y - window_radius : keypoint_y + window_radius
            dx = (xs - keypoint_x);
            dy = (ys - keypoint_y);
            
            % only continue with points which are inside the window
            if dx^2 + dy^2 <= window_radius^2
               % calculate gaussian exponent
               gaussian_falloff = exp(-(dx^2 + dy^2)/(2 * sigma_gauss_window^2));
               
               % calculate the correct bin
               bin = round( NBINS *  angles(ys, xs, keypoint_s + 1)/(2*pi) + 0.5);

               histogram(bin) = histo(bin) + gaussian_falloff * magnitudes(ys, xs, keypoint_s + 1);
            end
            
        end
    end
    
    % retrieve highest peak(s) in histogram -> "dominant" orientation
    theta_max = max(histogram);
    theta_bin_peaks_indices = find(histogram > 0.8 * theta_max);
    theta_bin_peaks_count = size(theta_bin_peaks_indices, 2);
    
    % iterate all bins with peaks
    for i = 1 : theta_bin_peaks_count
        % get angle for current keypoint
        theta = theta_bin_peaks_indices(i);
        
        % add keypoint with "dominant" orientation
        final_keypoints = [final_keypoints, [keypoint_x; keypoint_y; keypoint_s; theta]];        
    end   
end