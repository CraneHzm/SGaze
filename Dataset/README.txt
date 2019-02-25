# Copyright (c) 2019/2/19 Hu Zhiming jimmyhu@pku.edu.cn All Rights Reserved.

# Directories:

'Data': the processed data: 12 pieces of data.
'SceneLabels': label the corresponding scene IDs of the 12 pieces of data.


The processed data include 12 items:

GazeX, GazeY, SalX, SalY, HeadVelX, HeadVelY, HeadAccX, HeadAccY, HeadAccMeanX, HeadAccMeanY, HeadVelStdX, HeadVelStdY


GazeX & GazeY: the gaze positions (deg).
SalX & SalY: the salient positions (deg).
HeadVelX & HeadVelY: the head rotation angular velocity (deg/s).
HeadAccX & HeadAccY: the head rotation acceleration (deg/s^2).
HeadAccMeanX & HeadAccMeanY: the mean of head acceleration in the past 20 ms (deg/s^2).
HeadVelStdX & HeadVelStdY: the standard deviation of head rotation velocity in the past 10 s (deg/s).