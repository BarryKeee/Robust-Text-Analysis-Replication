clear all
clc

%% Run Monte Carlo simulation
Btrue = eye(2); 
Thetatrue = [.2,.8;.8,.2];

MC_draws = 1000; 
Posterior_draws = 1000;

N = 10; 
MC_illustration(N, Btrue, Thetatrue, MC_draws, Posterior_draws);
N = 1000; 
MC_illustration(N, Btrue, Thetatrue, MC_draws, Posterior_draws);

%% Plot MC simulation result
N10 = load("MC_N10.mat");
N1000 = load("MC_N1000.mat");
PlotsMC(N10, N1000);
