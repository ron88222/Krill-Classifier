img = imread('JR255A_krill_image_1.jpg');
imshow(img);
imgdata = img;

%get backgroung and foregroung hist
%define mask for bg

h = imrect;
pos = wait(h);

msk = imcrop(img,pos);
quantisedimg = ceil(double(msk)/255*15)+1;
%im2 = imread('JR255A_krill_image_2.jpg');
%cim2 = imcrop(im2, pos);
%imshow(cim2);

imshow((quantisedimg-1)/15);

%get median bg colour
hist = zeros(16,16,16);

for i=  1:size(quantisedimg,1)
    hist(quantisedimg(i, 1), quantisedimg(i, 2), quantisedimg(i, 3)) = hist(quantisedimg(i, 1), quantisedimg(i, 2), quantisedimg(i, 3)) + 1;
end
b=quantisedimg(:,:,3);
m = median(hist);
imshow((b-1)/15);

%medR = quantisedimg(:,:,1);
%medG = quantisedimg(:,:,2);
%medB = quantisedimg(:,:,3);
imshow((quantisedimg-1)/15);

%normalise colour
