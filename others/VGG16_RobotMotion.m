%回収後のboxの位置を調整し、ロボットアームを動かすプログラム

%% 初期化
clear;
close all;
clc;

%%
VGG16_RobotManipulator_1;

P_PCB_box       = [160, -240,270,-180,0,90,-3]; %PCB      の分類箱の座標
P_IC_box        = [355,  -100,290,-180,0,85,-3]; %IC       の分類箱の座標
% P_IC_box        = [160,  240,270,-180,0,90,-3]; %IC       の分類箱の座標
P_Connector_box = [160,    0,270,-180,0,90,-3]; %Connectorの分類箱の座標
P_Condenser_box = [160,  130,270,-180,0,90,-3]; %Condenserの分類箱の座標
P_Metal_box     = [160, -240,270,-180,0,90,-3]; %Metal    の分類箱の座標
% P_Metal_box     = [160, -130,270,-180,0,90,-3];%Metal    の分類箱の座標
P_Coil_box      = [250, 230,270,-180,0,90,-3]; %Coil     の分類箱の座標(未確定）
P_Unknown       = [350, 230,270,-180,0,90,-3]; %分類精度50%以下だった場合の移動先座標

P_tihara        = [355,-100,230,-180,40,85,-3];
P_tihara2       = [355,-100,270,-180,40,85,-3];

Arduino_On;
pause(1);
rob.Move(1,P_tihara2);
pause(1);
rob.Move(1,P_tihara);
pause(1);
rob.Move(1,P_tihara2);
pause(1);
% rob.Move(1,P_tihara);
% 
% pause(1);
% 
% caoExt.Execute('Chuck',1);
% pause(3);
% rob.Move(1,P_Metal_box);
% caoExt.Execute('UnChuck',2);
Arduino_Off;

% pause(0.5);
% 
% rob.Move(1,P_PCB_box);
% 
% pause(0.5);
% 
% caoExt.Execute('UnChuck',2);