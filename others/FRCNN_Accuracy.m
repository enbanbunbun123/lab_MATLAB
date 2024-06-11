%学習モデルの精度を算出するプログラム

%% 初期化
clc;
clear all;
close all;

%% 検出器をロード
load('C:\研究(ロボットマニピュレータ)\MATLAB_研究\1_net\net_9\net_9_a_rgb750_320240_3.mat','detector');

%% データの読み込み
imds      = imageDatastore('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\ChangeCheckImages','includeSubfolders',true,'LabelSource','foldernames');
Coil      = imageDatastore('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\ChangeCheckImages\Coil');
Condenser = imageDatastore('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\ChangeCheckImages\Condenser');
Connector = imageDatastore('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\ChangeCheckImages\Connector');
IC        = imageDatastore('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\ChangeCheckImages\IC');
Metal     = imageDatastore('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\ChangeCheckImages\Metal');
PCB       = imageDatastore('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\ChangeCheckImages\PCB');

%% 単独画像の分類
im = imread("Condenser1.jpg");
[bboxes, score, label] = detect(detector, im); %RCNNによる画像の分類
% 
% FRCNN_accuracy = mean(label == 'Condenser') %RCNNによる精度評価
TVal=0.97;
ixx = 1;
for i=1:size(score)
         a=bboxes(i,1)+(bboxes(i,3)/2);
%          b=bboxes(i,2)+(bboxes(i,4)/2);
         if score(i)>=TVal && a>30 && a<270 
             sscore(ixx) = score(i);
             bbox(ixx,:) = bboxes(i,:);
             label_str{ixx} = char(string(label(i)));
             box_x(ixx) = bbox(ixx,1)+(bbox(ixx,3)/2);
             box_y(ixx) = bbox(ixx,2)+(bbox(ixx,4)/2);
             box_width(ixx) = bbox(ixx,3); 
%              ixx = ixx+1;
         end
end
pause(0.02);
    if exist('bbox','var')
             outputImage = insertObjectAnnotation(im, 'rectangle', bbox,...
                 label_str,'FontSize', 10,'LineWidth',3,'Color','blue');
             out = [im outputImage];
            imshow(out);
            Box_x = box_x(:,1);
            Box_y = box_y(:,1);
            Box_width = box_width(:,1);
            all_data = horzcat(label_str.',num2cell(sscore.'),num2cell(box_x.'),num2cell(box_y.'),num2cell(box_width.'));   
            all_data = sortrows(all_data,4,'descend');
    end