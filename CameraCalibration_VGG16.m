%% カメラのキャリブレーション
% このシステムを利用するにはアプリケーションの”カメラキャリブレータ―(cameraCalibrator)”をインストールしている必要があります。
%-------------------------------------------------------
imagnification = 17;
imageFileNames = {('C:\研究(ロボットマニピュレータ)\MATLAB_研究\CheckerBoard\CheckerBoard1.jpg') ...
    ('C:\研究(ロボットマニピュレータ)\MATLAB_研究\CheckerBoard\CheckerBoard2.jpg') ...
    ('C:\研究(ロボットマニピュレータ)\MATLAB_研究\CheckerBoard\CheckerBoard3.jpg') ...
    ('C:\研究(ロボットマニピュレータ)\MATLAB_研究\CheckerBoard\CheckerBoard4.jpg') ...
    ('C:\研究(ロボットマニピュレータ)\MATLAB_研究\CheckerBoard\CheckerBoard5.jpg') ...
    ('C:\研究(ロボットマニピュレータ)\MATLAB_研究\CheckerBoard\CheckerBoard6.jpg') ...
    ('C:\研究(ロボットマニピュレータ)\MATLAB_研究\CheckerBoard\CheckerBoard7.jpg') ...
    ('C:\研究(ロボットマニピュレータ)\MATLAB_研究\CheckerBoard\CheckerBoard8.jpg') ...
    ('C:\研究(ロボットマニピュレータ)\MATLAB_研究\CheckerBoard\CheckerBoard9.jpg') ...
    ('C:\研究(ロボットマニピュレータ)\MATLAB_研究\CheckerBoard\CheckerBoard10.jpg') ...
    ('C:\研究(ロボットマニピュレータ)\MATLAB_研究\CheckerBoard\CheckerBoard11.jpg') ...
    ('C:\研究(ロボットマニピュレータ)\MATLAB_研究\CheckerBoard\CheckerBoard12.jpg') ...
    ('C:\研究(ロボットマニピュレータ)\MATLAB_研究\CheckerBoard\CheckerBoard13.jpg') ...
    ('C:\研究(ロボットマニピュレータ)\MATLAB_研究\CheckerBoard\CheckerBoard14.jpg') ...
    ('C:\研究(ロボットマニピュレータ)\MATLAB_研究\CheckerBoard\CheckerBoard15.jpg') ...
    ('C:\研究(ロボットマニピュレータ)\MATLAB_研究\CheckerBoard\CheckerBoard16.jpg') ...
    ('C:\研究(ロボットマニピュレータ)\MATLAB_研究\CheckerBoard\CheckerBoard17.jpg') ...
    };

% 読み込んだ画像内のチェッカーボードパターンを検出(Detect checkerboards in images)
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);
% 1つ目の画像サイズを取得(Read the first image to obtain image size)
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);
% チェッカーボードパターン内の正方形のサイズ(mm)を入力(Generate world coordinates of the corners of the squares)
squareSize = 2.150000e+01;  % in units of 'millimeters'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);
% カメラのキャリブレーション(Calibrate the camera)
[cameraParams, ~, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

% キャリブレーションの精度を可視化(View reprojection errors)
h1=figure(1); showReprojectionErrors(cameraParams);
% カメラのイ外部パラメーターを可視化(Visualize pattern locations)
h2=figure(2); showExtrinsics(cameraParams, 'CameraCentric');

% コマンドウィンドウに内部・外部パラメーターを表示(Display parameter estimation errors)
 displayErrors(estimationErrors, cameraParams);
% レンズ歪みを修正(For example, you can use the calibration data to remove effects of lens distortion.)
undistortedImage = undistortImage(originalImage, cameraParams);

%% 座標の基準となる画像
im = imread('CheckerBoard1001.jpg');
%　新しい位置でイメージを読み込みます。
imOrig = im;
imshow(imOrig,'InitialMagnification',30);
%　イメージの歪みを補正します。
imUndistorted = undistortImage(imOrig,cameraParams);
%　新しいイメージで参照オブジェクトを検索します。
[imagePoints,~] = detectCheckerboardPoints(imUndistorted);
%　新しい外部パラメーターを計算します。
[R,t] = extrinsics(imagePoints,worldPoints,cameraParams);
%　ワールド座標点に z 座標を追加します。
zCoord = zeros(size(worldPoints,1),1);
worldPoints = [worldPoints zCoord];
%　ワールド座標点を元のイメージに投影します。
projectedPoints = worldToImage(cameraParams,R,t,worldPoints);
hold on
plot(projectedPoints(:,1),projectedPoints(:,2),'g*-');
legend('Projected points');
hold off

%% カメラに接続
cam = webcam;
cam.Resolution = '320x240';
fx = figure(3);

% %% 不要な変数を消去
% clear boardSize;
% clear estimationErrors;
% clear imageFileNames;
% clear imagePoints;
% clear imagesUsed;
% clear imOrig;
% clear imUndistorted;
% clear mrows;
% clear ncols;
%  clear originalImage;
% clear projectedPoints;
% clear squareSize;
% clear zCoord;