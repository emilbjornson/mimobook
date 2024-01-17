%This Matlab script can be used to reproduce Figure 1.24 in the textbook:
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
p1 = 0.5;
p2 = 0.1;

M = 1:10;

%Compute outage probability
outageProbability1 = p1.^M;
outageProbability2 = p2.^M;


%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

figure;
hold on; box on; grid on;
plot(M,outageProbability1,'r--','LineWidth',2);
plot(M,outageProbability2,'b-','LineWidth',2);
ax = gca;
set(ax, 'YTick', [10^(-10), 10^(-8), 10^(-6), 10^(-4), 10^(-2), 10^(0)]);
xlabel('Number of antennas ($M$)','Interpreter','Latex');
ylabel('Outage probability','Interpreter','Latex');
legend({'$p=0.5$','$p=0.1$'},'Interpreter','Latex');
set(gca,'YScale','log');
set(gca,'fontsize',16);