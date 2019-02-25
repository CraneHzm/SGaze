# Copyright (c) 2019/2/19 Hu Zhiming jimmyhu@pku.edu.cn All Rights Reserved.


Codes to train and evaluate our model.
Environment: MATLAB 2018.


# Files:

'EvaluateModels.m': Evaluate the performance of the models.
'EvaluateModels_AngularDistanceCDF.m': Evaluate the models using CDF of angular distances (Run this code after running 'EvaluateModels.m').
'EvaluateModels_PrecisionRecallRates.m': Evaluate the models using precision and recall rates (Run this code after running 'EvaluateModels.m').
'TrainModels.m': Train our model.
'AngularCoord2ScreenCoord.m': Transform the angular coordinates to screen coordinates.
'CalAngularDist.m': Calculate the angular distance (visual angle) between 2 angular gaze positions.
'CalPrecisionRecall.m': Calculate the precision and recall rates.


# Usage:

1. Run 'EvaluateModels.m' to evaluate the already trained model.
2. Run 'EvaluateModels_AngularDistanceCDF.m' and 'EvaluateModels_PrecisionRecallRates.m' to evaluate the performance of the model in terms of CDF of angular distance and precision and recall rates.
3. If you want to retrain the model, run 'TrainModels.m' with your own settings.
4. If you want to evaluate a newly trained model, remember to renew the model parameters in 'EvaluateModels.m'.