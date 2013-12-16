function matches = matcher(desc1, ips1, desc2, ips2)
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
ratio = 0.8

desc2 = desc2';
matches = zeros(1,size(desc1,2));
for i = 1:size(des1,2)
   dot = desc1(:,i) * des2t;
   [values,index] = sort(acos(dot));
   
   if (values(1) < ratio * values(2))
      indicies(i) = index(1);
   else
      indicies(i) = 0;
   end
end

for i=1:size(matches)
    matches(1,i) = ips1(1,i);
    matches(2,i) = ips1(2,i);
    matches(3,i) = ips2(1,i);
    matches(4,i) = ips2(2,i);
end

