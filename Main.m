close all; clear all; clc;

% % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % Obtain input-output data % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % %

% System parameters
Sys.parms.g = 9.8;           % Acceleration due to gravity
Sys.parms.alfa = 15;         % Field strength constant
Sys.parms.beta = 12;        % Viscous friction coefficient
Sys.parms.M = 3;             % Mass of the magnet
Sys.Yo = [0.5 0.0];             % Initial condition

% Simulation parameters
Sim.Tstart = 0.0;
Sim.dt = 0.01;
Sim.Tend = 300;

% Excitation signal parameters
Excite.Fnc = @ExcitationSignal;
Excite.AlphaUmin = 0.0;            % Min. amplitude
Excite.AlphaUmax = 4.0;           % Max. amplitude
% Delay mentioned here is the min./max. 
% time it remains at a particular amplitude
Excite.TauUmin = 0.01;             % Min. delay
Excite.TauUmax = 5.0;              % Max. delay

[dat.t, dat.u, dat.y] = GenTrainingData(Sys, Sim, Excite);

% dat = load('data\MagLevTrainingData.mat');
% dat = load('data\MagLevTestDataTR.mat');
% dat = load('data\MagLevTestDataSS.mat');

PostProcess(dat);

function [t, u, y] = GenTrainingData( Sys, Sim, Excite )
% The generated data should capture transient and 
% steady-state behaviour. For transient behaviour, 
% skyline sequence with 0.01s <= TauU <= 1.0s is 
% generated. For, steady-state behaviour, a skyline 
% function with 1.0s <= TauU <= 5.0s is generated. 
% TauU value of 5.0s is chosen because the system 
% delay is observed to be ~4.5s. 
% 
% Furthermore, Early Stopping training methodology 
% in Neural Network Toolbox requires 3 different 
% data sets, each of them almost similarly correlated. 
% Hence, three different data sets with each set having 
% skyline function for transient behaviour in the first 
% 100s and steady-state behaviour for the rest 200s 
% is generated.

        SimTemp.dt = Sim.dt;
        Tstart = [ 0.0 100.01 300.01 400.01 600.01 700.01 ];
        Tend = [ 100 300 400 600 700 900 ];
        ExciteTemp = Excite;
        t= []; u = []; y = [];

        for i = 1:length(Tstart)
                if mod(i,2) == 0
                        ExciteTemp.TauUmin = 1.0;
                        ExciteTemp.TauUmax = 5.0;
                else
                        ExciteTemp.TauUmin = 0.01;
                        ExciteTemp.TauUmax = 1.0;
                end
                SimTemp.Tstart = Tstart(i); SimTemp.Tend = Tend(i);
                [ dat.T, dat.U, dat.Y ] = GenMagLevData( Sys, SimTemp, ExciteTemp );
                t = [t; dat.T]; u = [u; dat.U]; y = [y; dat.Y];
        end

end