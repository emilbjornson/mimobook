%This Matlab script can be used to reproduce Figure 5.3 in the textbook:
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
clear

%Create a dense grid of x values for PDF
x = linspace(0,10,10000);

%Compute the PDF of a Rayleigh distribution with 1/sqrt(2) as parameter
y = 2*x.*exp(-x.^2);


%% Plot Rayleigh fading distribution
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure; box on;
plot(x,y,'b-','LineWidth',2);
xlabel('$|h|$','Interpreter','latex')
ylabel('Probability density function','Interpreter','latex');
xlim([0 4]);
set(gca,'fontsize',16);
grid on;

figure; box on;
plot(x,y,'b-','LineWidth',2);
xlabel('$|h|$','Interpreter','latex')
ylabel('Probability density function','Interpreter','latex');
set(gca,'Xscale','log');
xlim([1e-3 1e1]);
set(gca,'fontsize',16);
grid on;

