function [ image_paths ] = readImagePaths( data_path )
%READIMAGEPATHS reads all image paths in data path (datapath)
%   
    images = dir(fullfile(data_path,'*.jpg'));
    image_paths = cell(size(images,1),1);
    for i=1:size(images,1)
        image_paths{i} = fullfile(data_path,images(i).name);
    end
end

