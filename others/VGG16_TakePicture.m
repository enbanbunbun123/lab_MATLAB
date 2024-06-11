%webカメラを通して学習用の画像の撮影を行うプログラム

% close all;
clear cam;
clc;

%% Connect camera
    %cam = webcam('Full HD webcam');
    cam = webcam('USB_Camera');

%     '640x480', '160x120', '176x144', '320x240', '352x288',
%     '800x600', '1280x720', '1920x1080'

%    cam.Resolution='800x600';
%    preview(cam);cam = webcam('USB_Camera');
%    str=append("LED", int2str(i),".jpg");

%     cam.Resolution='320x240';
    cam.Resolution='800x600';
    fx1=figure(1);
%     str1=append("CheckerBoard1", int2str(i),".jpg");
    str1=append("CheckerBoard","17" ,".jpg");
    img1 = snapshot(cam);
    image(img1);
    imwrite(img1,str1);
        i=i+1;
%% Resize→保存

% fx1=figure(1);
%                  str1=append("Coil_", int2str(i),".jpg");
%                  img1 = im_Resize;
% %                  image(img1);
%                  imwrite(img1,str1);
%                  i=i+1; 