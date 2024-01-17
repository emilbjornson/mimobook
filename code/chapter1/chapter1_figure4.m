%This Matlab script can be used to reproduce Figure X.Y in the textbook:
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

%Considered wavelengths (meters)
lambda1 = 0.3;
lambda2 = 0.1;
lambda3 = 0.01;

%Propagation distance (meters)
d = 1:0.1:100;

%Compute channel gain
beta1_linear = (lambda1/(4*pi))^2 ./d.^2;
beta2_linear = (lambda2/(4*pi))^2 ./d.^2;
beta3_linear = (lambda3/(4*pi))^2 ./d.^2;


%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
hold on; box on; grid on;
plot(d,10*log10(beta1_linear),'r--','LineWidth',2);
plot(d,10*log10(beta2_linear),'b-','LineWidth',2);
plot(d,10*log10(beta3_linear),'k-.','LineWidth',2);
xlabel('Distance [m]','Interpreter','Latex');
ylabel('Channel gain [dB]','Interpreter','Latex');
legend({'$f=1$\,GHz','$f=3$\,GHz','$f=30$\,GHz'},'Interpreter','Latex');
set(gca,'fontsize',16);
xticks(0:20:100)
yticks(-110:10:-30)
ylim([-110 -30]);