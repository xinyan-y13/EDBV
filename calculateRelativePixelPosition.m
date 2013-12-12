function [ interestPoints ] = calculateRelativePixelPosition( octaveInterestPoints, currentOctaveNumber )
%CALCULATERELATIVEPIXELPOSITION Summary of this function goes here
%   Detailed explanation goes here

interestPoints = [];

if (size(octaveInterestPoints,1) > 0)
    x = 2^(currentOctaveNumber - 1) * octaveInterestPoints(1,:);
    y = 2^(currentOctaveNumber - 1) * octaveInterestPoints(2,:);

    interestPoints = [interestPoints, [ x(:)'; y(:)' ]];
end

end

