bgp = csvread('bgpixels2.csv');
kp = csvread('krillpixels2.csv');



%quantize fg and bg histograms 
kquant = ceil(double(kp)/255*15)+1;
khist = zeros(16,16,16);
for i=1:size(kp,1)
	khist(kquant(i, 1), kquant(i, 2), kquant(i, 3)) = khist(kquant(i, 1), kquant(i, 2), kquant(i, 3)) + 1;
end

bgquant = ceil(double(bgp)/255*15)+1;
bghist = zeros(16,16,16);
for i=1:size(bgp,1)
	bghist(bgquant(i, 1), bgquant(i, 2), bgquant(i, 3)) = bghist(bgquant(i, 1), bgquant(i, 2), bgquant(i, 3)) + 1;
end
tempfilename ='KBGPixel';
save(tempfilename, 'khist', 'bghist' ,'kp', 'bgp');
%%
%test pixel
testim = imread('norm_JR255A_krill_image_2.jpg');
quantTestImg = ceil(double(testim)/255*15)+1;

%refpixel = [43,72,202];
%quantRefPixel = ceil(refpixel/255*15)+1;
%%
binarymask = zeros(size(quantTestImg,1),size(quantTestImg,2));
hf = zeros(size(quantTestImg,1),size(quantTestImg,2));
hb = zeros(size(quantTestImg,1),size(quantTestImg,2));
rhf2hb = zeros(size(quantTestImg,1),size(quantTestImg,2));

for i=  1:size(quantTestImg,1)
    for j= 1:size(quantTestImg,2)
        r = quantTestImg(i,j,1);
        g = quantTestImg(i,j,2);
        b = quantTestImg(i,j,3);
        quantRefPixel = [r,g,b];
        
        
        kNoP = khist(quantRefPixel(1),quantRefPixel(2),quantRefPixel(3));
        bgNoP = bghist(quantRefPixel(1),quantRefPixel(2),quantRefPixel(3));

        hf(i,j) = kNoP/size(kp,1);
        hb(i,j) = bgNoP/size(bgp,1);
        rhf2hb(i,j) = hf(i,j)/(hb(i,j)+eps);

%         T1 = 0.0007;
%         T2 = 0.0007;
%         if hf > T1 && (hf/hb) > T2
%             binarymask(i,j) = 1;
%         end
        
        
        
    end
end
%%
%idx = rhf2hb>300;
%figure;imshow(hf./max(hf(:)))
%idx2 = hf>0.0025;

%figure;imshow(rhf2hb./500)
%binary mask
%%
idx =  (rhf2hb./500)>0.7;
figure;imshow(idx);title('before noise reduction');

%remove noise


se = strel('disk',8);
im = imclose(idx,se);

im = bwareaopen(im,1000);
 
se = strel('disk',3);
im = imerode(im,se);
% 
% 
se = strel('disk',30);
im = imclose(im,se);
% 
se = strel('disk',5);
im = imopen(im,se);
% 
im = bwareaopen(im,2500);

figure;imshow(im);title('after noise reduction');
%%
boundingboxes = regionprops(bwlabel(im),'BoundingBox');
nokrill = size(boundingboxes,1);
boundingboxes = cell2mat(struct2cell(boundingboxes));
boundingboxes = reshape(boundingboxes,[4,nokrill]);

%%
[krillinfo,krillinfo1] = xlsread('JR255a length frequency krill.xls','Ev2_2','A2:F97');
kevent = krillinfo(:,1);
ktype = krillinfo1(:,1);
knet = krillinfo(:,3);
klength = krillinfo(:,4);
kmaturity = krillinfo1(:,4);
kcomment = krillinfo1(:,5);


%% scan algorithm
%imagedata = zeros(50,6);
%imagedata1 = zeros(50,6);

orderedKrill = zeros(50,4);

for i=1:nokrill
    xMin = boundingboxes(1,i);
    yMin = boundingboxes(2,i);
    width = boundingboxes(3,i);
    height = boundingboxes(4,i);
    
    orderedKrill(i,:) = [xMin, yMin, width, height];
    
    %pair information with image
    %croppedimage = imcrop(testim, [xMin, yMin, width, height]);
    %imagedata(i,:) = ([xMin, yMin, width, height, kmaturity(i), klength(i)])%filepath
    %imagedata1(i,:) = ([]);
end
%%
imsegment = (size(testim,2) / 6);
row1=zeros(50,4);
row2=zeros(50,4);
row3=zeros(50,4);
row4=zeros(50,4);
row5=zeros(50,4);
for i=1:nokrill
    meanheight = orderedKrill(i,2) + (orderedKrill(i,4)/2);
    xMin = orderedKrill(i,1);
    yMin = orderedKrill(i,2);
    width = orderedKrill(i,3);
    height = orderedKrill(i,4);
    
    if (meanheight < 1200)
        row1(i,:) =  [xMin, yMin, width, height];
    elseif (meanheight < 1800)
        row2(i,:) =  [xMin, yMin, width, height];
    elseif (meanheight < 2550)
        row3(i,:) =  [xMin, yMin, width, height];
    elseif (meanheight < 3300)
        row4(i,:) =  [xMin, yMin, width, height];
    elseif (meanheight > 3300)
        row5(i,:) =  [xMin, yMin, width, height];
    end
end


%%
krillvectors = cell(1,7);

ac = 1;
for i=1:5
    if i==1
        r=row1;
    end
    if i==2
        r=row2;
    end
    if i==3
        r=row3;
    end
    if i==4
        r=row4;
    end
    if i==5
        r=row5;
    end
    b = sort(r,1,'ascend');
    %n = 1;
    for n=1:50
        if b(n,1) ~= 0
            if n == 36
                krillinfo1(n,4)
            end
            
            %%%%%%% N NOT WORK BUT 36 DOES%%%%%%%%%%%%%%%%%%%%%%%
            temp = {b(n,1),b(n,2),b(n,3),b(n,4),krillinfo1(ac,4),krillinfo(ac,4),'Lateral'}
            krillvectors(ac,:) = temp;
            ac = ac + 1;
        end
        %n = n + 1;
    end
end
save('KV', 'krillvectors');
%[r,c] = find(labeledim==2);
%rc = [r,c];
%im = imopen(imclose(idx,se),se)