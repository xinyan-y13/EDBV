function [ result ] = localExt(DOG,smin)


%result:
%DOG: DOG octav, 4 x 4





rep = zeros(size(DOG));
col = 1;
result = [];

for i=2:1:size(DOG,3)-1
    for j=2:1:size(DOG,1)-2
        for k=2: 1: size(DOG,2)-2
            
            
            point = DOG(j,k,i);
            
            
            
            if point > DOG(j-1, k-1, i) && point > DOG(j-1, k,i) && point > DOG(j+1,k,i) ...
                    && point > DOG(j,k-1,i) && point > DOG(j,k+1,i) && point > DOG(j-1,k-1,i) ...
                    && point > DOG(j-1,k,i) && point > DOG(j-1,k+1,i)...
                    && point > DOG(j-1,k-1,i-1) &&point > DOG(j-1,k,i-1) && point > DOG(j-1,k+1,i-1)...
                    && point > DOG(j,k-1,i-1) && point > DOG(j,k,i-1) && point > DOG(j,k+1,i-1)...
                    && point > DOG(j-1,k-1,i-1) && point > DOG(j-1,k,i-1) && point > DOG(j-1,k+1,i-1)...
                    && point > DOG(j-1,k-1,i+1) &&point > DOG(j-1,k,i+1) && point > DOG(j-1,k+1,i+1)...
                    && point > DOG(j,k-1,i+1) && point > DOG(j,k,i+1) && point > DOG(j,k+1,i+1)...
                    && point > DOG(j-1,k-1,i+1) && point > DOG(j-1,k,i+1) && point > DOG(j-1,k+1,i+1)...
                    
                
                result(1,col) = k;
                result(2,col) = j;
                result(3,col) = i;
                col = col+1;
                
                
            else
                
                if point < DOG(j-1, k-1, i) && point < DOG(j-1, k,i) && point < DOG(j+1,k,i) ...
                        && point < DOG(j,k-1,i) && point < DOG(j,k+1,i) && point < DOG(j-1,k-1,i) ...
                        && point < DOG(j-1,k,i) && point < DOG(j-1,k+1,i)...
                        && point < DOG(j-1,k-1,i-1) &&point < DOG(j-1,k,i-1) && point < DOG(j-1,k+1,i-1)...
                        && point < DOG(j,k-1,i-1) && point < DOG(j,k,i-1) && point < DOG(j,k+1,i-1)...
                        && point < DOG(j-1,k-1,i-1) && point < DOG(j-1,k,i-1) && point < DOG(j-1,k+1,i-1)...
                        && point < DOG(j-1,k-1,i+1) &&point < DOG(j-1,k,i+1) && point < DOG(j-1,k+1,i+1)...
                        && point < DOG(j,k-1,i+1) && point < DOG(j,k,i+1) && point < DOG(j,k+1,i+1)...
                        && point < DOG(j-1,k-1,i+1) && point < DOG(j-1,k,i+1) && point < DOG(j-1,k+1,i+1)...
                        
                    
                    result(1,col) = k;
                    result(2,col) = j;
                    result(3,col) = i;
                    col = col+1;
                    
                    
                    
                end
                
                
            end
        end
    end
end