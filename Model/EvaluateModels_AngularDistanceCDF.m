% Copyright (c) Hu Zhiming JimmyHu@pku.edu.cn 2018/11/27 All Rights Reserved.


% Calculate the CDF of the prediction errors (angular distance).
% Run this code after running 'EvaluateModels.m'.

% start time.
startTime = datestr(now)


if (isempty(centerPrdDist) | isempty(meanPrdDist) | isempty(modelPrdDist) | isempty(saliencyPrdDist))
    error('Run this after running EvaluateModels.m.');
end


h = cdfplot(modelPrdDist);
set(h, 'color', 'g', 'linewidth', 2);
hold on;
h = cdfplot(meanPrdDist);
set(h, 'color', 'r', 'linewidth', 2);
h = cdfplot(centerPrdDist);
set(h, 'color', 'b', 'linewidth', 2);
hold on;
h = cdfplot(saliencyPrdDist);
set(h, 'color', 'm', 'linewidth', 2);
% grid off;

xlabel('Angular Distance (deg)');
ylabel('Data Proportion');
title('');
legend('Our Method', 'Mean Baseline','Center Baseline','Saliency Baseline', 'Location', 'northwest');
% set the display region.
axis([0 20 0 1]);


% end time.
endTime = datestr(now)

