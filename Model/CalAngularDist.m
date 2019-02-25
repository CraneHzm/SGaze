% Copyright (c) Hu Zhiming JimmyHu@pku.edu.cn 2018/7/21 All Rights Reserved.

function angular_dist = CalAngularDist(gth, prd)
% Calculate the angular distance (visual angle) between 2 angular gaze positions.
% gth: the ground truth angular gaze position.
% prd: the predicted angular gaze position.


if size(gth,2) ~= 2
    error('Ground truth gaze data must contain 2 elements.');
end

if size(prd,2) ~= 2
    error('Predicted gaze data must contain 2 elements.');
end

% the parameters of our Hmd (HTC Vive).
% Vertical FOV.
VerticalFov = pi*110/180;
% Size of a half screen.
ScreenWidth = 1080;
ScreenHeight = 1200;
ScreenCenter = 0.5*[ScreenWidth, ScreenHeight];
% the pixel distance between eye and the screen center.
ScreenDist = 0.5* ScreenHeight/tan(VerticalFov/2);



% transform the angular coords to screen coords.
gth = AngularCoord2ScreenCoord(gth);
prd = AngularCoord2ScreenCoord(prd);
% transform the screen coords to pixel coords.
gth(1) = gth(1)*ScreenWidth;
gth(2) = gth(2)*ScreenHeight;
prd(1) = prd(1)*ScreenWidth;
prd(2) = prd(2)*ScreenHeight;

% the distance between eye and gth.
eye2gth = sqrt(ScreenDist.^2 + (gth(1) - ScreenCenter(1)).^2 + (gth(2) - ScreenCenter(2)).^2);
% the distance between eye and prd.
eye2prd = sqrt(ScreenDist.^2 + (prd(1) - ScreenCenter(1)).^2 + (prd(2) - ScreenCenter(2)).^2);
% the distance between gth and prd.
gth2prd = sqrt((prd(1) - gth(1)).^2 + (prd(2) - gth(2)).^2);

% the angular distance between gth and prd.
angular_dist = 180/pi*acos((eye2gth.^2 + eye2prd.^2 - gth2prd.^2)/(2*eye2gth*eye2prd));
