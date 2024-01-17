%This Matlab script can be used to reproduce Figure 2.8 in the textbook:
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


%Set the parameter sigma^2
sigma2 = 1;


%Compute the exact CDF
a = linspace(0,2,100);
fx = 1-exp(-a.^2/sigma2);

percentiles = [sqrt(log(4/3)) sqrt(log(2)) sqrt(log(4))];
CDFvalues = [0.25 0.5 0.75];

set(groot,'defaultAxesTickLabelInterpreter','latex');


%% Plot simulation result
figure;
hold on; box on; grid on;
plot(a,fx,'k-','LineWidth',2);
plot(percentiles,CDFvalues,'k*','LineWidth',2);

xticks([0 percentiles 2])
yticks(0:0.25:1)
xticklabels({'0','$\sqrt{\ln(\frac{4}{3})}$','$\sqrt{\ln(2)}$','$\sqrt{\ln(4)}$','2'})

xlabel('$x$','Interpreter','latex');
ylabel('Cumulative distribution function','Interpreter','latex');
set(gca,'fontsize',16);
ylim([0 1]);
