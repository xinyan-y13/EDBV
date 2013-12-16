function [matching1 matching2] = matcher(desc1, ips1, desc2, ips2)
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
