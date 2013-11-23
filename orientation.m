function frames = orientation(keypoints, octave, scale, sigma)

BINS = 36;

frames = [];                  
window_factor = 1.5;  
histogram = zeros(1, BINS);
[octave_height, octave_width, s_num] = size(octave); % M is the height of image, N is the width of image; num_level is the number of scale level of the octave

key_num = size(keypoints, 2);
magnitudes = zeros(size(octave));
angles = zeros(size(octave));

% compute magnitude and angles
for sl = 1:s_num
    image = octave(:,:,sl);
    
    dx_filter = [-1 0 1];
    dy_filter = [1;0;-1];
    
    dx = imfilter(image, dx_filter);
    dy = imfilter(image, dy_filter);
    
    magnitudes(:,:,sl) = sqrt( dx.^2 + dy.^2);
    angles(:,:,sl) = atan(dy ./ dx);
end



% round off the cooridnates and 
x = oframes(1,:);
y = oframes(2,:) ;
s = oframes(3,:);

x_round = floor(oframes(1,:) + 0.5);
y_round = floor(oframes(2,:) + 0.5);
scales = floor(oframes(3,:) + 0.5) - smin;


for keypoint=1:key_num
    s = scales(keypoint);
    xp= x_round(keypoint);
    yp= y_round(keypoint);
    
    
    sigma_gauss_window = window_factor * sigma0 * 2^(double (s / S)) ;
    window_radius = floor(3.0* sigma_gauss_window);
    
    % iterate over all pixels in window
    for xs = xp - window_radius : xp + window_radius
        for ys = yp - window_radius : yp + window_radius
            dx = (xs - x(keypoint));
            dy = (ys - y(keypoint));
            
            % only continue with points which are inside the window
            if dx^2 + dy^2 <= window_radius^2
               % calculate gaussian exponent
               gaussian_falloff = exp(-(dx^2 + dy^2)/(2 * sigma_gauss_window^2));
               
               % calculate the correct bin
               bin = round( NBINS *  angles(ys, xs, s+ 1)/(2*pi) + 0.5);

               histogram(bin) = histo(bin) + gaussian_falloff * magnitudes(ys, xs, s+ 1);
            end
            
        end
    end
    
    % retrieve highest peak(s) in histogram -> "dominant" orientation
    theta_max = max(histogram);
    theta_bin_peaks_indices = find(histogram > 0.8 * theta_max);
    theta_bin_peaks_count = size(theta_bin_peaks_indices, 2);
    
    % iterate all bins with peaks
    for i = 1 : theta_bin_peaks_count
        %theta = 2*pi * theta_indx(i) / NBINS;
        
        theta = angles(y(keypoint), x(keypoint), s + 1);
        frames = [frames, [x(keypoint) y(keypoint) s theta]'];        
    end   
end

oframes = frames;
% for each keypoint