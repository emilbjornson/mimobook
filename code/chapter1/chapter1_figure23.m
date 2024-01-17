%This Matlab script can be used to reproduce Figure 1.23 in the textbook:
%Emil Bjornson and Ozlem Tugfe Demir (2024),
%"Introduction to Multiple Antenna Communications and Reconfigurable Surfaces", 
%Boston-Delft: Now Publishers, http://dx.doi.org/10.1561/9781638283157
%
%This is version 1.0 (Last edited: 2024-01-17)
%
%License: This code is licensed under the GPLv2 license. If you in any way
%use this code for research that results in publications, please cite our
%textbook as described above. You can find the complete code package at
%https://github.com/emilbjornson/mimobook

close all;
clear;

%% Set parameter values
Delta_lambda = -2:0.01:2;

amplitude = 2*cos(pi*Delta_lambda);

%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

figure;
hold on; box on; grid on;
plot(Delta_lambda,abs(amplitude),'b-','LineWidth',2);
xlabel('Path difference: $(d_1-d_2)/\lambda$','Interpreter','Latex');
ylabel('Amplitude','Interpreter','Latex');
set(gca,'fontsize',16); 