%% read all image paths
%data_path = './Krill Images - Sorted/';
image_paths = cell(108,1);
%image_paths = readImagePaths(data_path);

%sort image paths 
for i=1:108
    image_paths(i,1) = cellstr(strcat('.\Krill Images - Sorted\JR255A_krill_image_', num2str(i) ,'.JPG')); 

end

%% For loading in new images into dataset
for i=1: 1
    %colour correction
    normalisedIm = colourCorrectImage(image_paths{1},image_paths{100});
    
    %get Krill BB
    boundingboxes = krillIdentifier(normalisedIm, 4);
    %attach corrosponding excel file to BB
    krillvectors = createDataSet(boundingboxes, 'Ev97_2', 'A77:F101','4', normalisedIm);
end

