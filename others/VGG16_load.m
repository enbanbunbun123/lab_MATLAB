%学習後のモデルをロードしてテストを行うプログラム

%% リセット
clear;
close all;
clc;

im = imread('CheckerBoard1001.jpg');
imshow(im)
%%  検出器をロード
% load('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\VGG16Transfer_2.mat', 'myNet');
% load('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\VGG16Transfer6_proto2.mat', 'trainedNetwork_1');

%% VGG16転移学習モデルによる分類チェック

% im = imread('Unknown_1026_6_0.jpg');
% im_Resize=imresize(im,[224 224]);
% [VGG16_label,VGG16_score] = trainedNetwork_1.classify(im_Resize);
% VGG16_score
% VGG16_label
%      
% BW = imbinarize(rgb2gray(im));     % カラー⇒グレースケール⇒二値化
% BW = imopen(BW,strel('disk',10));
% 
% %VGG16転移学習モデルでの検出
% %[bboxes, score, label] = myNet.classify(im_Resize);
% answer = net.classify(im_Resize)
% 
% bbox = [62 62 100 100];
% 
% numObservations = 4;
% images = repelem({'C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\checkImages\condenser'},numObservations,1);
% bboxes = repelem({bbox},numObservations,1);
% labels = repelem({answer},numObservations,1);
% 
% imds = imageDatastore(images);
% 
% tbl = table(bboxes,labels);
% blds = boxLabelDatastore(tbl);
% 
% trainingData = combine(imds,blds);
% 
% data = read(trainingData);
% %I = data{1};
% bboxes = data{2};
% labels = data{3};
% 
% annotatedImage = insertObjectAnnotation(im_Resize,'rectangle',bbox,labels, ...
%     'LineWidth',8,'FontSize',40);
% % imshow(annotatedImage)
% 
% i = 1:size(bbox,1)
% 
% % 
% % for i = 1:size(bbox,1)
% %     crop{i} = imcrop(BW, bbox(i,:)); % 1つ1つトリミングする(一部はくっついたまま)
% %     if any([crop{i}(1,:) crop{i}(end,:) crop{i}(:,1)' crop{i}(:,end)'])
% %         crop{i} = ~crop{i}; % Bounding Boxの境界に他の細胞が写り込んだら反転表示
% %     end
% % end
% 
% I2 = imcrop(I,outputImage);%トリミングされたイメージを表示
% 
% subplot(1,2,2)
% imshow(I2)
% title('Cropped Image')
%           
% imshow(crop)
%% カメラのキャリブレーションと座標設定
% % CameraCalibration_1;
% % close 1;
% % close 2;
% cam = webcam;
% cam.Resolution = '320x240';
% %  cam = webcam('USB Camera');
% %   cam.Resolution='320x240';
% im = snapshot(cam);
% 転移学習モデルによる分類

% cam = webcam('USB_Camera');
% im = snapshot(cam);
% % im = imread('test_5.jpg');
% im_Resize=imresize(im,[224 224]);
% [label, score] = net.classify(im_Resize);
% label
% [score] = (max(score)*100+"%")
% imshow(im_Resize) 

%% Fast-R CNNによる分類
% load('C:\研究(ロボットマニピュレータ)\MATLAB_研究\1_net\net_9_a_rgb750_320240_3.mat','detector');
% % im = imread('test_5.jpg');
% im_Resize=imresize(im,[224 224]);
%  [bboxes, score, label] = detect(detector, im_Resize);
% %  label
% %  score=(max(score)*100+"%")
%  imshow(im_Resize)
% 
%  TVal = 0.97;
%  ixx = 1;
% 
%    for i=1:size(score)
%          a=bboxes(i,1)+(bboxes(i,3)/2);
% %          b=bboxes(i,2)+(bboxes(i,4)/2);
%          if score(i)>= TVal && a>30 && a<270
%              sscore(ixx) = score(i);
%              bbox(ixx,:) = bboxes(i,:);
%              label_str{ixx} = char(string(label(i)));
%              box_x(ixx) = bbox(ixx,1)+(bbox(ixx,3)/2);
%              box_y(ixx) = bbox(ixx,2)+(bbox(ixx,4)/2);
%              box_width(ixx) = bbox(ixx,3); 
%              ixx = ixx+1;
%          end
%    end
%  %% save
%   cam = webcam('USB_Camera');
%   im = snapshot(cam);                   
% 
% %画像の保存                 
%         fx1=figure(1);
%     str1=append("Metal_","25",".jpg");
%     img1 = im;
%     image(img1);
%     imwrite(img1,str1);
%         j=j+1;

% %     cam.Resolution='320x240';
%     fx1=figure(1);
%     str1=append("Check_", int2str(i),".jpg");
% %     img1 = snapshot(cam);
%     image(im);
%     imwrite(im,str1);
%         i=i+1;
%% HOG機能によって物体検出→検出部分のみ切り取り→myNetにて分類
