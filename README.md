# SGaze: A Data-Driven Eye-Head Coordination Model for Realtime Gaze Prediction
Project web-site with more infos and dataset downloading: [link](http://cranehzm.github.io/SGaze).


This repository contains the codes to train and evaluate our model (SGaze).


*Zhiming Hu, et al. "SGaze: A Data-Driven Eye-Head Coordination Model for Realtime Gaze Prediction" IEEE Transactions on Visualization and Computer Graphics (2019).

If you use this code or dataset in your research, please consider citing our paper with the following Bibtex code:

```
@article{Hu_TVCG_SGaze, 
    author = {Zhiming Hu and Congyi Zhang and Sheng Li and Guoping Wang and Dinesh Manocha}, 
    title = {SGaze: A Data-Driven Eye-Head Coordination Model for Realtime Gaze Prediction}, 
    journal = {IEEE Transactions on Visualization and Computer Graphics}, 
    year = {2019}
} 
```
The paper is available at this [link](https://ieeexplore.ieee.org/document/8643434).

## Abstract
```
We present a novel, data-driven eye-head coordination model that can be used for realtime gaze prediction for immersive HMD-based applications without any external hardware or eye tracker. 
Our model (SGaze) is computed by generating a large dataset that corresponds to different users navigating in virtual worlds with different lighting conditions. 
We perform statistical analysis on the recorded data and observe a linear correlation between gaze positions and head rotation angular velocities. 
We also find that there exists a latency between eye movements and head movements. SGaze can work as a software-based realtime gaze predictor and we formulate a time related function between head movement and eye movement and use that for realtime gaze position prediction. 
We demonstrate the benefits of SGaze for gaze-contingent rendering and evaluate the results with a user study.
```	

## Using the dataset

This repository only contains s small part of our dataset. The whole dataset can be downloaded at this [link](http://cranehzm.github.io/SGaze).
