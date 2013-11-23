function [ result ] = subpixel(extrema,octav,t,r)

%extrema: matrix which contains coordinations of extrema points: 2-D
%octav: the actual octavs, N-D
%t: threshold for contrast

result = [];

[B,L,D] = size(octav);
[b,l] = size(extrema);


%for later
iter = 1;



for l=1:1:l
    
    % get coordinates of one point
    cor = extrema(:,l);
    x = cor(1);
    y = cor(2);
    o = cor(3);
    
    % if x,y and s corss the border
    if x < 2 || x > L -1 || y < 1 || y > B-1 || o < 1 || o > D-1
        continue ;
    end
    
    % local extrema point within octaves
    point = octav(y,x,o);
    
    
    %prepare for hessian matrix
    Dx=0;Dy=0;Do=0;
    dxx=0; dxy=0; dxs=0;
    dyy=0; dys=0;
    dss=0;
    dx = 0; dy = 0;
    
    
    for i = 1:1:5 %default 5 iterations for convergence of the taylor series
        
        
        % move the coordination of one subpixel till it's close enough to
        % the actual max or min.
        %x = x + dx ;
        %y = y + dy ;
        
        
        %gradient
        
        Dx = (octav(y,x+1,o)-octav(y,x-1,o))/2;
        Dy = (octav(y+1,x,o)-octav(y-1,x,o))/2;
        Do = (octav(y,x,o+1)+octav(y,x,o-1))/2;
        t(1) = Dx; t(2) = Dy; t(3) = Do;
        
        
        %Hessian Matrix
        
        H = zeros(3,3);
        
        %    dxx   dxy   dxs
        %H = dxy   dyy   dys
        %    dxs   dys   dss
        %
        
        % create a hessian matrix
        % 9 partial differenciate
        dxx = octav(y,x+1,o) + octav(y,x-1,o)- 2 * octav(y,x,o);
        dxy = (octav(y+1,x+1,o)- octav(y+1,x-1,o) - octav(y-1,x+1,o)  + octav(y-1,x-1,o))/4;
        dxs = (octav(y,x+1,o+1) - octav(y,x+1,o-1) - octav(y,x-1,o+1) + octav (y,x-1,o-1))/4;
        dyy = octav(y-1,x,o) + octav(y+1,x,o)- 2 * octav(y,x,o);
        dys = (octav(y+1,x,o+1) -octav(y+1,x,o-1) - octav(y-1,x,o+1) + octav(y-1,x,o-1))/4;
        dss = octav(y,x,o+1) + octav(y,x,o-1)- 2*octav(y,x,o);
        
        %fill the H matrix
        H(1,1) = dxx; H(1,2) = dxy; H(1,3) = dxs;
        H(2,1) = dxy; H(2,2) = dyy; H(2,3) = dys;
        H(3,1) = dxs; H(3,2) = dys; H(3,3) = dss;
        H = inv(H);
        
        %interpolate the range of translation
        p = (-1) * H * t;
        
        
        %if the translation is smaller than 0.5, convergence has been
        %reached and don't have to care about the rest
        if p(1) < 0.5 && p(2) < 0.5 && p(3)<0.5
            
            break;
        end
        
        %else
        
        x = x + p(1);
        y = y + p(2);
        o = o + p(3);
        
        if x < 1 || x > B-1 || x < 1 || x > L-1 || x < 1 || x > D-1
            break;
        end
        
        
    end
    
    
    
    
    
    %After getting one subpixel, test whether it's on the edge or not:
    %Edge elimination:
    
    %(Tr(H)^2 / Det(H)) < ((r+1)^2)/r : required!
    %
    %Tr(H) = Dxx + Dyy
    %Det(H) = Dxx*Dyy - (Dxy)^2
    %
    %(H) = Dxx Dxy
    %      Dxy Dyy
    %
    
    
    %Calculates interpolated pixel contrast
    point = point + 0.5*(Dx * p(1) + Dy * p(2) + Do * p(3));
    
    if point < t
        continue;
    end
    
    tr = (dxx + dyy) * (dxx + dyy);
    det = dxx * dyy - dxy * dxy;
    th = ((r+1)*(r+1))/r;
    % r is just an interval to determine whether one specific point is
    % gonna be saved or not. In Lowe's paper, it's normally 10.
    
    
    
    
    % in this case, the coordinates of the point can be saved
    if (tr*tr/det) < th ...
            && (tr*tr/det)>=0 ...
            && rx >= 0 ...
            && rx <= L-1 ...
            && ry >= 0 ...
            && ry <= B-1 ...
            && ro >= 0 ...
            && ro <= D-1
        
        
        result(1,iter) = rx;
        result(2,iter) = ry;
        result(3,iter) = ro;
        iter = iter+1;
        
    end
    
    
end
end