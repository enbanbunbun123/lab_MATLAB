%学習後のモデルの精度をプロットして出力するプログラム

%% リセット
clc;
clear all;
close all;

% [XTrain,YTrain] = digitTrain4DArrayData;
% 
% idx = randperm(size(XTrain,4),1000);
% XValidation = XTrain(:,:,:,idx);
% XTrain(:,:,:,idx) = [];
% YValidation = YTrain(idx);
% YTrain(idx) = [];

%% VGG16の読み込み、層の表示
net = vgg16;
layers = net.Layers;

%% 独自の分類をするためのネットワークを変更
%numClasses = numel(cetegories(imds.Labels));
layers(39) = fullyConnectedLayer(5);
layers(41) = classificationLayer
%% データの読み込み
imds = imageDatastore('ChangemyImages','includeSubfolders',true,'LabelSource','foldernames');


%% トレーニングデータのセット
[trainImages,testImages] = splitEachLabel(imds,0.7,'randomize');

%% ネットワークの再学習
% options = trainingOptions("sgdm", ...
%     MaxEpochs=8, ...
%     ValidationData={XValidation,YValidation}, ...
%     ValidationFrequency=30, ...
%     Verbose=false, ...
%     Plots="training-progress");

% options = trainingOptions("sgdm", ...
%     LearnRateSchedule="piecewise", ...
%     LearnRateDropFactor=0.1, ...
%     LearnRateDropPeriod=10, ...
%     InitialLearnRate=0.001,...
%     ValidationFrequency=390, ...
%     MaxEpochs=20, ...
%     MiniBatchSize=10, ...
%     Plots="training-progress")

opts = trainingOptions("sgdm",...
    "ExecutionEnvironment","auto",...
    "InitialLearnRate",0.001,...
    "MaxEpochs",20,...
    "MiniBatchSize",64,...
    "Shuffle","every-epoch",...
    "ValidationFrequency",5,...
    "Plots","training-progress",...
    "ValidationData",augimdsValidation);

net = trainNetwork(trainImages,layers,options);

