%% 物体検出器及び物体位置特定プログラム

%% 初期化
clear;
close all;
clc;

% %% カメラのキャリブレーションと座標設定
CameraCalibration_VGG16;
close 1;
close 2;

%% ロボットマニピュレータとの接続と動作確認
VGG16_RobotManipulator_1;

%% 検出器をロード
% load('C:\研究(ロボットマニピュレータ)\MATLAB_研究\1_net\net_9\net_9_a_rgb750_320240_3.mat','detector');
load('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\検出器\net_9_a_rgb750_320240_3.mat','detector');

%VGG16の転移学習モデルをロード(5種類学習モデル)
% load('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\VGG16Transfer_4.mat', 'net');

%VGG16の転移学習モデルをロード(6種類学習モデル)
% load('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\VGG16Transfer6_3.mat', 'trainedNetwork_1');
load('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\VGG16Transfer6_proto3_3_crop.mat', 'trainedNetwork_1');

%% 検出とピックアップ
% 座標補正値
X_M=1.204;
X_D=425; 
Y_M=1.2545;
Y_D=-468.8715;
% グリッパ―値
G_W=50;
G_F=40;
G_B=18;
G_X=10;
G_a=(G_W - G_X)/(G_B - G_F);
G_b=(-G_W/2)-(G_a * G_F);
% システム初期値
TVal=0.97;
Z_arm = 227;
class_label ={'PCB','IC','Connector','Condenser','Metal','Coil',}; 
Belt_Speed=1000/64.98;  %%(mm/s)
PickT=10;
Length=200; %(mm)
% ロボットアームの動作による遅延
% Y軸
R_late=1.33*Belt_Speed;
% X軸
RX_a=0.6/100;
RX_b=-RX_a*370;

VGG16_Loop_2;

%　転移学習の学習用データ取得の際には、以下の関数をコメント解除し実行する
% VGG16_DataCollection;