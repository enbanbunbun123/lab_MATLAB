% 学習モデルを名前をつけて保存するプログラム
% 転移学習に関しては、matlab内のdeep network designerを使用した
% 学習完了後、変数内に学習モデルが作成されるので、任意の名前で保存する
% https://jp.mathworks.com/help/deeplearning/gs/get-started-with-deep-network-designer.html

%% 学習データの保存
%VGG16Transfer = trainNetwork('myNet',layers,opts);
%save('VGG16Transfer.mat','VGG16Transfer');

% myNet = trainNetwork(trainImages,layers,opts);
% save('VGG16Transfer6_proto3_1_crop.mat','trainedNetwork_1');
save('TrainInfo_proto3_1','trainInfoStruct_1');
save('voice_YesNoGoStop','trainedNet');
%'C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16'

%VGG16の転移学習モデルをロード(6種類)
% load('C:\研究(ロボットマニピュレータ)\MATLAB_研究\高橋_MATLAB\転移学習_VGG16\VGG16Transfer6_3.mat', 'trainedNetwork_1');