function [result] = description(octave,keys)



[H, W, S] = size(octave); % H is the height of image, W is the width of image; num_level is the number of scale level of the octave
result = [];
magnitudes = keys(5,:);
angles = zeros(H, W, S);



for s = 1: 1:S
    img = octave(:,:,s);
    filter = imfilter(img, [-0.5 0 0.5]);
    angles(:,:,s) = mod(atan(double(filter) ./ double(eps + filter)) + 2*pi, 2*pi);
end


a = keys(1,:);
b = keys(2,:);


xr = floor(keys(1,:) + 0.5);
yr = floor(keys(2,:) + 0.5);
sc =  floor(keys(3,:) + 0.5);


% for every key point
for p = 1: size(keys, 2)

    s = sc(p);
    xp= xr(p);
    yp= yr(p);
    
    orien = keys(4,p);
    sinus = sin(orien) ;
    cosinus = cos(orien) ;
    
    sigma = (1.6*2^(1/3)) * 2^(double (s / 3)) ;
    width = 3 * sigma;
    radius = floor( sqrt(2) * width * 5 * 0.5 + 0.5);
    
    descriptor = zeros(4, 4, 8);
    
  
    for i = max(-radius, 1-xp): min(radius, W - xp)
        for j = max(-radius, 1-yp) : min(radius, H -yp)
            
            
            mag = magnitudes(p);
            ang = angles(yp + j, xp + i, s) ;  % the gradient ang at current point(yp + j, xp + i)
            ang = mod(orien - ang, 2*pi);      % adjust the ang with the major orientation of the keypoint and mod it with 2*pi
            
            
            distance_x = double(xp + i - a(p));  % a(p),b(p): coordinates of key point in the gauss pyramid 
            distance_y = double(yp + j - b(p));  % distance_x(y): rotated x and y
            
            nx = ( cosinus * distance_x + sinus * distance_y) / width ; 
            ny = ( cosinus * distance_y -sinus * distance_x) / width ; 
            nt = 8 * ang / (2* pi) ;

            gaus_exp =  exp(-(nx*nx + ny*ny)/8) ;
            
            binx = floor( nx - 0.5 ) ;
            biny = floor( ny - 0.5 ) ;
            bint = floor( nt );
            rbinx = nx - (binx+0.5) ;
            rbiny = ny - (biny+0.5) ;
            rbint = nt - bint ;
             
            for rotate_x = 0:1
               for rotate_y = 0:1 
                   for rotate_s = 0:1 
                       
                        if( binx+rotate_x >= -2 && binx+rotate_x <   2 && biny+rotate_y >= -2 && biny+rotate_y <   2 &&  isnan(bint) == 0) 
                              
                              weight = gaus_exp * mag * abs(1 - rotate_x - rbinx)* abs(1 - rotate_y - rbiny)* abs(1 - rotate_s - rbint) ;
   
                              descriptor(binx+rotate_x + 3, biny+rotate_y + 3, mod((bint+rotate_s),8)+1) = descriptor(binx+rotate_x + 3, biny+rotate_y + 3, mod((bint+rotate_s),8)+1 ) +  weight ;
                        end
                   end
               end
            end

        end
            
    end
    descriptor = reshape(descriptor, 1, 4 * 4 * 8);
    descriptor = descriptor ./ norm(descriptor);
            
    %Truncate at 0.2
    index = find(descriptor > 0.2);
    descriptor(index) = 0.2;
    descriptor = descriptor ./ norm(descriptor);
    
    result = [result, descriptor'];
end

  







