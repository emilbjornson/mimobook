%This Matlab script can be used to reproduce Figure 3.3 in the textbook:
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

B = (0:0.01:100)*1e6;

PbetaN0 = 5e6;

C = B.*log2(1+PbetaN0./B);

Clim = PbetaN0*log2(exp(1))*ones(size(C));

figure;
set(groot,'defaultAxesTickLabelInterpreter','latex');

hold on; box on; grid on;
plot(B/1e6,C/1e6,'LineWidth',2);
plot(B/1e6,Clim/1e6,'k--','LineWidth',2);
xlabel('Bandwidth [MHz]','Interpreter','Latex');
ylabel('Capacity [Mbit/s]','Interpreter','Latex');
set(gca,'fontsize',16);