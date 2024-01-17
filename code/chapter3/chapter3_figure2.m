%This Matlab script can be used to reproduce Figure 3.2 in the textbook:
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

PdBm = 0:1:50;

P = 10.^(PdBm/10)/1000;

B = 10e6;

betaN0 = 1e6;

C = B*log2(1+P*betaN0/B);

figure;
set(groot,'defaultAxesTickLabelInterpreter','latex');

hold on; box on; grid on;
plot(P,C/1e6,'LineWidth',2);
xlabel('Transmit power [W]','Interpreter','Latex');
ylabel('Capacity [Mbit/s]','Interpreter','Latex');
set(gca,'fontsize',16);
