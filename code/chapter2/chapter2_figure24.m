%This Matlab script can be used to reproduce Figure 2.24 in the textbook:
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

DClevel1 = 0;
DClevel2 = 1;

sigma2 = 0.5;
x = -2.5:0.01:3.5;

y1 = normpdf(x,DClevel1, sqrt(sigma2));
y2 = normpdf(x,DClevel2, sqrt(sigma2));


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(x,y1,':k','LineWidth',2)
plot(x,y2,'k','LineWidth',2)

ax = gca;
set(ax, 'XTick', [-2, -1, 0, 1, 2, 3]);
xlim([-2.5 3.5]);
ylim([0 0.6]);
xlabel('$y$','Interpreter','latex');
ylabel('Probability density function','Interpreter','latex');
legend({'$\mathcal{H}_0$', '$\mathcal{H}_1$'},'Interpreter','latex');
set(gca,'fontsize',16);
