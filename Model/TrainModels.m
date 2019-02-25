% Copyright (c) Hu Zhiming JimmyHu@pku.edu.cn 2018/11/24  All Rights Reserved.


% Regress all the paras for our model.


% Clear the screen and variables.
clc, clear;


% start time.
startTime = datestr(now)
% the directory of our data.
datadir = '../Dataset/Data/';


% scene labels.
sceneLabelsFile = '../Dataset/SceneLabels/SceneLabels.txt';
sceneLabels = load(sceneLabelsFile);


% train/test data.
% the labels for training and test data.
allLabels = [1, 2, 3, 4, 5, 6, 7];
testLabels = [4, 6];
trainLables = setdiff(allLabels, testLabels);


trainData = [];
testData = [];
allData = [];


% read the test data.
fileNum = 0;
filelist = fopen([datadir, 'filelist.txt'], 'rt');
while feof(filelist) ~= 1
    filename = fgetl(filelist);
    filepath = [datadir, filename];
    % load the angular gaze data.
    fileNum = fileNum+1;
    data = load(filepath);
    if ismember(sceneLabels(fileNum), trainLables)
        trainData = [trainData; data];
    else
        testData = [testData; data];
    end
    allData = [allData; data];
end
fclose(filelist);


trainSizeX = size(trainData, 1);
testSize = size(testData, 1);
totalSize = size(allData, 1);
trainPercent = trainSizeX/totalSize
testPercent = testSize/totalSize


% Split the data.
trainGazeX = trainData(:, 1);
trainGazeY = trainData(:, 2);
trainSalX = trainData(:, 3);
trainSalY = trainData(:, 4);
trainHeadVelX = trainData(:, 5);
trainHeadVelY = trainData(:, 6);
trainHeadAccX = trainData(:, 7);
trainHeadAccY = trainData(:, 8);
trainHeadAccMeanX = trainData(:, 9);
trainHeadAccMeanY = trainData(:, 10);
trainHeadVelStdX = trainData(:, 11);
trainHeadVelStdY = trainData(:, 12);
testGazeX = testData(:, 1);
testGazeY = testData(:, 2);
testSalX = testData(:, 3);
testSalY = testData(:, 4);
testHeadVelX = testData(:, 5);
testHeadVelY = testData(:, 6);
testHeadAccX = testData(:, 7);
testHeadAccY = testData(:, 8);
testHeadAccMeanX = testData(:, 9);
testHeadAccMeanY = testData(:, 10);
testHeadVelStdX = testData(:, 11);
testHeadVelStdY = testData(:, 12);


% Extract data in Intentional Move Region.
VX_h = 0.5;
VY_h = 0.2;
HeadVelXThresMin = -88.5;
HeadVelXThresMax = 83.8;
HeadVelYThresMin = -35.6;
HeadVelYThresMax = 36;  
index = find(abs(trainHeadVelX) >=VX_h & trainHeadVelX>= HeadVelXThresMin & trainHeadVelX <= HeadVelXThresMax);
trainGazeX = trainGazeX(index);
trainSalX = trainSalX(index);
trainHeadVelX = trainHeadVelX(index);
trainHeadAccX = trainHeadAccX(index);
trainHeadAccMeanX = trainHeadAccMeanX(index);
trainHeadVelStdX = trainHeadVelStdX(index);
index = find(abs(testHeadVelX) >=VX_h & testHeadVelX>= HeadVelXThresMin & testHeadVelX <= HeadVelXThresMax);
testGazeX = testGazeX(index);
testSalX = testSalX(index);
testHeadVelX = testHeadVelX(index);
testHeadAccX = testHeadAccX(index);
testHeadAccMeanX = testHeadAccMeanX(index);
testHeadVelStdX = testHeadVelStdX(index);
index = find(abs(trainHeadVelY) >=VY_h & trainHeadVelY>= HeadVelYThresMin & trainHeadVelY <= HeadVelYThresMax);
trainGazeY = trainGazeY(index);
trainSalY = trainSalY(index);
trainHeadVelY = trainHeadVelY(index);
trainHeadAccY = trainHeadAccY(index);
trainHeadAccMeanY = trainHeadAccMeanY(index);
trainHeadVelStdY = trainHeadVelStdY(index);
index = find(abs(testHeadVelY) >=VY_h & testHeadVelY>= HeadVelYThresMin & testHeadVelY <= HeadVelYThresMax);
testGazeY = testGazeY(index);
testSalY = testSalY(index);
testHeadVelY = testHeadVelY(index);
testHeadAccY = testHeadAccY(index);
testHeadAccMeanY = testHeadAccMeanY(index);
testHeadVelStdY = testHeadVelStdY(index);


