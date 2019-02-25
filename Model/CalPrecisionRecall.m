% Copyright (c) Hu Zhiming JimmyHu@pku.edu.cn 2018/7/21 All Rights Reserved.

function PrecisionRecall = CalPrecisionRecall(gth, gth_radius, prd, prd_radius)
% Calculate the precision and recall rates.
% gth: the ground truth angular gaze position.
% gth_radius: the central foveal radius of the ground truth gaze region.
% prd: the predicted angular gaze position.
% prd_radius: the central foveal radius of the predicted gaze region.
% returns [precison rate, recall rate].

if size(gth,2) ~= 2
    error('Ground truth gaze data must contain 2 elements.');
end

if size(gth_radius)~=1
    error('Radius of ground truth gaze region must contain 1 element.');
end

if size(prd,2) ~= 2
    error('Predicted gaze data must contain 2 elements.');
end

if size(prd_radius)~=1
    error('Radius of predicted gaze region must contain 1 element.');
end

% test this function.
% gth = [0, 0];
% gth_radius = 15;
% prd = [0, 0];
% prd_radius = 15;


% init the precision and recall rates.
PrecisionRecall = zeros(1,2);


% Calculate the ground truth gaze region.
% find the boundaries of the gaze region.
gth_left = gth(1) - gth_radius;
gth_right = gth(1) + gth_radius;
gth_top = gth(2) + gth_radius;
gth_bottom = gth(2) - gth_radius;
% transform angular coord to screen coord.
gth_lefttop = AngularCoord2ScreenCoord([gth_left, gth_top]);
gth_rightbottom = AngularCoord2ScreenCoord([gth_right, gth_bottom]);
% screen coords of the boundaries.
gth_left = gth_lefttop(1);
gth_right = gth_rightbottom(1);
gth_top = gth_lefttop(2);
gth_bottom = gth_rightbottom(2);
% area of ground truth gaze region.
gth_area = (gth_right - gth_left)*(gth_bottom - gth_top);


% Calculate the predicted gaze region.
% find the boundaries of the gaze region.
prd_left = prd(1) - prd_radius;
prd_right = prd(1) + prd_radius;
prd_top = prd(2) + prd_radius;
prd_bottom = prd(2) - prd_radius;
% transform angular coord to screen coord.
prd_lefttop = AngularCoord2ScreenCoord([prd_left, prd_top]);
prd_rightbottom = AngularCoord2ScreenCoord([prd_right, prd_bottom]);
% screen coords of the boundaries.
prd_left = prd_lefttop(1);
prd_right = prd_rightbottom(1);
prd_top = prd_lefttop(2);
prd_bottom = prd_rightbottom(2);
% area of ground truth gaze region.
prd_area = (prd_right - prd_left)*(prd_bottom - prd_top);

% Calculate the area of the overlapped region.
% if no overlapped area.
if prd_left >= gth_right || prd_right <= gth_left || prd_top >= gth_bottom || prd_bottom <= gth_top
    olp_area = 0;
    precision = olp_area/prd_area;
    PrecisionRecall(1) = precision;
    recall = olp_area/gth_area;
    PrecisionRecall(2) = recall;
else
	% the overlapped range.
    olp_left = max(prd_left, gth_left);
	olp_right = min(prd_right, gth_right);
	olp_top = max(prd_top, gth_top);
    olp_bottom = min(prd_bottom, gth_bottom);
    olp_area = (olp_right - olp_left)*(olp_bottom - olp_top);
    precision = olp_area/prd_area;
    PrecisionRecall(1) = precision;
    recall = olp_area/gth_area;
    PrecisionRecall(2) = recall;
end
