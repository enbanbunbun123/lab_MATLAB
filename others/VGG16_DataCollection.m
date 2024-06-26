% 転移学習に用いる学習データセット作成のためのプログラム
% 信頼度が70%以下の場合に画像を保存する
% ただし、想定よりも画像の収集ができない時には、信頼度の値を変更して画像を収集する


%% loop 
% あらかじめ決められた分類箱の座標を定義(小型ロボットマニピュレータの座標系)
P_PCB_box       = [160, -240,270,-180,0,90,-3]; %PCB      の分類箱の座標
P_IC_box        = [160,  240,270,-180,0,90,-3]; %IC       の分類箱の座標
P_Connector_box = [160,    0,270,-180,0,90,-3]; %Connectorの分類箱の座標
P_Condenser_box = [160,  130,270,-180,0,90,-3]; %Condenserの分類箱の座標
P_Metal_box     = [160, -130,270,-180,0,90,-3]; %Metal    の分類箱の座標
P_Coil_box      = [160, -130,270,-180,0,90,-3]; %Coil     の分類箱の座標(未確定）
P0              = [210,    0,325,-180,0,0 ,-3]; %分類精度50%以下だった場合の移動先座標（仮）

D_Num=0;
xi=0;
yi=1;
TB=tic;
while(1)
   
    % 以下の変数以外を削除
     clearvars -except three_classification_FRCNN detector...
         cam fx...
         cameraParams R t...
         cao caoExt ctrl ws rob state...
         P_PCB_box P_IC_box P_Connector_box P_Condenser_box P_Metal_box P1...
         TVal  X_M X_D Y_M Y_D...
         Z_arm class_label Belt_Speed PickT xi yi D_Num Length TB ...
         Detect_List List_Time...
         G_a G_b R_late RX_a RX_b net...
         VGG16_Score trainedNetwork_1 P0　P_Coil_box 
     
     %% 物体の検出、分類
     if D_Num==0
         Time_Belt=1000000;
         D_Num=1;
     else
         Time_Belt=toc(TB);
     end
     Move=Belt_Speed*Time_Belt;
     if Move>Length
         d1=0;
         for www=1:10
             if d1==0;
                 im = snapshot(cam);               
                 % Filter image to make it smooth for easier checking
                 % im = imgaussfilt(im,0.5);
                 % detectorによって'PCB基板','金属','コネクタ'を検出する．
                 time_detect=tic;
                 [bboxes, score, label] = detect(detector, im);
                 
                 TB=tic;
                 % 闘値による篩い
                 ixx = 1;
     for i=1:size(score)
         a=bboxes(i,1)+(bboxes(i,3)/2);
%          b=bboxes(i,2)+(bboxes(i,4)/2);
         if score(i)>=TVal && a>30 && a<270 
             sscore(ixx) = score(i);%
             bbox(ixx,:) = bboxes(i,:);
             label_str{ixx} = char(string(label(i)));%
             box_x(ixx) = bbox(ixx,1)+(bbox(ixx,3)/2);
             box_y(ixx) = bbox(ixx,2)+(bbox(ixx,4)/2);
             box_width(ixx) = bbox(ixx,3); 
             ixx = ixx+1;%

%              cropsize = bbox(1,[1:4]); %[画像左上のx座標、画像左上のｙ座標、トリミング画像の横幅、トリミング画像の縦幅]
             bbox_X = bbox(1,1)-50;%トリミング画像の左上x座標
             bbox_Y = bbox(1,2)-50;%トリミング画像の左上y座標
             bbox_Beside = bbox(1,3)+100;%横幅
             bbox_Vertical = bbox(1,4)+100;%縦幅
             cropsize = [bbox_X bbox_Y bbox_Beside bbox_Vertical];%トリミングサイズの補正

             CropImage = imcrop(im,cropsize);%入力の画像をcropsizeでトリミング
%              subplot(1,2,2);            
%              imshow(CropImage);
%              title('Cropped Image');
             im_Resize=imresize(CropImage,[224 224]);%トリミング画像のリサイズ
             [VGG16_label,VGG16_score] = trainedNetwork_1.classify(im_Resize);  %VGG16の転移学習モデルで画像の分類              
             VGG16_Score = max(VGG16_score);   
%              disp(VGG16_label) %分類結果の表示
%              imshow(im_Resize);

             VGG16_label_str= cellstr(VGG16_label);%セル行列への変換              

             if VGG16_Score <= 0.70 %scoreが70%以下だった場合、unknownとして画像を保存
                 fx1=figure(1);
                 str1=append("UnKnown_1129_9_", int2str(j),".jpg");
                 img1 = im_Resize;
%                  image(img1);
                 imwrite(img1,str1);
                  disp([VGG16_label_str,VGG16_Score,int2str(j)])%信頼度、分類結果の表示
                 j=j+1; 
             end
         end
     end  
             end
         end
     end
end
