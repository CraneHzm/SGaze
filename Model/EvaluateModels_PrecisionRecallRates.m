% Copyright (c) Hu Zhiming JimmyHu@pku.edu.cn 2018/11/27 All Rights Reserved.


% Calculate the precision and recall rates of the predictions at different
% central radius.

% Run this after running 'EvaluateModels.m'.


% start time.
startTime = datestr(now)


if (isempty(centerPrdDist) | isempty(meanPrdDist) | isempty(modelPrdDist) | isempty(saliencyPrdDist))
    error('Run this after running EvaluateModels.m.');
end


% Prepare for evaluation.
dataSize = size(testGazeX, 1);
centerPrecisionRecall = zeros(dataSize, 2);
meanPrecisionRecall = zeros(dataSize, 2);
saliencyPrecisionRecall = zeros(dataSize, 2);
modelPrecisionRecall = zeros(dataSize, 2);

% Radius of the ground truth gaze region and the predicted gaze region.
gth_radius = 15;
radiusMax = 25;
prd_radiusAll = 15:1:radiusMax;
radiusSize = size(prd_radiusAll, 2);
centerPrecisionRecall_mean = zeros(radiusSize, 2);
meanPrecisionRecall_mean = zeros(radiusSize, 2);
saliencyPrecisionRecall_mean = zeros(radiusSize, 2);
modelPrecisionRecall_mean = zeros(radiusSize, 2);


% Evaluation.
for r = 1 : radiusSize
    % radius of the predicted gaze region.
    prd_radius = prd_radiusAll(r);
    % Evaluate at the current prediction radius.
    for i = 1 : dataSize
        gth = [testGazeX(i), testGazeY(i)];
%         centerPrd = [centerGazeX, centerGazeY];
%         centerPrecisionRecall(i, :) = CalPrecisionRecall(gth, gth_radius, centerPrd, prd_radius);
%         saliencyPrd = [testSalX(i), testSalY(i)];
%         saliencyPrecisionRecall(i, :) = CalPrecisionRecall(gth, gth_radius, saliencyPrd, prd_radius);
        meanPrd = [meanGazeX, meanGazeY];
        meanPrecisionRecall(i, :) = CalPrecisionRecall(gth, gth_radius, meanPrd, prd_radius);
        modelPrd = [modelPrdX(i), modelPrdY(i)];
        modelPrecisionRecall(i, :) = CalPrecisionRecall(gth, gth_radius, modelPrd, prd_radius);
    end
    % Mean of precision and recall rates.
%     centerPrecisionRecall_mean(r, :) = mean(centerPrecisionRecall);
%     saliencyPrecisionRecall_mean(r, :) = mean(saliencyPrecisionRecall);
    meanPrecisionRecall_mean(r, :) = mean(meanPrecisionRecall);
    modelPrecisionRecall_mean(r, :) = mean(modelPrecisionRecall);
end


% Show the results.
x = prd_radiusAll;
% h = plot(x, centerPrecisionRecall_mean(:, 1));
% set(h, 'color', 'm', 'linewidth', 1);
% hold on;
% h = plot(x, centerPrecisionRecall_mean(:, 2));
% set(h, 'color', 'r', 'linewidth', 1);
% hold on;
% h = plot(x, saliencyPrecisionRecall_mean(:, 1));
% set(h, 'color', 'b', 'linewidth', 1);
% hold on;
% h = plot(x, saliencyPrecisionRecall_mean(:, 2));
% set(h, 'color', 'c', 'linewidth', 1);
% hold on;
h = plot(x, meanPrecisionRecall_mean(:, 1));
set(h, 'color', 'm', 'linewidth', 2);
hold on;
h = plot(x, meanPrecisionRecall_mean(:, 2));
set(h, 'color', 'r', 'linewidth', 2);
hold on;
h = plot(x, modelPrecisionRecall_mean(:, 1));
set(h, 'color', 'b', 'linewidth', 2);
hold on;
h = plot(x, modelPrecisionRecall_mean(:, 2));
set(h, 'color', 'g', 'linewidth', 2);
grid on;


xlabel('Central Radius (deg)');
ylabel('Precision and Recall Rates');
legend('Precision Rate of Mean Baseline', 'Recall Rate of Mean Baseline','Precision Rate of Our Method','Recall Rate of Our Method', 'Location', 'east');

index = find(prd_radiusAll == 20);
meanPrecisionRecall_20 = meanPrecisionRecall_mean(index, :)
modelPrecisionRecall_20 = modelPrecisionRecall_mean(index, :)


% end time.
endTime = datestr(now)

