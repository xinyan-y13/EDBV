
% Masking image to remove unnecessary 
[maskedI center] = detectCard('./test/test4.jpg');

% Creating Difference-of-Gaussian array
octaves = 4;
intervals = 4;

dogArray = createDog(maskedI, octaves, intervals );


% Transforming each octave to 3d matrix
octave1 = cell2mat(dogArray(1,1));
for i = 2:intervals,
     octave1(:,:,i) = cell2mat(dogArray(1,i));
end

octave2 = cell2mat(dogArray(2,1));
for i = 2:intervals,
     octave2(:,:,i) = cell2mat(dogArray(2,i));
end

octave3 = cell2mat(dogArray(3,1));
for i = 2:intervals,
     octave3(:,:,i) = cell2mat(dogArray(3,i));
end

octave4 = cell2mat(dogArray(4,1));
for i = 2:intervals,
     octave4(:,:,i) = cell2mat(dogArray(4,i));
end


%Looking for extremes in each octave
oct1ext = localExt(octave1,1);
oct2ext = localExt(octave2,1);
oct3ext = localExt(octave3,1);
oct4ext = localExt(octave4,1);


%Localizing extrema with subpixel precision
oct1extSp = subpixel(oct1ext,octave1,0.5,10);
oct2extSp = subpixel(oct2ext,octave2,0.5,10);
oct3extSp = subpixel(oct3ext,octave3,0.5,10);
oct4extSp = subpixel(oct4ext,octave4,0.5,10);


%Calculating orientation
frames1 = orientation(oct1extSp, octave1);
frames2 = orientation(oct2extSp, octave2);
frames3 = orientation(oct3extSp, octave3);
frames4 = orientation(oct4extSp, octave4);

































