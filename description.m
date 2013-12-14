function [result] = description(octave, keys,sigma,d)

%octave:original octave
%keys: the location, magnitude and orientation of all key points.
%sigma:
% d = descriptor width, = 4 according to lowe's paper

[H,W,S] = size(octave);
descriptor = [];
magnitude = zeros(H,W,S);

for s = 1:1: S
    interval = octave(:,:,s);
    dx = [-0.5,0,0.5];
    dy = dx;
    x_grad = imfilter(interval, dx);
    y_grad = imfilter(interval, dy);
    magnitude(:,:,s) = sqrt(x_grad.^2 + y_grad.^2); % calculate the magnitude
    
    %!!!
    angles(:,:,s) = mod(atan(y_grad ./ (eps + x_grad)) + 2*pi, 2*pi);
    
    
end


%Now calculate the weight

as = keys(1,:);
bs = keys(2,:);
ss = keys(3,:);


for k = 1: 1: size(keys:2)
    
    a = floor(as(k));
    b = floor(bs(k));
    s = floor(ss(k));
    
    %mag = keys(5,k);
    orien = keys(4,k);
    
    sinus = sin(orien);
    cosinus = cos(orien);
    
    width = 3 * (sigma * 2^(s / 3)); % the width of one field within histogramm, sigma value still to be determined
    radius = floor(width * sqrt(2) * 5.0 * 0.5 + 0.5); % radius of the window
    
    descriptor = zeros(4,4,8);
    
    %Avoid the negative values causing from -radius, use 1-a and 1-b
    for i = max(-radius, 1-a):min(radius, N-2-a)
        for j = max(-radius,1-b):min(radius, M-2-b)
            
            
            % According to Lowe, formula: weight = m(a+x,b+y) * exp
            % where a and b are coordinates of the keypoint in the gauss
            % pyramid
            
            mag = abs(magnitude(b+j,a+i,s+1));
            ang = abs(angles(b+j,a+i,s+1));
            ang = mod(orien-ang, 2*pi); % recalculate the orientation
            
            
            
            % rotate the keys, x', y'
            rx = ((cosinus * (a+i) + sinus * (b+j))/width) +(d/2);
            ry = ((cosinus*(b+ j) - sinus *(a +i))/width) + (d/2);
            rs = 8*ang/(2*pi);
            w_exp = exp(-(rx*rx + ry*ry)/ (d * d * 0.5)); % gaussian weight parameter£¬ d/2 = sigma
            
            
            
            %x",y"
            binx = floor(rx - 0.5);  % binx and biny are the new coordinates after the rotation
            biny = floor(ry -0.5);
            bins = floor(rs);
            rbinx = rx - (binx + 0.5);
            rbiny = ry - (biny + 0.5);
            rbins = rs - bins;
            
            
            % now double interpolation
            for bx = 0:1:1
                for by = 0:1:1
                    for bs = 0:1:1
                        if binx + bx >= -(d/2)&& binx + bx < d/2 && ...
                                biny + by >= -(d/2) && biny + by < (d/2)
                            
                            bin_weight = w_exp * mag * (1 - bx - rbinx)* abs(1-by-rbiny) * abs(1-bs-rbins);
                            
                            descriptor(binx+bx+d/2+1, biny + by + d/2 +1,mod((bins + bs),8)+1) = ...
                                descriptor(binx+bx+d/2+1, biny + by + d/2 +1,mod((bins + bs),8)+1) + bin_weight;
                            
                        end
                    end
                end
                
            end
        end
        
        
        
    end
    
    
    % normalize
    descriptor = reshape(descriptor, 1, d*d*8);
    descriptor = descriptor ./ norm(descriptor);
    % cut off the great magnitudes
    index = find(descriptor > 0.2);
    descriptor(index) = 0.2;
    descriptor = descriptor ./ norm(descriptor);
    
    result = descriptor;
    
    
    
    
end