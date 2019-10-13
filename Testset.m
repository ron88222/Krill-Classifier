img = imread('norm_JR255A_krill_image_2.jpg');
imshow(img)

%
BW=roipoly(img);
%BW = imrect;
%BW = wait(BW);
%BW = imcrop(img,BW);

imR = img(:,:,1);
Rpixels = imR(BW);
imG = img(:,:,2);
Gpixels = imG(BW);
imB = img(:,:,3);
Bpixels = imB(BW);

pixels = [Rpixels Gpixels Bpixels];

%dlmwrite('krillpixels.csv', pixels, 'delimiter',',');
dlmwrite('bgpixels2.csv', pixels, 'delimiter',',','-append');
%k = csvread('krillpixels.csv');


%KrillMasks1 = cat(1,KrillMasks1,BW);
%KrillMasks1(:,:,1) = BW


% for i= 1:size(BW,1)
%     for n= 1:size(BW,2)
%         if BW(i,n) == 1
%             img(i,n);
%         end
%     end
% end

%bwarea(BW)
