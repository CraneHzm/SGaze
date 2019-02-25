% Copyright (c) Hu Zhiming JimmyHu@pku.edu.cn 2018/7/21 All Rights Reserved.

function ScreenCoord = AngularCoord2ScreenCoord(AngularCoord)
% transform the angular coords to screen coords which are in the range of
% 0-1. (0, 0) is the top-left and (1, 1) is the bottom-right.


if size(AngularCoord, 2) ~= 2
    error('AngularCoord must contain 2 elements: (AngularX, AngularY).');
end

% the parameters of our Hmd (HTC Vive).
% Vertical FOV.
VerticalFov = pi*110/180;
% Size of a half screen.
ScreenWidth = 1080;
ScreenHeight = 1200;
% the pixel distance between eye and the screen center.
ScreenDist = 0.5* ScreenHeight/tan(VerticalFov/2);

ScreenCoord = zeros(1,2);

% the X coord.
ScreenCoord(1) = (ScreenDist * tan(pi*AngularCoord(1) / 180) + 0.5*ScreenWidth) / ScreenWidth; 
% the Y coord.
ScreenCoord(2) = (ScreenDist * tan(-pi*AngularCoord(2) / 180) + 0.5*ScreenHeight) / ScreenHeight;


