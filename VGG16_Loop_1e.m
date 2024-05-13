%% loop 
% あらかじめ決められた分類箱の座標を定義(小型ロボットマニピュレータの座標系)
P_PCB_box       = [160, -240,270,-180,0,90,-3]; %PCB      の分類箱の座標
P_IC_box        = [160,  240,270,-180,0,90,-3]; %IC       の分類箱の座標
P_Connector_box = [160,    0,270,-180,0,90,-3]; %Connectorの分類箱の座標
P_Condenser_box = [160,  130,270,-180,0,90,-3]; %Condenserの分類箱の座標
P_Metal_box     = [160, -130,270,-180,0,90,-3]; %Metal    の分類箱の座標

D_Num=0;
xi=0;
yi=1;
TB=tic;
while(1)
    % qを押したら終わり?
%     if strcmp(get(fx,'currentcharacter'),'q')
%         break
%     end
    % 以下の変数以外を削除
     clearvars -except three_classification_FRCNN detector...
         cam fx...
         cameraParams R t...
         cao caoExt ctrl ws rob state...
         P_PCB_box P_IC_box P_Connector_box P_Condenser_box P_Metal_box P1...
         TVal  X_M X_D Y_M Y_D...
         Z_arm class_label Belt_Speed PickT xi yi D_Num Length TB ...
         Detect_List List_Time...
         G_a G_b R_late RX_a RX_b...
         net...
     
      %% Test
%      Value = load('EvaLabel_1_rgb100_320240_Light.mat');
%      numImages=height(Value.gTruth);
%      results=table('Size',[numImages 3],...
%     'VariableTypes',{'cell','cell','cell'},...
%     'VariableNames',{'Boxes','Scores','Labels'});
%      i=4;
%      im = imread(Value.gTruth.imageFilename{i});
    

     %% Detection
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

%画像の保存                 
%         fx1=figure(1);
%     str1=append("Metal_","25",".jpg");
%     img1 = im;
%     image(img1);
%     imwrite(img1,str1);
%         j=j+1;

                 % Filter image to make it smooth for easier checking
                 % im = imgaussfilt(im,0.5);
                 % detectorによって'PCB基板','金属','コネクタ'を検出する．
                 time_detect=tic;                
                [bboxes, score,label] = detect(detector, im);
% 
% % 転移学習モデルによる分類
% im_Resize=imresize(im,[224 224]);
% [VGG_label, VGG_score] = net.classify(im_Resize);
% VGG_label
% [VGG_score]= (max(VGG_score)*100+"%");
% % imshow(im_Resize) 
%                  
                                
%                 

                 TB=tic;
                 % 闘値による篩い
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
             ixx = ixx+1;
         end
     end
% 

%  入力画像のリサイズ
%                  im_Resize=imresize(CropImage,[224 224]);
                 
                 %VGG16転移学習モデルでの検出
%                  [LABEL, SCORE] = net.classify(im_Resize);
%                  SCORE = max(SCORE);
% 
% 
%                  for i=1:size(SCORE)
% %                      a=bboxes(i,1)+(bboxes(i,3)/2);
%                      if SCORE(i)>=TVal && a>30 && a<270 
%                          SSCORE(ixx) = SCORE(i);
%                          LABEL_str{ixx} = char(string(LABEL(i)));
%                          ixx = ixx+1;
%                      end
%                  end         

     pause(0.02);
    if exist('bbox','var')
             outputImage = insertObjectAnnotation(im, 'rectangle', bbox,...
                 label_str,'FontSize', 10,'LineWidth',3,'Color','blue');
             out = [im outputImage];
