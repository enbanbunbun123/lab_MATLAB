%% 初期化
clear;
close all;
clc;

%% 転移学習モデルのヒートマップによる評価
load('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\VGG16Transfer6_proto3_2_crop.mat', 'trainedNetwork_1');

im = imread('Coil_test_13_3.jpg')
[label,score] = trainedNetwork_1.classify(im);

map = gradCAM(trainedNetwork_1,im,label);


imshow(im);
hold on;
imagesc(map,'AlphaData',0.5);
colormap jet
hold off;
% title("3_1");