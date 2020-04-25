# MagLev

The main aim is Neural Network Modelling of a nonlinear Magnetic Levitation System.
-----------------------------------------------------------------------------------
Refer for controller implementation:
Hagan, M. T., H. B. Demuth and O. D. Jesus (2002). An introduction to use of neural networks in control systems. International Journal of Robust and Nonlinear Control, 12(11), 959-985.

Mathematical details of Neural Networks:
Hagan M. (2014). Neural Network Design. 

Learn Neural Network Toolbox (Not the Deep Learning App. of MATLAB):
Beale, M. H., M. T. Hagan, H. B. Demuth (2010). Neural Network Toolbox 7: User's guide, The Mathworks Inc.

All simulations were run on MATLAB R2020a.

-----------------------------------------------------------------------------------

Currently, input-output data is obtained by exciting the Magnetic Levitation System with an Amplitude-modulated Pseudo Ranfom Binary Sequence (APRBS).

![](https://github.com/JohnDoe2576/MagLev/blob/master/fig/png/MagLevTestDataSS.png)

In the data folder, there are 3 files:
1. Input-Output data for 900s (with dt=0.01s). The input signal is a combination of three sets of data of 300s each: 0s-300s is training set, 300s-600s is validation set and 600s-900s is test set for early stopping method. For the early stopping method to avoid overfitting, it is essential for the these three sets to be correlated with each other. These correlations are maintained using the $\tau_U$ parameter in APRBS. In each of the 300s sets, the first 100s designed to capture transient behaviour and the next 200s are designed to capture steady state behaviour.
2. Once a trained Neural network is obtained, it (the network) is excited using APRBS sequences in the other two data-sets. The corresponding network output is compared with that of the actual output (simulated using ode45). This helps in giving an idea of the generalization property of obtained Neural Network.

In the next step, a simple Neural Network (Multi-Layer Perceptron in present day terminology) will be developed for it. A Neural Network model is already developed. The code will be uploaded next week!
