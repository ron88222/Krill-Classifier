load('KV');
% [~,idx] = max(cell2mat(krillvectors(:,3)).*cell2mat(krillvectors(:,4)));
% maxbb = cell2mat([krillvectors(idx,3),krillvectors(idx,4)]);
% 
% %find center point of all krill
% for i=1:size(krillvectors,1)
%     midx = cell2mat(krillvectors(i,1)) + (cell2mat(krillvectors(i,3))/2);
%     midy = cell2mat(krillvectors(i,2)) + (cell2mat(krillvectors(i,4))/2);
%     xmin = midx - (maxbb(1,1)/2);
%     ymin = midy - (maxbb(1,2)/2);
%     krillvectors(i,1) = num2cell(xmin);
%     krillvectors(i,2) = num2cell(ymin);
%     krillvectors(i,3) = num2cell(maxbb(1,1));
%     krillvectors(i,4) = num2cell(maxbb(1,2));
%     %net = resnet50();
% end

%make maxbb around point

%%
%nnstart
data_path = 'U:\Documents\Year 3\Final year project(1)\trainingdata';
%imm = imread('norm_JR255A_krill_image_2.jpg');
%krilldata = imcrop(imm, krillvectors(1,1), krillvectors(1,2), krillvectors(i,3), krillvectors(i,4));
krilldata = imageDatastore(data_path,'IncludeSubfolders',true,'LabelSource','foldernames');
trainingFiles = 1;

[trainData,valData] = splitEachLabel(krilldata,trainingFiles,'randomize');
numClasses = numel(categories(trainData.Labels));
layers = [
    imageInputLayer([350,1500,3])
    
    convolution2dLayer(3,8)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding',1)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding',1)
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer
    ];
% options = trainingOptions('sgdm','MaxEpochs',3,...
%   'InitialLearnRate',0.01);
options = trainingOptions('sgdm',...
    'MaxEpochs',2, ...
    'InitialLearnRate',0.01,...
    'ValidationData',valData,...
    'ValidationFrequency',30,...
    'Verbose',false,...
    'MiniBatchSize',10,...
    'Plots','training-progress');

net = trainNetwork(trainData,layers,options);

%YPred = classify(net,valData);
%YValidation = valData.Labels;
%accuracy = sum(YPred == YValidation)/numel(YValidation)
