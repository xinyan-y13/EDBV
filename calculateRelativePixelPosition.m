function [ interestPoints ] = calculateRelativePixelPosition( octaveInterestPoints, currentOctaveNumber )
% CALCULATERELATIVEPIXELPOSITION Calculates the pixel position of given
% IP's relative to image size of the first octave
% 
% INPUT PARAMS:
% 
% octaveInterestPoints - found IP's in octave
% currentOctaveNumber  - number/index of current octave
%
% OUTPUT PARAMS:
% 
% interestPoints - matrix with IP's and relative pixel position
%
% AUTHOR Bernd Artmueller (1127846)

interestPoints = [];

if (size(octaveInterestPoints,1) > 0)
    x = 2^(currentOctaveNumber - 1) * octaveInterestPoints(1,:);
    y = 2^(currentOctaveNumber - 1) * octaveInterestPoints(2,:);

    interestPoints = [interestPoints, [ x(:)'; y(:)' ]];
end

end

