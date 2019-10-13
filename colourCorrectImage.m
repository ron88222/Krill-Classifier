function [normalisedImage] = colourCorrectImage(referenceImage,targetImage)
%TESTFUNC Normalises targetImage based on referenceImage (refimage, target image)
%   Normalises targetImage based on referenceImage


img = im2double(imread(referenceImage));
refpos = [582.500000000000,986.499999999999,4620,332];
%get backgroung
msk = imcrop(img,refpos);
im2 = im2double(imread(targetImage));
figure;
imshow(im2);
title('select blue background only')
h = imrect();
refpos = wait(h);
%refpos= refpos.getPosition();

msk2 = imcrop(im2,refpos);

%get mean values for rgb channels
r = msk(:,:,1);
g = msk(:,:,2);
b = msk(:,:,3);
r2 = msk2(:,:,1);
g2 = msk2(:,:,2);
b2 = msk2(:,:,3);

medR = median(r(:));
medG = median(g(:));
medB = median(b(:));

medR2 = median(r2(:));
medG2 = median(g2(:));
medB2 = median(b2(:));


%You need to divide each pixel within an image by the median of BG of THAT 
%image and then multiply by the median of BG of the REFERENCE image.

%divide each pixel by its own bg median

%disp('Dividing...');
temp = im2;
temp(:,:,1)=temp(:,:,1)/medR2;
temp(:,:,2)=temp(:,:,2)/medG2;
temp(:,:,3)=temp(:,:,3)/medB2;
im2 = temp;

%multiply each pixel by median bg of img 1
%disp('Multiplying...');
temp = im2;%(i,n,:);
temp(:,:,1)=temp(:,:,1)*medR;
temp(:,:,2)=temp(:,:,2)*medG;
temp(:,:,3)=temp(:,:,3)*medB;
normim2=temp;
%disp('Normalised!')

%normalise other images

normalisedImage = mat2gray(normim2);
normalisedImage = uint8(normalisedImage .* 255);
end

