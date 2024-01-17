%This Matlab script can be used to reproduce Figure 2.7 in the textbook:
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


%Set the range of the horizontal axis
t = -2:0.01:8;

%Set the parameter sigma^2
sigma2 = 1;


%Compute the PDF of the Rayleigh distribution
f_rayleigh = (2*t/sigma2).*exp(-t.^2/sigma2);
f_rayleigh(t<0) = 0;

%Compute the PDF of the exponential distribution
f_exponential = (1/sigma2).*exp(-t/sigma2);
f_exponential(t<0) = 0;

%Compute the PDF of the chi-squared distribution with 4 degrees of freedom
M = 2;
f_chi2 = t.^(M-1).*exp(-t/sigma2)/(sigma2^M*factorial(M-1));
f_chi2(t<0) = 0;



%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
hold on; box on; grid on;
plot(t,f_rayleigh,'-b','LineWidth',2)
plot(t,f_exponential,'--r','LineWidth',2)
plot(t,f_chi2,'-.k','LineWidth',2)
ax = gca;
set(ax, 'XTick', -2:8);
xlabel('$x$','Interpreter','latex');
ylabel('Probability density function $f(x)$','Interpreter','latex');
set(gca,'fontsize',16);
ylim([-0.1 1.1]);
legend({'Rayleigh$(1/\sqrt{2})$','Exp$(1)$','$\chi^2(4)$'},'Interpreter','latex');

