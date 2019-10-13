function [krillvectors] = createDataSet(boundingboxes, eventcode, exelcoord, boardnumber, targetim)
    [krillinfo,krillinfo1] = xlsread('JR255a length frequency krill.xls',eventcode,exelcoord);
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
    nokrill = size(boundingboxes,2);
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
    %%testim = imread(targetim);
    testim = targetim;
    testim = ceil(double(testim)/255*15)+1;
    
    
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
        b = sortrows(r,1);
        %n = 1;
        for n=1:50
            if b(n,1) ~= 0
                %krillinfo1(n,4)
                %%%%%%% N NOT WORK BUT 36 DOES%%%%%%%%%%%%%%%%%%%%%%%
                f = fullfile('trainingData',krillinfo1{ac,4},strcat(eventcode,'-',num2str(ac),'-b',boardnumber,'.jpg'));
                croppedimage = imcrop(targetim, [b(n,1),b(n,2),b(n,3),b(n,4)]);
                %make all the same size
                %length
                if(size(croppedimage,2) < 1500)
                    if(rem(size(croppedimage,2),2)~=0)
                        existingpixel = (750-(size(croppedimage,2)/2))-0.5;
                        
                        padding1 = zeros(size(croppedimage,1),existingpixel,3);
                        padding1(:,:,1) = zeros(size(croppedimage,1),existingpixel)+70;
                        padding1(:,:,2) = zeros(size(croppedimage,1),existingpixel)+130;
                        padding1(:,:,3) = zeros(size(croppedimage,1),existingpixel)+255;
                        
                        padding = zeros(size(croppedimage,1),existingpixel+1,3);
                        padding(:,:,1) = zeros(size(croppedimage,1),existingpixel+1)+70;
                        padding(:,:,2) = zeros(size(croppedimage,1),existingpixel+1)+130;
                        padding(:,:,3) = zeros(size(croppedimage,1),existingpixel+1)+255;
                        
                        croppedimage = [padding croppedimage padding1];
                    else
                        existingpixel = 750-(size(croppedimage,2)/2);
                        
                        padding = zeros(size(croppedimage,1),existingpixel,3);
                        padding(:,:,1) = zeros(size(croppedimage,1),existingpixel)+70;
                        padding(:,:,2) = zeros(size(croppedimage,1),existingpixel)+130;
                        padding(:,:,3) = zeros(size(croppedimage,1),existingpixel)+255;
                        
                        croppedimage = [padding croppedimage padding];
                    end
                   
                    
                end
                %width
                if(size(croppedimage,1) < 350)
                    if(rem(size(croppedimage,1),2)~=0)
                        existingpixel = (175-(size(croppedimage,1)/2))-0.5;
                        
                        padding1 = zeros(existingpixel,1500,3);
                        padding1(:,:,1) = zeros(existingpixel,1500)+70;
                        padding1(:,:,2) = zeros(existingpixel,1500)+130;
                        padding1(:,:,3) = zeros(existingpixel,1500)+255;
                        
                        padding = zeros(1+existingpixel,1500,3);
                        padding(:,:,1) = zeros(1+existingpixel,1500)+70;
                        padding(:,:,2) = zeros(1+existingpixel,1500)+130;
                        padding(:,:,3) = zeros(1+existingpixel,1500)+255;
                        
                        croppedimage = [padding;croppedimage;padding1];
                    else
                        existingpixel = 175-(size(croppedimage,1)/2);
                        
                        padding = zeros(existingpixel,1500,3);
                        padding(:,:,1) = zeros(existingpixel,1500)+70;
                        padding(:,:,2) = zeros(existingpixel,1500)+130;
                        padding(:,:,3) = zeros(existingpixel,1500)+255;
                        
                        croppedimage = [padding;croppedimage;padding];
                    end
                    
                end
                %save image
                imwrite(croppedimage,f);
                temp = {b(n,1),b(n,2),b(n,3),b(n,4),krillinfo1(ac,4),krillinfo(ac,4),'Lateral'};
                krillvectors(ac,:) = temp;
                ac = ac + 1;
            end
            %n = n + 1;
        end
    end
    
end