%             imshow(out);
            all_data = horzcat(label_str.',num2cell(sscore.'),num2cell(box_x.'),num2cell(box_y.'),num2cell(box_width.'));
            all_data = sortrows(all_data,4,'descend');

%               CropImage = imcrop(im,all_data);%トリミングされたイメージを表示
%               subplot(1,2,2);
%               imshow(CropImage)
%               title('Cropped Image');
             

            
%             hold on;

            for i=1:size(label_str,2)
                G(i,:) = [str2double(string(all_data(i,3))) ...
                str2double(string(all_data(i,4)))];
%                plot(G(i,1),G(i,2),'*') 
%                plot(320+G(i,1),G(i,2),'*')
                % ワールド座標系への変換
                imagePointsObject = [2*G(i,1) 2*G(i,2)]; 
                % Get the world coordinates of the corners
                worldPointsObject = pointsToWorld(cameraParams, R, t, imagePointsObject);
                %ワールド座標点に z 座標を追加します。
                zCoordObject = zeros(size(worldPointsObject,1),1);
                worldPoints3DObjectZ = [worldPointsObject zCoordObject];
                %ワールド座標点を元のイメージに投影します。
                projectedPoints3DObject = worldToImage(cameraParams,R,t,worldPoints3DObjectZ);          
                worldPoints3DObject(i,:) = pointsToWorld(cameraParams, R, t, imagePointsObject);
                % 小型ロボットマニピュレータの座標系への変換
                X_0 = -worldPoints3DObject(i,1)*X_M + X_D;%補正値あり
                Y_0 =  worldPoints3DObject(i,2)*Y_M + Y_D;%補正値あり
%                 disp(all_data(1,5));
                Time_A=toc(time_detect);
                Position(i,:) = [all_data(i,1) X_0 Y_0 Time_A all_data(i,5)];
                Position_Time(i) = tic;
            end 
     
            % リスト化 
            [M,N] = size(Position.');
            for j=1:1:N
                xi=xi+1;
                Detect_List(xi,:)=Position(j,:);
                List_Time(xi)=Position_Time(i);
            end 
    end
    d1=1;
             else
                 pause(0.02);
             end
         end
     end %lengh
            
  if xi>=yi
      i_time=toc(List_Time(yi))+str2double(string(Detect_List(yi,4)));
      Y_1=str2double(string(Detect_List(yi,3))) + (i_time)*Belt_Speed;
      [M2,N2]=size(Detect_List.');
      if Y_1>-200 && Y_1<100
           D_width=(str2double(string(Detect_List(yi,5))))*G_a+G_b;
           if D_width>=8
               D_width=8;
           elseif D_width<=-18
               D_width=-18;
           else
           end
           D_X=(str2double(string(Detect_List(yi,2)))*RX_a+RX_b)*Belt_Speed;
           P1=[str2double(string(Detect_List(yi,2))),Y_1+R_late-D_width+D_X+10+2,Z_arm,-180,-2,90,-3]; 
           P2=[str2double(string(Detect_List(yi,2))),Y_1+R_late-D_width+D_X+10+2,Z_arm+25,-180,0,90,-3]; 
                 % PCBの選別
                 if Detect_List(yi,1) == string(class_label(1))
                     rob.Move(1,P2);
                     caoExt.Execute('Chuck',1);
                     rob.Move(1,P1);
                     pause(0.6);
                     rob.Move(1,P2);
                     rob.Move(1,P_PCB_box);
                     caoExt.Execute('UnChuck',2);
                     pause(0.2);
                 % ICの選別
                 elseif Detect_List(yi,1) == string(class_label(2))
                     rob.Move(1,P2);
                     caoExt.Execute('Chuck',1);
%                      P1=[str2double(string(Detect_List(yi,2))),Y_1+R_late-D_width+5+D_X,Z_arm,-180,-2,90,-3]; 
                     rob.Move(1,P1);
                     pause(0.6);
                     rob.Move(1,P2);
                     rob.Move(1,P_IC_box);
                     caoExt.Execute('UnChuck',2);
                     pause(0.2);
                 % Connectorの選別
                 elseif Detect_List(yi,1) == string(class_label(3))
                     rob.Move(1,P2);
                     caoExt.Execute('Chuck',1);
                     rob.Move(1,P1);
                     pause(0.4);
                     rob.Move(1,P2);
                     rob.Move(1,P_Connector_box);
                     caoExt.Execute('UnChuck',2);
                     pause(0.2);
                 % Condenserの選別
                 elseif Detect_List(yi,1) == string(class_label(4))
                     rob.Move(1,P2);
                     caoExt.Execute('Chuck',1);
                     rob.Move(1,P1);
                     pause(0.4);
                     rob.Move(1,P2);
                     rob.Move(1,P_Condenser_box);
                     caoExt.Execute('UnChuck',2);
                     pause(0.2);
                 % Metalの選別
                 elseif Detect_List(yi,1) == string(class_label(5))
                     rob.Move(1,P2);
                     caoExt.Execute('Chuck',1);
                     rob.Move(1,P1);
                     pause(0.4);
                     rob.Move(1,P2);
                     rob.Move(1,P_Metal_box);
                     caoExt.Execute('UnChuck',2);
                     pause(0.2);
                 else
                     
                 end
                 
%           Detect_List(1,:)=[];
%            xi=xi-1;
              yi=yi+1;
      elseif Y_1>=100
%           Detect_List(1,:)=[];
%            xi=xi-1;
                yi=yi+1;
      end
      
             
              
%              figure(fx)
%              imshow(im)
      
%   else
   
%          title('Object Detected')
%          hold off
  end
%      figure(fx)
%      imshow(im)  
  pause(0.1);      

 end