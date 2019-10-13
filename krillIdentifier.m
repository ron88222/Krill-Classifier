function [boundingboxes] = krillIdentifier(targetImage, threshold)
    %testim = imread(targetImage);
    testim = targetImage;
    %qauntised
    %quantTestImg = testim;
    quantTestImg = ceil(double(testim)/255*15)+1;
    
    %quantTestImg = (quantTestImg-1)/15;
    %load in krill hist and bg hist
    load('KBGPixel');
    
    %%
    %initialise
    binarymask = zeros(size(quantTestImg,1),size(quantTestImg,2));
    hf = zeros(size(quantTestImg,1),size(quantTestImg,2));
    hb = zeros(size(quantTestImg,1),size(quantTestImg,2));
    rhf2hb = zeros(size(quantTestImg,1),size(quantTestImg,2));
    
    %populate histograms
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
        end
    end
    
    
    %%
    
    idx =  (rhf2hb./500)>0.7;
    %figure;imshow(idx);title('before noise reduction');

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
    se = strel('disk',threshold);
    im = imopen(im,se);
    % 
    im = bwareaopen(im,2500);

    figure;imshow(im);title('after noise reduction');
    %% fill any extra space
    noisyarea = roipoly(im);
    
    for i=  1:size(im,1)
        for j= 1:size(im,2)
            if im(i,j) == 1 && noisyarea(i,j) == 1
                im(i,j) = 0;
            end
        end
    end
    %im = regionfill(im, noisyarea)
    %%
    
    %get bounding boxes
    boundingboxes = regionprops(bwlabel(im),'BoundingBox');
    nokrill = size(boundingboxes,1);
    boundingboxes = cell2mat(struct2cell(boundingboxes));
    boundingboxes = reshape(boundingboxes,[4,nokrill]);
    
    
end