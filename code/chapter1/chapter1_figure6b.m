%This Matlab script can be used to reproduce Figure 1.6(b) in the textbook:
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

%Transmit powers (dBm)
PdBm = [20 30 40];

%Bandwidth (Hz)
B = 10e6;

%Noise variance (dBm)
sigma2dBm = -174 + 10*log10(B);

%Carrier frequency (GHz)
frequency = 3;

%Propagation distance (meters)
d = 1:1:1000;

%Compute channel gain
beta_dB = -36.7*log10(d)-22.7-26*log10(3);


%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
hold on; box on; grid on;
plot(d,PdBm(3)+beta_dB-sigma2dBm,'r--','LineWidth',2);
plot(d,PdBm(2)+beta_dB-sigma2dBm,'b-','LineWidth',2);
plot(d,PdBm(1)+beta_dB-sigma2dBm,'k-.','LineWidth',2);
xlabel('Distance [m]','Interpreter','Latex');
ylabel('SNR [dB]','Interpreter','Latex');
legend({'$P=10$\,W','$P=1$\,W','$P=0.1$\,W'},'Interpreter','Latex');
ylim([-20 100]);
set(gca,'fontsize',18);