% Split the train data into train and validate data to help determine
% paras.
validateRatio = 0.3;
trainSizeX = size(trainGazeX, 1);
trainSizeY = size(trainGazeY, 1);
validateSizeX = ceil(validateRatio*trainSizeX);
validateSizeY = ceil(validateRatio*trainSizeY);
validateGazeX = trainGazeX(1:validateSizeX, :);
validateSalX = trainSalX(1:validateSizeX, :);
validateHeadVelX = trainHeadVelX(1:validateSizeX, :);
validateHeadAccX = trainHeadAccX(1:validateSizeX, :);
validateHeadAccMeanX = trainHeadAccMeanX(1:validateSizeX, :);
validateHeadVelStdX = trainHeadVelStdX(1:validateSizeX, :);
validateGazeY = trainGazeY(1:validateSizeY, :);
validateSalY = trainSalY(1:validateSizeY, :);
validateHeadVelY = trainHeadVelY(1:validateSizeY, :);
validateHeadAccY = trainHeadAccY(1:validateSizeY, :);
validateHeadAccMeanY = trainHeadAccMeanY(1:validateSizeY, :);
validateHeadVelStdY = trainHeadVelStdY(1:validateSizeY, :);
trainGazeX = trainGazeX(validateSizeX+1:trainSizeX, :);
trainSalX = trainSalX(validateSizeX+1:trainSizeX, :);
trainHeadVelX = trainHeadVelX(validateSizeX+1:trainSizeX, :);
trainHeadAccX = trainHeadAccX(validateSizeX+1:trainSizeX, :);
trainHeadAccMeanX = trainHeadAccMeanX(validateSizeX+1:trainSizeX, :);
trainHeadVelStdX = trainHeadVelStdX(validateSizeX+1:trainSizeX, :);
trainGazeY = trainGazeY(validateSizeY+1:trainSizeY, :);
trainSalY = trainSalY(validateSizeY+1:trainSizeY, :);
trainHeadVelY = trainHeadVelY(validateSizeY+1:trainSizeY, :);
trainHeadAccY = trainHeadAccY(validateSizeY+1:trainSizeY, :);
trainHeadAccMeanY = trainHeadAccMeanY(validateSizeY+1:trainSizeY, :);
trainHeadVelStdY = trainHeadVelStdY(validateSizeY+1:trainSizeY, :);


% the mean baseline.
% meanGazeX = 0.0324;
% meanGazeY = -2.3375;
meanGazeX = 0.03;
meanGazeY = -2.34;

% Regress for Gaze X data.
% GazeX = (c1* HeadVelStdX + c2)*(HeadVelX + HeadAccMeanX*c3) + c4*HeadAccX
% + c5*SalX + c6


cX3 = 0.1450:0.0001:0.1550;
%cX3 = 0.1480;
cX1 = zeros(size(cX3));
cX2 = zeros(size(cX3));
cX4 = zeros(size(cX3));
cX5 = zeros(size(cX3));
cX6 = zeros(size(cX3));
testNum = size(cX3, 2);
prdXValidateErrors = zeros(size(1, testNum));


for i = 1:testNum
    trainHeadVelXPrd = trainHeadVelX + cX3(i)*trainHeadAccMeanX;
    X = [ones(size(trainGazeX)), trainHeadVelXPrd.*trainHeadVelStdX, trainHeadVelXPrd, trainHeadAccX, trainSalX];
    Y = trainGazeX;
    [bx, bxint, r, rint, statsX] = regress(Y, X);
    cX6(i) = bx(1);
    cX1(i) = bx(2);
    cX2(i) = bx(3);
    cX4(i) = bx(4);
    cX5(i) = bx(5);
    %statsX
    
    %  the model.
    validateHeadVelXPrd = validateHeadVelX + cX3(i)*validateHeadAccMeanX;
    prdX = (cX1(i)* validateHeadVelStdX + cX2(i)).*validateHeadVelXPrd + cX4(i)*validateHeadAccX + cX5(i)*validateSalX + cX6(i);
    prdXValidateErrors(i) = mean(abs(prdX - validateGazeX));
end


% test the model.
index = find(prdXValidateErrors == min(prdXValidateErrors));
prdXMeanBaseline = mean(abs(testGazeX - meanGazeX))
testHeadVelXPrd = testHeadVelX + cX3(index)*testHeadAccMeanX;
prdX = (cX1(index)* testHeadVelStdX + cX2(index)).*testHeadVelXPrd + cX4(index)*testHeadAccX + cX5(index)*testSalX + cX6(index);
prdXModel = mean(abs(prdX - testGazeX))


% the paras.
cx1 = cX1(index)
cx2 = cX2(index)
cx3 = cX3(index)
cx4 = cX4(index)
cx5 = cX5(index)
cx6 = cX6(index)


% Regress for Gaze Y data.
% GazeY = (c1* HeadVelStdY + c2)*(HeadVelY + HeadAccMeanY*c3) + c4*SalY+
% c5.


cY3 = 0.0250:0.0001:0.0350;
%cY3 = 0.0304;
cY1 = zeros(size(cY3));
cY2 = zeros(size(cY3));
cY4 = zeros(size(cY3));
cY5 = zeros(size(cY3));
testNum = size(cY3, 2);
prdYValidateErrors = zeros(size(1, testNum));


for i = 1:testNum
    trainHeadVelYPrd = trainHeadVelY + cY3(i)*trainHeadAccMeanY;
    X = [ones(size(trainGazeY)), trainHeadVelYPrd.*trainHeadVelStdY, trainHeadVelYPrd, trainSalY];
    Y = trainGazeY;
    [by, byint, r, rint, statsY] = regress(Y, X);
    cY5(i) = by(1);
    cY1(i) = by(2);
    cY2(i) = by(3);
    cY4(i) = by(4);
    %statsY
    
    % validate the model.
    validateHeadVelYPrd = validateHeadVelY + cY3(i)*validateHeadAccMeanY;
    prdY = (cY1(i)* validateHeadVelStdY + cY2(i)).*validateHeadVelYPrd + cY4(i)*validateSalY + cY5(i);
    prdYValidateErrors(i) = mean(abs(prdY - validateGazeY));
end

% test the model.
index = find(prdYValidateErrors == min(prdYValidateErrors));
prdYMeanBaseline = mean(abs(testGazeY - meanGazeY))
testHeadVelYPrd = testHeadVelY + cY3(i)*testHeadAccMeanY;
prdY = (cY1(i)* testHeadVelStdY + cY2(i)).*testHeadVelYPrd + cY4(i)*testSalY + cY5(i);
prdYModel = mean(abs(prdY - testGazeY))


% the paras.
cy1 = cY1(index)
cy2 = cY2(index)
cy3 = cY3(index)
cy4 = cY4(index)
cy5 = cY5(index)


% end time.
endTime = datestr(now)
