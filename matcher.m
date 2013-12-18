function [matches1 matches2] = matcher(desc1, ips1, desc2, ips2)
%--------------------------------------------------------------%
%---------------------- DoG Pyramid for SIFT-------------------%

% matcher uses the descriptors and the locations of the intrest
% points found in previous stages and matches them to each
% other
% 
% INPUT PARAMS:
% 
% desc1, desc2    the descriptors of the IPs
% ip1, ip2        the locations of the IPs
%
%
% OUTPUT PARAMS:
% 
% matching1       matching IPs in the first image
% matching2       matching IPs in the second image
%
%
% AUTHOR Balint Kovacs (1227520)
%--------------------------------------------------------------%
ratio = 0.7

desc1 = desc1';
matches = zeros(1,size(desc2,1));
for i = 1:size(desc1,1)
   dot = desc1(i,:) * desc2;
   [values,index] = sort(acos(dot));
   
   if (values(1) < ratio * values(2))
      indicies(i) = index(1);
   else
      indicies(i) = 0;
   end
end
dlmwrite('matches.txt',indicies);

idx1 = find(indicies);
idx2 = indicies(idx1);
x1 = ips1(1,idx1);
x2 = ips2(1,idx2);
y1 = ips1(2,idx1);
y2 = ips2(2,idx2);

matches1(1,:) = x1;
matches1(2,:) = y1;
matches2(1,:) = x2;
matches2(2,:) = y2;

end

