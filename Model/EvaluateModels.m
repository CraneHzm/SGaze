% Copyright (c) Hu Zhiming JimmyHu@pku.edu.cn 2018/11/26 All Rights Reserved.


% Evaluate the performance of our model, mean baseline, center baseline and
% saliency position baseline.

% the mean baseline is the mean value of the whole dataset.


% Evaluate our model on the dataset.
% the input data are the whole dataset, we extract test data using the
% train/test split based on scene labels. If you retrain our model with different train/test split,
% remember to use the same train/test split when you evaluate the newly trained model.



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


testData = [];

% read the test data.
fileNum = 0;
filelist = fopen([datadir, 'filelist.txt'], 'rt');
while feof(filelist) ~= 1
    filename = fgetl(filelist);
    filepath = [datadir, filename];
    % load the angular gaze data.
    fileNum = fileNum+1;
    data = load(filepath);
    if ismember(sceneLabels(fileNum), testLabels)
        testData = [testData; data];
    end
end
fclose(filelist);


% Split the data.
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


% prediction errors.
dataSize = size(testGazeX, 1);
centerPrdDist = zeros(dataSize, 1);
meanPrdDist = zeros(dataSize, 1);
modelPrdDist = zeros(dataSize, 1);
saliencyPrdDist = zeros(dataSize, 1);


% Evaluate the center baseline.
centerGazeX = 0;
centerGazeY = 0;
centerPrd = [centerGazeX, centerGazeY];
% Evaluate.
for i=1:dataSize
    gth = [testGazeX(i), testGazeY(i)];
    centerPrdDist(i) = CalAngularDist(gth, centerPrd);
end
centerPrdDist_mean = mean(centerPrdDist)
centerPrdDist_std = std(centerPrdDist)


% Evaluate the mean baseline.
% the mean value of the whole dataset.
meanGazeX = 0.03;
meanGazeY = -2.34;
meanPrd = [meanGazeX, meanGazeY];
% Evaluate.
for i=1:dataSize
    gth = [testGazeX(i), testGazeY(i)];
    meanPrdDist(i) = CalAngularDist(gth, meanPrd);
end
meanPrdDist_mean = mean(meanPrdDist)
meanPrdDist_std = std(meanPrdDist)


% Evaluate the salient position baseline.
% Evaluate.
for i=1:dataSize
    gth = [testGazeX(i), testGazeY(i)];
    salPrd = [testSalX(i), testSalY(i)];
    saliencyPrdDist(i) = CalAngularDist(gth, salPrd);
end
saliencyPrdDist_mean = mean(saliencyPrdDist)
saliencyPrdDist_std = std(saliencyPrdDist)


% Evaluate our model.
% Model: 
% GazeX = (c1* HeadVelStdX + c2)*(HeadVelX + HeadAccMeanX*c3) + c4*HeadAccX + c5*SalX + c6
% GazeY = (c1* HeadVelStdY + c2)*(HeadVelY + HeadAccMeanY*c3) + c4*SalY+ c5

% Paras:
cX = [-0.0015, 0.2491, 0.1480, 0.0006, 0.0344, 0.1777];
cY = [-0.0053, 0.5293, 0.0304, 0.0503, -2.5249];
% the prediction results in X and Y axis.
modelPrdX = zeros(dataSize, 1);
modelPrdY = zeros(dataSize, 1);
% Boundaries of regions.
VX_h = 0.5;
VY_h = 0.2;
HeadVelXThresMin = -88.5;
HeadVelXThresMax = 83.8;
HeadVelYThresMin = -35.6;
HeadVelYThresMax = 36;  
% the mean duration for predicting gaze positions in the sudden move
% region, unit: ms.
suddenMeanDuration = 600;
% the gaze data are sampled at 100 hz.
suddenMeanNum = ceil(suddenMeanDuration/10);
% Ignore the fluctuation in X axis.
meanGazeX_Static = -0.05;
meanGazeY_Static = -1.83;


% Evaluate.
for i=1:dataSize
    gth = [testGazeX(i), testGazeY(i)];
    
    % predict X.
    % Static Region.
    if abs(testHeadVelX(i)) < VX_h
        modelPrdX(i) = meanGazeX_Static;
    % Intentional Move Region.
    elseif (abs(testHeadVelX(i)) >=VX_h & testHeadVelX(i)>= HeadVelXThresMin & testHeadVelX(i) <= HeadVelXThresMax)
        modelPrdX(i) = (cX(1)* testHeadVelStdX(i) + cX(2)).*(testHeadVelX(i) + cX(3)*testHeadAccMeanX(i)) + cX(4)*testHeadAccX(i) + cX(5)*testSalX(i) + cX(6);
    % Sudden Move Region.
    % special case 1.
    elseif i==1
        modelPrdX(i) = meanGazeX_Static;
    % special case 2.
    elseif i<suddenMeanNum+1
        modelPrdX(i) = mean(modelPrdX(1 : i-1));
    else
        modelPrdX(i) = mean(modelPrdX(i-suddenMeanNum : i-1));
    end
    
    % predict Y.
    % Static Region.
    if abs(testHeadVelY(i)) < VY_h
        modelPrdY(i) = meanGazeY_Static;
    % Intentional Move Region.
    elseif (abs(testHeadVelY(i)) >=VY_h & testHeadVelY(i)>= HeadVelYThresMin & testHeadVelY(i) <= HeadVelYThresMax)
        modelPrdY(i) = (cY(1)* testHeadVelStdY(i) + cY(2)).*(testHeadVelY(i) + cY(3)*testHeadAccMeanY(i)) + cY(4)*testSalY(i) + cY(5);
    % Sudden Move Region.
    % special case 1.
    elseif i==1
        modelPrdY(i) = meanGazeY_Static;
    % special case 2.
    elseif i<suddenMeanNum+1
        modelPrdY(i) = mean(modelPrdY(1 : i-1));
    else
        modelPrdY(i) = mean(modelPrdY(i-suddenMeanNum : i-1));
    end
    prd = [modelPrdX(i), modelPrdY(i)];
    modelPrdDist(i) = CalAngularDist(gth, prd);
end
modelPrdDist_mean = mean(modelPrdDist)
modelPrdDist_std = std(modelPrdDist)


modelImprove = (meanPrdDist_mean - modelPrdDist_mean)/meanPrdDist_mean*100


% end time.
endTime = datestr(now)
