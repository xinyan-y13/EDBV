function [result] = description(octave,keys, starting_sigma)

[H, W, S] = size(octave); % H is the height of image, W is the width of image; num_level is the number of scale level of the octave
result = [];
angles = zeros(H, W, S);
magnitudes = zeros(H, W, S);

for s = 1: 1:S
    img = octave(:,:,s);
    dx = imfilter(img, [-0.5 0 0.5]);
    dy = imfilter(img, [-0.5; 0; 0.5]);
    
    magnitudes(:,:,s) = sqrt( dx.^2 + dy.^2 );
    angles(:,:,s) = atan2( dy, dx );  
end


a = keys(1,:);
b = keys(2,:);
sc = keys(3,:);


% for every key point
for p = 1: size(keys, 2)
    descriptor = zeros(4, 4, 8);
    s = floor(sc(p));
    xp= floor(a(p));
    yp= floor(b(p));
    orien = keys(4,p);
    sinus = sin(orien) ;
    cosinus = cos(orien) ;
    
    width = 3 * starting_sigma * 2^(double (s / 3));
    radius = floor( sqrt(2) * width * 5 * 0.5); % radius uses(d+1) to include more sample points
    for i = max(-radius, 1-xp): min(radius, W-xp)
        for j = max(-radius, 1-yp) : min(radius, H-yp)
            mag_current = magnitudes(yp+j, xp+i, s);
            ang = angles(yp+j, xp+i, s) ;
            ang = mod(orien-ang, 2*pi);
            
            distance_x = double(xp+i-a(p));  % a(p),b(p): coordinates of key point in the gauss pyramid
            distance_y = double(yp+j-b(p));
            
            %distance_x(y): x' and y', rotated x and y
            nx = ( cosinus * distance_x + sinus * distance_y) / width;  % x" and y", now fall in the d*d window with the new coordinates
            ny = ( cosinus * distance_y -sinus * distance_x) / width;
            nt = 8 * ang / (2* pi) ;
            % e^(-x^2+y^2 / 2*(0.5d)^2), lowe suggestion: sigma = 0.5d
            gaus_exp =  exp(-(nx*nx + ny*ny)/8) ;
            
            binx = floor( nx - 0.5 ) ;
            biny = floor( ny - 0.5 ) ;
            bins = floor( nt );
            rbinx = nx - (binx+0.5) ;
            rbiny = ny - (biny+0.5) ;
            rbins = nt - bins ;
            
            for rotate_x = 0:1
                for rotate_y = 0:1
                    for rotate_s = 0:1
                        
                        if( binx+rotate_x >= -2 && binx+rotate_x <   2 && biny+rotate_y >= -2 && biny+rotate_y <   2 &&  isnan(bins) == 0)
                            % w = m(a+x, b+y)*exp* dr^k*(1-dr)^(1-k) * dc^m*(1-dc)^(1-m) * do^n*(1-do)^(1-n),
                            % a,b: coordinates of the keypoint within the gauss octave
                            % k,m,n: either 1 or 0
                            weight = mag_current * gaus_exp * abs(1 - rotate_x - rbinx)* abs(1 - rotate_y - rbiny)* abs(1 - rotate_s - rbins) ;
                            descriptor(binx+rotate_x + 3, biny+rotate_y + 3, mod((bins+rotate_s),8)+1) = descriptor(binx+rotate_x + 3, biny+rotate_y + 3, mod((bins+rotate_s),8)+1 ) +  weight ;
                        end
                    end
                end
            end
            
        end
        
    end
    descriptor = reshape(descriptor, 1, 4 * 4 * 8);
    descriptor = descriptor ./ norm(descriptor);% normalize the vector to reduce illumination changes
    index = find(descriptor > 0.2);
    descriptor(index) = 0.2; % reduce influence of large gradient magnitudes, Lowe suggestion: thredhold = 0.2
    descriptor = descriptor ./ norm(descriptor); % renormalize the unit length
    
    result = [result, descriptor'];
end
