%% 画像のサイズ変更
allImages = imread('Condenser_21.jpg');
ChangeImages = imresize(allImages,[224 224]);
imshow(ChangeImages)
 fx1=figure(1);
    str1=append("Condenser", "21",".jpg");
    img1 = ChangeImages;
    image(img1);
    imwrite(img1,str1);
        i=i+1;

% fx1=figure(1);
%     str1=append("Test_", int2str(i),".jpg");
%     img1 = ChangeImages;
%     image(img1);
%     imwrite(img1,str1);
%         i=i+1;

       