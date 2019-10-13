img = imread('JR255A_krill_image_1.jpg');
%img = imresize(img, 0.2); resize makes image pixelated
imshow(img);
imgdata = img;

%allow user rect select
h = imrect;
pos = wait(h);
cimg = imcrop(img,pos);
imshow(cimg);

%quantisedimg = ceil(double(imgdata)/255*15)+1;
quantisedimg = ceil(double(cimg)/255*15)+1;
imshow((quantisedimg-1)/15);
imwrite((quantisedimg-1)/15, 'quantisedimg.jpg');


%imgdata = reshape(imgdata,size(imgdata,1)*size(imgdata,2),3)+1;
%r=imgdata(:,:,1);
%g=imgdata(:,:,2);
%b=imgdata(:,:,3);
hist = zeros(16,16,16);

for i=1:size(quantisedimg,1)
    hist(quantisedimg(i, 1), quantisedimg(i, 2), quantisedimg(i, 3)) = hist(quantisedimg(i, 1), quantisedimg(i, 2), quantisedimg(i, 3)) + 1;
end;
%hist = (r,g,b);


%imhist(hist);

