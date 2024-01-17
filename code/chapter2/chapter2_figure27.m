%This Matlab script can be used to reproduce Figure 2.27 in the textbook:
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


prob1_H0 = 1/2;
prob1_H1 = 1/2;

prob2_H0 = 2/3;
prob2_H1 = 1/3;

sigma2 = 0.5;


threshold = 0.01:0.01:3;
PD = zeros(size(threshold));
PFA = zeros(size(threshold));

for t = 1:length(threshold)
    gamma = threshold(t);
    PD(t) = qfunc(sqrt(sigma2)*log(gamma)-1/(2*sqrt(sigma2)));
    PFA(t) = qfunc(sqrt(sigma2)*log(gamma)+1/(2*sqrt(sigma2)));
end


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(threshold,1-PD,'k','LineWidth',2)
plot(threshold,PFA,'r--','LineWidth',2)
plot(threshold, ((1-PD)*prob1_H1+PFA*prob1_H0),'b-.','LineWidth',2)
indexx = find(threshold==1);
plot(threshold(indexx), ((1-PD(indexx))*prob1_H1+PFA(indexx)*prob1_H0),'mx','Linewidth',3,'MarkerSize',15)

ax = gca;
set(ax, 'XTick', [ 0, 1, 2, 3]);

ylim([0 1]);
xlabel('$\gamma$','Interpreter','latex');
ylabel('Probability','Interpreter','latex');
legend({'$P_{\rm M}$', '$P_{\rm FA}$', '$P_{\rm e}$'},'Interpreter','latex');
set(gca,'fontsize',16);

figure;
hold on; box on; grid on;
plot(threshold,1-PD,'k','LineWidth',2)
plot(threshold,PFA,'r--','LineWidth',2)
plot(threshold, ((1-PD)*prob2_H1+PFA*prob2_H0),'b-.','LineWidth',2)
indexx = find(threshold==2);
plot(threshold(indexx), ((1-PD(indexx))*prob2_H1+PFA(indexx)*prob2_H0),'mx','Linewidth',3,'MarkerSize',15)

ax = gca;
set(ax, 'XTick', [ 0, 1, 2, 3]);

ylim([0 1]);
xlabel('$\gamma$','Interpreter','latex');
ylabel('Probability','Interpreter','latex');
legend({'$P_{\rm M}$', '$P_{\rm FA}$', '$P_{\rm e}$'},'Interpreter','latex');
set(gca,'fontsize',16);


