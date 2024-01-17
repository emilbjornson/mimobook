%This Matlab script can be used to reproduce Figure 5.10 in the textbook:
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


%Create a dense grid of x values for the PDF
x = linspace(0,5,10000);


%Compute the PDF of the channel capacity when having a Rayleigh fading
%channel where q|h|^2/N0 ~ Exp(1). If x is the capacity value, then since 
%q|h|^2/N0 = 2^x-1, we have the CDF 1-exp(-(2^x-1)) and the PDF becomes

y = log(2)*exp(-(2.^x-1)).*2.^x;


%% Plot the simulation results
figure;
set(groot,'defaultAxesTickLabelInterpreter','latex');  

box on; hold on; grid on;
plot(x,y,'b-','LineWidth',2);
xlabel('Capacity $C_h$','Interpreter','latex');
ylabel('Probability density function','Interpreter','latex');
set(gca,'fontsize',16);
xlim([0 5]);
ylim([0 0.7]);

h = area(x(1:800),y(1:800));
set(h, 'LineStyle', 'none');
h(1).FaceColor = [0.85 0.85 0.85];
plot(x,y,'b-','LineWidth',2);
