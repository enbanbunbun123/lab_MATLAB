%学習モデル(転移学習)の精度を算出するプログラム

%% 初期化
clc;
clear all;
close all;

%% 検出器をロード
load('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\VGG16Transfer6_proto3_1_crop.mat', 'trainedNetwork_1');

%% データの読み込み
imds      = imageDatastore('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\proto_test','includeSubfolders',true,'LabelSource','foldernames');
Coil      = imageDatastore('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\proto_test\Coil');
Condenser = imageDatastore('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\proto_test\Condenser');
Connector = imageDatastore('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\proto_test\Connector');
IC        = imageDatastore('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\proto_test\IC');
Metal     = imageDatastore('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\proto_test\Metal');
PCB       = imageDatastore('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\proto_test\PCB');

%% 全体の精度評価
predictedlabels = classify(trainedNetwork_1,imds); %転移学習モデルによる画像の分類
VGG16_accuracy = mean(predictedlabels == imds.Labels) %転移学習モデルによる精度評価

%% 分類ごとの精度評価 
predictedlabels_Coil      = classify(trainedNetwork_1,Coil);      %転移学習モデルによるCoilの分類
predictedlabels_Condenser = classify(trainedNetwork_1,Condenser); %転移学習モデルによるCondenserの分類
predictedlabels_Connector = classify(trainedNetwork_1,Connector); %転移学習モデルによるConnctorの分類
predictedlabels_IC        = classify(trainedNetwork_1,IC);        %転移学習モデルによるICの分類
predictedlabels_Metal     = classify(trainedNetwork_1,Metal);     %転移学習モデルによるMetalの分類
predictedlabels_PCB       = classify(trainedNetwork_1,PCB);       %転移学習モデルによるPCBの分類

%精度の表示
Coil_accuracy      = mean(predictedlabels_Coil      == 'Coil') 
Condenser_accuracy = mean(predictedlabels_Condenser == 'Condenser')
Connector_accuracy = mean(predictedlabels_Connector == 'Connector')
IC_accuracy        = mean(predictedlabels_IC        == 'IC')
Metal_accuracy     = mean(predictedlabels_Metal     == 'Metal')
PCB_accuracy       = mean(predictedlabels_PCB       == 'PCB')

